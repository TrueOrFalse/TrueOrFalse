﻿using System.Collections.Generic;
using System.Linq;
using FluentNHibernate.Utils;
using NUnit.Framework;
using TrueOrFalse.Tests;

class GraphService_tests : BaseTest
{
    [Test]
    public void Should_get_correct_category()
    {
        var context = ContextCategory.New();

        var rootElement = context.Add("RootElement").Persist().All.First();

        var firstChildrens = context
            .Add("Sub1", parent: rootElement)
            .Persist()
            .All;

        var secondChildren = context.
            Add("SubSub1", parent: firstChildrens.ByName("Sub1"))
            .Persist()
            .All
            .ByName("SubSub1");


        // Add User
        var user = ContextUser.New().Add("User").Persist().All[0];


        CategoryInKnowledge.Pin(firstChildrens.ByName("SubSub1").Id, user);

        Sl.SessionUser.Login(user);
        var lastChildren = GraphService.GetLastWuwiChildrenFromCategories(rootElement.Id);

        Assert.That(lastChildren.First().Name, Is.EqualTo("SubSub1"));

    }



    [Test]
    public void Should_get_correct_category_with_relations()
    {

        var test =
            @"
Arrange: 

A -> B -> +C
A(2) -> B(4) -> +C(5)


Act:
Filter nur Wunschwissen

Assert:
A -> C
";

        var context = ContextCategory.New();

        var rootElement = context.Add("RootElement").Persist().All.First();

        var firstChildrens = context
            .Add("Sub1", parent: rootElement)
            .Persist()
            .All;

        var secondChildren = context.
            Add("SubSub1", parent: firstChildrens.ByName("Sub1"))
            .Persist()
            .All
            .ByName("SubSub1");


        // Add User
        var user = ContextUser.New().Add("User").Persist().All[0];


        CategoryInKnowledge.Pin(firstChildrens.ByName("SubSub1").Id, user);

        Sl.SessionUser.Login(user);
      var userPersonelCategoriesWithRealtions =   GraphService.GetAllPersonelCategoriesWithRealtions(rootElement, 2);

      Assert.That(userPersonelCategoriesWithRealtions.First().Name, Is.EqualTo("SubSub1"));
      Assert.That(userPersonelCategoriesWithRealtions.First().CategoryRelations.First().RelatedCategory.Name, Is.EqualTo("RootElement"));
      Assert.That(userPersonelCategoriesWithRealtions.First().CategoryRelations.First().Category.Name, Is.EqualTo("SubSub1"));
      Assert.That(userPersonelCategoriesWithRealtions.First().CategoryRelations.First().CategoryRelationType, Is.EqualTo(CategoryRelationType.IsChildCategoryOf));

    }
    [Test]
    public void Wish_knowledge_filter_simple_test()
    {
        // Case https://docs.google.com/drawings/d/1Wbne-XXmYkA578uSc6nY0mxz_s-pG8E9Q9flmgY2ZNY/

        var context = ContextCategory.New();

        var rootElement = context.Add("A").Persist().All.First();

        var firstChildren = context
            .Add("B", parent: rootElement)
            .Add("C", parent:rootElement)
            .Persist()
            .All;

        var secondChildren = context
            .Add("H", parent: firstChildren.ByName("C"))
            .Add("G", parent: firstChildren.ByName("C"))
            .Add("F", parent: firstChildren.ByName("C"))
            .Add("E", parent: firstChildren.ByName("C"))
            .Add("D", parent: firstChildren.ByName("B"))
            .Persist()
            .All;

        context
            .Add("I", parent: secondChildren.ByName("C"))
            .Persist();

        context
            .Add("I", parent: secondChildren.ByName("E"))
            .Persist();

        context.Add("I", parent: secondChildren.ByName("G"))
            .Persist();


        var user = ContextUser.New().Add("User").Persist().All[0];

        // Add in WUWI
        CategoryInKnowledge.Pin(firstChildren.ByName("C").Id, user);
        CategoryInKnowledge.Pin(firstChildren.ByName("G").Id, user);
        CategoryInKnowledge.Pin(firstChildren.ByName("E").Id, user);
        CategoryInKnowledge.Pin(firstChildren.ByName("I").Id, user);

        Sl.SessionUser.Login(user);

        var userPersonelCategoriesWithRealtions = GraphService.GetAllPersonelCategoriesWithRealtions(rootElement,2);

        //Test C
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
            .ByName("C").CategoryRelations), 
            Is.EqualTo(true));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("C")
                .CategoryRelations
                .First()
                .RelatedCategory.Id,
                Is.EqualTo(rootElement.Id));

        Assert.That(userPersonelCategoriesWithRealtions
            .ByName("C").CategoryRelations
            .First()
            .Category.Id, 
            Is.EqualTo(secondChildren.ByName("C").Id));


        //Test I
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
            .ByName("I").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(userPersonelCategoriesWithRealtions
            .ByName("I")
            .CategoryRelations
            .First()
            .RelatedCategory.Id,
            Is.EqualTo(secondChildren.ByName("C").Id));

        Assert.That(userPersonelCategoriesWithRealtions
            .ByName("I")
            .CategoryRelations
            .First()
            .Category.Id, 
            Is.EqualTo(secondChildren.ByName("I").Id));

        var relationId = userPersonelCategoriesWithRealtions
            .ByName("I")
            .CategoryRelations.Where(cr => cr.RelatedCategory.Name == "E" ).Select(cr => cr.RelatedCategory.Id).First();
           
        Assert.That(relationId,
            Is.EqualTo(secondChildren.ByName("E").Id));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("I")
                .CategoryRelations[1]
                .Category.Id,
            Is.EqualTo(secondChildren.ByName("I").Id));

        relationId = userPersonelCategoriesWithRealtions
            .ByName("I")
            .CategoryRelations.Where(cr => cr.RelatedCategory.Name == "G").Select(cr => cr.RelatedCategory.Id).First();

        Assert.That(relationId,
            Is.EqualTo(secondChildren.ByName("G").Id));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("I")
                .CategoryRelations[2]
                .Category.Id,
            Is.EqualTo(secondChildren.ByName("I").Id));


        // Test G 
        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("G").CategoryRelations
                .First()
                .CategoryRelationType,
            Is.EqualTo(CategoryRelationType.IsChildCategoryOf));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("G")
                .CategoryRelations
                .First()
                .RelatedCategory.Id,
            Is.EqualTo(firstChildren.ByName("C").Id));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("G").CategoryRelations
                .First()
                .Category.Id,
            Is.EqualTo(secondChildren.ByName("G").Id));

        // Test E

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("E").CategoryRelations
                .First()
                .CategoryRelationType,
            Is.EqualTo(CategoryRelationType.IsChildCategoryOf));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("E")
                .CategoryRelations
                .First()
                .RelatedCategory.Id,
            Is.EqualTo(firstChildren.ByName("C").Id));

        Assert.That(userPersonelCategoriesWithRealtions
                .ByName("E").CategoryRelations
                .First()
                .Category.Id,
            Is.EqualTo(secondChildren.ByName("E").Id));

    }

    [Test]
    public void Wish_knowledge_filter_middle_test()
    {
        ContextCategory.New().AddCaseTwoToCache();
        var rootElement = EntityCache.GetAllCategories().First();

        var userPersonelCategoriesWithRealtions = GraphService.GetAllPersonelCategoriesWithRealtions(rootElement,2);

        //Test I
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
           .ByName("I").CategoryRelations)
           , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
            .ByName("I")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "A"),
            Is.EqualTo(false));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "E" ),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "G"),
            Is.EqualTo(true));

        //Test B
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("B").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("B")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("B"), "A"),
            Is.EqualTo(true));

        //Test E
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("E").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("E")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("E"), "A"),
            Is.EqualTo(true));

        //Test G
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("G").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("G")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("G"), "A"),
            Is.EqualTo(true));
    }
    [Test]
    public void Wish_knowledge_filter_complex_test()
    {
        ContextCategory.New().AddCaseThreeToCache();
        UserEntityCache.Init(true);
        var rootElement = EntityCache.GetAllCategories().ByName("A"); 

        var userPersonelCategoriesWithRealtions = GraphService.GetAllPersonelCategoriesWithRealtions(rootElement, 2);


        //Test I
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("I").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("I")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "A"),
            Is.EqualTo(false));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "G"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "X3"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("I"), "X"),
            Is.EqualTo(true));


        //Test G
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("G").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("G")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("G"), "X3"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("G"), "X"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("G"), "A"),
            Is.EqualTo(false));


        //Test F
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("F").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("F")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("F"), "X3"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("F"), "X"),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("F"), "A"),
            Is.EqualTo(false));

        //Test X3
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("X3").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("X3")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("X3"), "A"),
            Is.EqualTo(true));

        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("X").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("X")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("X"), "A"),
            Is.EqualTo(true));
    }

    [Test]
    public void Wish_knowledge_filter_special_case()
    {
        https://docs.google.com/drawings/d/1CWJoFSk5aAJf1EOpWqf1Ffr6ncjwxpOcJqFWZEXUVk4

        var context = ContextCategory.New();

        var rootElement = context.Add("A").Persist().All.First();

        var firstChildren = context
            .Add("B", parent: rootElement)
            .Add("C", parent: rootElement)
            .Add("D", parent: rootElement)
            .Persist()
            .All;

        context
            .Add("D", parent: firstChildren.ByName("C"))
            .Persist();

        var secondChildren = context
            .Add("E", parent: firstChildren.ByName("C"))
            .Persist()
            .All;

        var ThirdChild = context
            .Add("F", parent: firstChildren.ByName("E"))
            .Persist()
            .All;

        var user = ContextUser.New().Add("User").Persist().All[0];

        // Add in WUWI
        CategoryInKnowledge.Pin(firstChildren.ByName("F").Id, user);
        
        Sl.SessionUser.Login(user);

        var userPersonelCategoriesWithRealtions = GraphService.GetAllPersonelCategoriesWithRealtions(rootElement, 2);

        //Test F
        Assert.That(IsAllRelationsAChildOf(userPersonelCategoriesWithRealtions
                .ByName("F").CategoryRelations)
            , Is.EqualTo(true));

        Assert.That(IsCategoryRelationsCategoriesIdCorrect(userPersonelCategoriesWithRealtions
                .ByName("F")),
            Is.EqualTo(true));

        Assert.That(HasCorrectParent(userPersonelCategoriesWithRealtions
                .ByName("F"), "A"),
            Is.EqualTo(true));
        Assert.That(userPersonelCategoriesWithRealtions.First().CategoryRelations.Count, Is.EqualTo(1));

    }

    [Test]
    public void Without_wish_knowledge()
    {
        ContextCategory.New().AddCaseThreeToCache(false);
        var rootElement = EntityCache.GetAllCategories().ByName("A");

        var userPersonelCategoriesWithRealtions = GraphService.GetAllPersonelCategoriesWithRealtions(rootElement, 2);
        Assert.That(userPersonelCategoriesWithRealtions.Count, Is.EqualTo(1)); //root topic is ever available
    }

    [Test]
    public void Should_delete_all_includes_content_of_relations()
    {
        ContextCategory.New().AddCaseThreeToCache();
        var rootCategoryOrginal = EntityCache.GetAllCategories().First().DeepClone();

        Category rootCategorieCopy2 = rootCategoryOrginal.DeepClone();
        Category rootCategorieCopy1 = rootCategoryOrginal.DeepClone();

        var result = GraphService.IsCategoryRelationEqual(rootCategorieCopy1, rootCategorieCopy2);
        Assert.That(result, Is.EqualTo(true));

        rootCategorieCopy1.Name = "geändert";
        result = GraphService.IsCategoryRelationEqual(rootCategorieCopy1, rootCategorieCopy2);
        Assert.That(result, Is.EqualTo(true));

        rootCategorieCopy1.CategoryRelations = new List<CategoryRelation>
        {
            new CategoryRelation
            {
                RelatedCategory = new Category{Id = 222},
                CategoryRelationType = CategoryRelationType.IsChildCategoryOf,
                Category = new Category{Id = 111}
            }
        };

        rootCategorieCopy2.CategoryRelations = new List<CategoryRelation>
        {
            new CategoryRelation
            {
                RelatedCategory = new Category{Id = 222},
                CategoryRelationType = CategoryRelationType.IsChildCategoryOf,
                Category = new Category{Id = 111}

            }
        };

        result = GraphService.IsCategoryRelationEqual(rootCategorieCopy1, rootCategorieCopy2);
        Assert.That(result, Is.EqualTo(true));


        rootCategorieCopy2.CategoryRelations = new List<CategoryRelation>
        {
            new CategoryRelation
            {
                RelatedCategory = new Category{Id = 222},
                CategoryRelationType = CategoryRelationType.IsChildCategoryOf,
                Category = new Category{Id = 113}

            }
        };

        result = GraphService.IsCategoryRelationEqual(rootCategorieCopy1, rootCategorieCopy2);
        Assert.That(result, Is.EqualTo(false));

        rootCategorieCopy1.CategoryRelations = new List<CategoryRelation>
        {
            new CategoryRelation
            {
                RelatedCategory = new Category{Id = 222},
                CategoryRelationType = CategoryRelationType.IsChildCategoryOf,
                Category = new Category{Id = 111}
            }
        };

        rootCategorieCopy2.CategoryRelations = new List<CategoryRelation>
        {
            new CategoryRelation
            {
                RelatedCategory = new Category{Id = 222},
                CategoryRelationType = CategoryRelationType.IsChildCategoryOf,
                Category = new Category{Id = 112}

            }
        };

        result = GraphService.IsCategoryRelationEqual(rootCategorieCopy1, rootCategorieCopy2);
        Assert.That(result, Is.EqualTo(false));
    }

    private bool IsAllRelationsAChildOf(IList<CategoryRelation> categoryRelations)
    {
        var result = true;
        foreach (var cr in categoryRelations)
        {
            if (cr.CategoryRelationType != CategoryRelationType.IsChildCategoryOf)
                result = false;
        }

        return result; 
    }

    private bool HasCorrectParent(Category category, string nameParent)
    {
        return category.CategoryRelations.Any(cr => cr.RelatedCategory.Name == nameParent);
    }

    private bool IsCategoryRelationsCategoriesIdCorrect(Category category)
    {
        return category.CategoryRelations.Select(cr => cr.Category.Name == category.Name).All(b => b == true);
    }

}

