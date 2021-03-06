﻿using System.Linq;
using NHibernate.Util;
using NUnit.Framework;
using TrueOrFalse.Tests;

[TestFixture]
class CategoryChange_tests : BaseTest
{
    [Test]
    public void Should_save_category_changes()
    {
        var category = ContextCategory.New().Add("Category 1").Persist().All[0];
        category.Name = "Category 2";

        Sl.CategoryRepo.Update(category);

        Assert.That(Sl.CategoryRepo.GetAllEager().ToList().First().Name, Is.EqualTo("Category 2"));
    }
}