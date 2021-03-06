﻿using System.Collections.Generic;
using System.Linq;
using System.Web;
using NUnit.Framework;
using Seedworks.Web.State;

namespace TrueOrFalse.Tests
{
    public class UserValuationCache_tests : BaseTest
    {
        [Test]
        [Ignore("failing")]
        public void Run()
        {
            var categoryContext = ContextCategory.New().Add("1").Add("2").Add("3").Persist();

            var category1 = Sl.R<CategoryRepository>().GetByName("1").FirstOrDefault();
            var category2 = Sl.R<CategoryRepository>().GetByName("2").FirstOrDefault();
            var category3 = Sl.R<CategoryRepository>().GetByName("3").FirstOrDefault();

            var questionContext =
                ContextQuestion.New()
                    .AddQuestion(questionText: "Question1", solutionText: "Answer", categories: new List<Category> { category1 })
                    .AddQuestion(questionText: "Question2", solutionText: "Answer", categories: new List<Category> { category2 })
                    .AddQuestion(questionText: "Question3", solutionText: "Answer", categories: new List<Category> { category3 })
                    .Persist();

            var user = ContextUser.GetUser();

            foreach (var category in categoryContext.All)
            {
                CategoryInKnowledge.Pin(category.Id, user);
            }

            RecycleContainer();

            Assert.That(HttpRuntime.Cache.Count, Is.EqualTo(0));
            Assert.That(Cache.Count, Is.EqualTo(0));

            var cache = HttpRuntime.Cache;

            var cacheItem = UserCache.GetItem(user.Id);

            Assert.That(cacheItem.CategoryValuations.Count, Is.EqualTo(3));

            cacheItem.CategoryValuations.TryRemove(cacheItem.CategoryValuations.Keys.First(), out var catValout);

            var cacheItem2 = UserCache.GetItem(user.Id);

            Assert.That(cacheItem2.CategoryValuations.Count, Is.EqualTo(2));

            Assert.That(HttpRuntime.Cache.Count, Is.EqualTo(1));

        }

        [Test]
        [Ignore("failing")]
        public void Foo()
        {
            var knowledgeSummary = KnowledgeSummaryLoader.RunFromDbCache(-1, -1);
        }
    }
}
