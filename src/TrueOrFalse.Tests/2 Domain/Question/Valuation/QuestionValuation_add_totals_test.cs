﻿using System.Linq;
using NHibernate;
using NUnit.Framework;
using TrueOrFalse;

namespace TrueOrFalse.Tests
{
    [Category(TestCategories.Programmer)]
    public class QuestionValuation_add_totals_test : BaseTest
    {
        [Test]
        public void Should_update_question_totals()
        {
            var contextQuestion = ContextQuestion.New()
                .AddQuestion(questionText: "QuestionA", solutionText: "AnswerA").AddCategory("A")
                .Persist();

            var questionVal1 = new QuestionValuation{
                                        RelevanceForAll = 50,
                                        RelevancePersonal = 100,
                                        Question = contextQuestion.All[0],
                                        User = contextQuestion.Creator
                                    };

            var questionVal2 = new QuestionValuation{
                                       RelevanceForAll = 10,
                                       RelevancePersonal = 80,
                                       Question = contextQuestion.All[0],
                                       User = contextQuestion.Creator
                                   };

            QuestionInKnowledge.Create(questionVal1);
            QuestionInKnowledge.Create(questionVal2);

            Resolve<ISession>().Evict(contextQuestion.All.First());

            var question = Resolve<QuestionRepo>().GetById(contextQuestion.All.First().Id);
            Assert.That(question.TotalRelevancePersonalAvg, Is.EqualTo(90));
            Assert.That(question.TotalRelevancePersonalEntries, Is.EqualTo(2));
        }
    }
}
