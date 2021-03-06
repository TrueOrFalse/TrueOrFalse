﻿using System.Collections.Generic;
using Seedworks.Lib.Persistence;
using SolrNet;
using SolrNet.Commands.Parameters;
using static System.String;

namespace TrueOrFalse.Search
{
    public class SearchCategories : IRegisterAsInstancePerLifetime
    {
        private readonly ISolrOperations<CategorySolrMap> _searchOperations;

        public SearchCategories(ISolrOperations<CategorySolrMap> searchOperations){
            _searchOperations = searchOperations;
        }

        public SearchCategoriesResult Run(CategorySearchSpec searchSpec)
        {
            var orderBy = SearchCategoriesOrderBy.None;
            if (searchSpec.OrderBy.BestMatch.IsCurrent())
            {
                orderBy = SearchCategoriesOrderBy.None;

                if (IsNullOrEmpty(searchSpec.SearchTerm))
                    orderBy = SearchCategoriesOrderBy.QuestionCount;

            } 
            else if (searchSpec.OrderBy.QuestionCount.IsCurrent()) 
                orderBy = SearchCategoriesOrderBy.QuestionCount;
            else if (searchSpec.OrderBy.CreationDate.IsCurrent()) 
                orderBy = SearchCategoriesOrderBy.DateCreated;

            var result = Run(searchSpec.SearchTerm, searchSpec, searchSpec.Filter.ValuatorId, orderBy: orderBy);
            searchSpec.SpellCheck = new SpellCheckResult(result.SpellChecking, searchSpec.SearchTerm);

            return result;
        }

        public SearchCategoriesResult Run(
            string searchTerm,
            int valuatorId = -1,
            bool searchOnlyWithStartingWith = false,
            SearchCategoriesOrderBy orderBy = SearchCategoriesOrderBy.None,
            int pageSize = 10)
        {
            return Run(
                searchTerm, 
                new Pager { PageSize = pageSize },
                valuatorId,
                searchOnlyWithStartingWith,
                orderBy
            );
        }

        public SearchCategoriesResult Run(
            string searchTerm,
            Pager pager,
            int valuatorId = -1,
            bool searchOnlyWithStartingWith = false,
            SearchCategoriesOrderBy orderBy = SearchCategoriesOrderBy.None)
        {
            var sqb = new SearchQueryBuilder();

            if (searchOnlyWithStartingWith)
            {
                sqb.Add("FullTextStemmed", searchTerm, startsWith: true)
                   .Add("FullTextExact", searchTerm, startsWith: true)
                   .Add("Name", searchTerm, boost: 1000)
                   .Add("Name", searchTerm, startsWith: true, boost: 99999);
            }
            else
            {
                sqb.Add("FullTextStemmed", searchTerm)
                   .Add("FullTextExact", searchTerm)
                   .Add("FullTextExact", searchTerm, startsWith: true)
                   .Add("Name", searchTerm, boost:1000)
                   .Add("Name", searchTerm, startsWith: true, boost: 99999);
            }

            sqb.Add("ValuatorIds", 
                valuatorId != -1 ? valuatorId.ToString() : null, 
                isAndCondition: true, 
                exact: true);

            var orderby = new List<SortOrder>();
            if (orderBy == SearchCategoriesOrderBy.QuestionCount)
                orderby.Add(new SortOrder("QuestionCount", Order.DESC));
            else if (orderBy == SearchCategoriesOrderBy.DateCreated)
                orderby.Add(new SortOrder("DateCreated", Order.ASC));

            #if DEBUG
                Logg.r().Information("SearchCategories {Query}", sqb.ToString());
            #endif

            var queryResult = _searchOperations.Query(sqb.ToString(),
                new QueryOptions
                {
                    Start = pager.LowerBound - 1,
                    Rows = pager.PageSize,
                    SpellCheck = new SpellCheckingParameters(),
                    OrderBy = orderby
                });

            var result = new SearchCategoriesResult();
            result.QueryTime = queryResult.Header.QTime;
            result.Count = queryResult.NumFound;
            result.SpellChecking = queryResult.SpellChecking;
            result.Pager = pager;

            pager.TotalItems = result.Count;

            foreach (var resultItem in queryResult)
                result.CategoryIds.Add(resultItem.Id);

            return result;
        }       
    }
}