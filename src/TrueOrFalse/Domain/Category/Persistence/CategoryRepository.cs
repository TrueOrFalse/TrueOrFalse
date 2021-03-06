﻿using NHibernate;
using NHibernate.Criterion;
using System;
using System.Collections.Generic;
using System.Linq;
using FluentNHibernate.Utils;
using TrueOrFalse.Search;

public class CategoryRepository : RepositoryDbBase<Category>
{
    private readonly SearchIndexCategory _searchIndexCategory;

    public CategoryRepository(ISession session, SearchIndexCategory searchIndexCategory)
        : base(session)
    {
        _searchIndexCategory = searchIndexCategory;
        _searchIndexCategory = searchIndexCategory;
    }

    public Category GetByIdEager(int categoryId) => GetByIdsEager(new[] { categoryId }).FirstOrDefault();

    public IList<Category> GetByIdsEager(IEnumerable<int> categoryIds = null)
    {
        var query = _session.QueryOver<Category>();

        if (categoryIds != null)
            query = query.Where(Restrictions.In("Id", categoryIds.ToArray()));
        else
        {
            //warmup entity cache
            var users = _session
                .QueryOver<User>()
                .Fetch(SelectMode.Fetch, u => u.MembershipPeriods)
                .List();
        }

        var result = query.Left.JoinQueryOver<CategoryRelation>(s => s.CategoryRelations)
            .Left.JoinQueryOver(x => x.RelatedCategory)
            .Left.JoinQueryOver(u => u.Creator)
            .List()
            .GroupBy(c => c.Id)
            .Select(c => c.First())
            .ToList();

        foreach (var category in result)
        {
            NHibernateUtil.Initialize(category.Creator);
            NHibernateUtil.Initialize(category.CategoryRelations);
        }

        return result;
    }

    public IList<Category> GetAllEager() => GetByIdsEager();

    public override void Create(Category category)
    {
        foreach (var related in category.ParentCategories().Where(x => x.DateCreated == default(DateTime)))
            related.DateModified = related.DateCreated = DateTime.Now;

        base.Create(category);
        Flush();
        
        if (category.Creator != null)
            UserActivityAdd.CreatedCategory(category);

        _searchIndexCategory.Update(category);
        EntityCache.AddOrUpdate(category);

        Sl.CategoryChangeRepo.AddCreateEntry(category, category.Creator);
    }

    /// <summary>
    /// Update method for internal purpose, takes care that no change sets are created.
    /// </summary>
    public override void Update(Category category) => Update(category);

    // ReSharper disable once MethodOverloadWithOptionalParameter
    public void Update(Category category, User author = null, bool imageWasUpdated = false, bool isFromModifiyRelations = false)
    {
        if(!isFromModifiyRelations) 
            _searchIndexCategory.Update(category);

        base.Update(category);

        if (author != null)
            Sl.CategoryChangeRepo.AddUpdateEntry(category, author, imageWasUpdated);

        Flush();

        Sl.R<UpdateQuestionCountForCategory>().Run(new List<Category> { category });
        EntityCache.AddOrUpdate(category);
        UserEntityCache.ChangeCategoryInUserEntityCaches(category);

        JobExecute.RunAsTask(scope =>
        {
            GraphService.AutomaticInclusionOfChildThemes(EntityCache.GetCategory(category.Id));
        }, "AutomaticInclusionOfChildThemes");
    }

    public void UpdateWithoutFlush(Category category)
    {
        base.Update(category);
        Sl.R<UpdateQuestionCountForCategory>().Run(new List<Category> { category });
        EntityCache.AddOrUpdate(category);
    }

    public void UpdateBeforeEntityCacheInit(Category category)
    {
        _searchIndexCategory.Update(category);
        base.Update(category);

        Flush();
    }

