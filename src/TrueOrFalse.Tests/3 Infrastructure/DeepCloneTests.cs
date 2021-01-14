﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Utils;
using NUnit.Framework;

namespace TrueOrFalse.Tests
{
    [TestFixture]
    public class DeepCloneTests
    {
        [Test]
        public void Should_clone_category_with_circular_relations()
        {
            //Crate to object with circular reference
            var categoryRoot = new Category { Name = "Root" };
            var categoryA = new Category { Name = "A" };
            categoryRoot.CategoryRelations = new List<CategoryRelation> {
                new CategoryRelation {Category = categoryRoot, RelatedCategory = categoryA, CategoryRelationType = CategoryRelationType.IsChildCategoryOf},
            };

            Assert.That(categoryRoot.DeepClone(), Is.Not.Null);

            categoryA.CategoryRelations = new List<CategoryRelation> {
                new CategoryRelation {Category = categoryA, RelatedCategory = categoryRoot, CategoryRelationType = CategoryRelationType.IsChildCategoryOf},
            };

            //Pre cloning, check that circular reference exists
            Assert.That(categoryRoot.ParentCategories().First().Name, Is.EqualTo("A"));
            Assert.That(categoryA.ParentCategories().First().Name, Is.EqualTo("Root"));
            Assert.That(categoryA.ParentCategories().First().ParentCategories().First().Name, Is.EqualTo("A"));


            //Clone
            var cloneA = categoryA.DeepClone();
            Assert.That(cloneA.ParentCategories().First().Name, Is.EqualTo("Root"));
            Assert.That(cloneA.ParentCategories().First().ParentCategories().First().Name, Is.EqualTo("A"));

        }
    }
}