    public override void Delete(Category category)
    {
        var allCategories = EntityCache.GetChildren(category);

        _searchIndexCategory.Delete(category);
        base.Delete(category);

        foreach (var category1 in allCategories)
        {
            category1.CategoryRelations = category1.CategoryRelations.Where(cr => cr.RelatedCategory.Id != category.Id && cr.Category.Id != category.Id).ToList();
            EntityCache.AddOrUpdate(category1);
        }
        EntityCache.Remove(category);
        UserCache.RemoveAllForCategory(category.Id);
        UserEntityCache.ReInitAllActiveCategoryCaches();
    }

    public override void DeleteWithoutFlush(Category category)
    {
        _searchIndexCategory.Delete(category);
        base.DeleteWithoutFlush(category);
        EntityCache.Remove(category);
        UserCache.RemoveAllForCategory(category.Id);
    }

    public IList<Category> GetByName(string categoryName)
    {
        categoryName = categoryName ?? "";

        return _session.CreateQuery("from Category as c where c.Name = :categoryName")
                        .SetString("categoryName", categoryName)
                        .List<Category>();
    }

    public IList<Category> GetByIds(List<int> questionIds)
    {
        return GetByIds(questionIds.ToArray());
    }

    public IList<Category> GetByIdsFromString(string idsString)
    {
        return idsString
                .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => Convert.ToInt32(x))
                .Select(GetById)
                .Where(set => set != null)
                .ToList();
    }

    public IList<Category> GetIncludingCategories(Category category, bool includingSelf = true)
    {
        var includingCategories = GetCategoriesForRelatedCategory(category, CategoryRelationType.IncludesContentOf);

        if (includingSelf)
            includingCategories = includingCategories.Union(new List<Category> { category }).ToList();

        return includingCategories;

    }

    public IList<Category> GetCategoriesForRelatedCategory(Category relatedCategory, CategoryRelationType relationType = CategoryRelationType.None)
    {
        var query = _session.QueryOver<CategoryRelation>()
            .Where(r => r.CategoryRelationType == CategoryRelationType.IncludesContentOf
                        && r.RelatedCategory == relatedCategory);

        if (relationType != CategoryRelationType.None)
        {
            query.Where(r => r.CategoryRelationType == relationType);
        }

        return query.List()
            .Select(r => r.Category)
            .ToList();
    }


    public IList<Category> GetChildren(int categoryId)
    {
        var categoryIds = _session.CreateSQLQuery($@"SELECT Category_id
            FROM relatedcategoriestorelatedcategories
            WHERE  Related_id = {categoryId} 
            AND CategoryRelationType = {(int)CategoryRelationType.IsChildCategoryOf}").List<int>();
        return GetByIds(categoryIds.ToArray());
    }

    public IList<Category> GetChildren(
        CategoryType parentType,
        CategoryType childrenType,
        int parentId,
        String searchTerm = "")
    {
        Category relatedCategoryAlias = null;
        Category categoryAlias = null;

        var query = Session
            .QueryOver<CategoryRelation>()
            .JoinAlias(c => c.RelatedCategory, () => relatedCategoryAlias)
            .JoinAlias(c => c.Category, () => categoryAlias)
            .Where(r =>
                r.CategoryRelationType == CategoryRelationType.IsChildCategoryOf
                && relatedCategoryAlias.Type == parentType
                && relatedCategoryAlias.Id == parentId
                && categoryAlias.Type == childrenType);

        if (!String.IsNullOrEmpty(searchTerm))
            query.WhereRestrictionOn(r => categoryAlias.Name)
                .IsLike(searchTerm);

        return query.Select(r => r.Category).List<Category>();
    }

    public IList<Category> GetDescendants(int parentId)
    {
        var currentGeneration = EntityCache.GetCategory(parentId,getDataFromEntityCache: true).CachedData.Children.ToList();
        var nextGeneration = new List<Category>();
        var descendants = new List<Category>();

        while (currentGeneration.Count > 0)
        {
            descendants.AddRange(currentGeneration);

            foreach (var category in currentGeneration)
            {
                var children = EntityCache.GetCategory(category.Id, getDataFromEntityCache: true)
                    .CachedData
                    .Children
                    .ToList();

                if (children.Count > 0)
                {
                    nextGeneration.AddRange(children);
                }
            }

            currentGeneration = nextGeneration.Except(descendants).Where(c => c.Id != parentId).Distinct().ToList();
            nextGeneration = new List<Category>();
        }

        return descendants;
    }

    public IList<UserTinyModel> GetAuthors(int categoryId, bool filterUsersForSidebar = false)
    {
        var allAuthors = Sl.CategoryChangeRepo
            .GetForCategory(categoryId, filterUsersForSidebar)
            .Select(categoryChange => new UserTinyModel(categoryChange.Author));

        return allAuthors.GroupBy(a => a.Id)
            .Select(groupedAuthor => groupedAuthor.First())
            .ToList();
    }

    public int CountAggregatedQuestions(int categoryId)
    {
        var count = _session.CreateSQLQuery($@"
        SELECT COUNT(DISTINCT(questionId)) FROM 
        (
	        SELECT DISTINCT(cq.Question_id) questionId
            FROM categories_to_questions cq
            WHERE cq.Category_id = {categoryId}

            UNION

            SELECT DISTINCT(qs.Question_id) questionId
	        FROM relatedcategoriestorelatedcategories rc
	        INNER JOIN category c
	        ON rc.Related_Id = c.Id
	        INNER JOIN categories_to_sets cs
	        ON c.Id = cs.Category_id
	        INNER JOIN questioninset qs
	        ON cs.Set_id = qs.Set_id
	        WHERE rc.Category_id = {categoryId}
	        AND rc.CategoryRelationType = {(int)CategoryRelationType.IncludesContentOf} 
	
	        UNION
	
	        SELECT DISTINCT(cq.Question_id) questionId 
	        FROM relatedcategoriestorelatedcategories rc
	        INNER JOIN category c
	        ON rc.Related_Id = c.Id
	        INNER JOIN categories_to_sets cs
	        ON c.Id = cs.Category_id
	        INNER JOIN categories_to_questions cq
	        ON c.Id = cq.Category_id
	        WHERE rc.Category_id = {categoryId}
	        AND rc.CategoryRelationType = {(int)CategoryRelationType.IncludesContentOf}
        ) c
        ").UniqueResult<long>();//Union is distinct by default
        return (int)count;
    }

    public override IList<Category> GetByIds(params int[] categoryIds)
    {
        var resultTmp = base.GetByIds(categoryIds);

        var result = new List<Category>();
        for (int i = 0; i < categoryIds.Length; i++)
        {
            if (resultTmp.Any(c => c.Id == categoryIds[i]))
                result.Add(resultTmp.First(c => c.Id == categoryIds[i]));
        }
        return result;
    }

    public IEnumerable<Category> GetWithMostQuestions(int amount)
    {
        return _session
            .QueryOver<Category>()
            .OrderBy(c => c.CountQuestionsAggregated).Desc
            .Take(amount)
            .List();
    }

    public IEnumerable<Category> GetMostRecent_WithAtLeast3Questions(int amount)
    {
        return _session
            .QueryOver<Category>()
            .Where(c => c.CountQuestionsAggregated > 3 || c.CountQuestions > 3)
            .OrderBy(c => c.DateCreated)
            .Desc
            .Take(amount)
            .List();
    }

    public bool Exists(string categoryName)
    {
        return GetByName(categoryName).Any(x => x.Type == CategoryType.Standard);
    }


    public int TotalCategoryCount()
    {
        return _session.QueryOver<Category>()
            .RowCount();
    }

    public const int AllgemeinwissenId = 709;

    public Category Allgemeinwissen => EntityCache.GetCategory(AllgemeinwissenId);

    public List<Category> GetRootCategoriesList()
    {
        return new List<Category>
        {
            EntityCache.GetCategory(682, true), //Schule
            EntityCache.GetCategory(687, true), //Studium
            EntityCache.GetCategory(689, true), //Zertifikate
            EntityCache.GetCategory(AllgemeinwissenId, true) //Allgemeinwissen
        };
    }
}