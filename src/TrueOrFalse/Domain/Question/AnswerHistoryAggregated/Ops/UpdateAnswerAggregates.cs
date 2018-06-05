﻿using System;
using System.Linq;

public class UpdateAnswerAggregates
{
    /// <summary>
    /// Considers all answers ever given
    /// </summary>
    public static void FullUpdate()
    {
        Logg.r().Information("UpdateAnswerAggregates");

        var users = Sl.UserRepo.GetAll();
        var answerAggregatedRepo = Sl.AnswerAggregatedRepo;

        var allAggregatedEntries = answerAggregatedRepo.GetAll();

        var historyEntry = Sl.JobHistoryRepo.GetLastUpdateAnswerAggregates();

        if (historyEntry != null)
        {
            users = users
                .Where(user => user.LastLogin != null && user.LastLogin > historyEntry.FinishedAt)
                .ToList();
        }

        foreach (var user in users)
        {
            Logg.r().Information("UpdateAnswerAggregates: Start user {0}", user.Id);

            var allAnswersByQuestion = Sl.AnswerRepo
                .GetByUser(user.Id)
                .GroupBy(answer => answer.Question.Id);

            foreach (var answersByQuestion in allAnswersByQuestion)
            {
                var questionId = answersByQuestion.Key;

                var entryByQuestionAndUserId = 
                    allAggregatedEntries.FirstOrDefault(x => x.QuestionId == questionId && x.UserId == user.Id);

                var totalPerUser = Sl.R<TotalsPersUserLoader>().Run(user.Id, questionId);

                if (entryByQuestionAndUserId == null)
                {
                    var answerAggregated = new AnswerAggregated();

                    answerAggregated.LastUpdated = DateTime.Now;
                    answerAggregated.UserId = user.Id;
                    answerAggregated.QuestionId = questionId;

                    answerAggregated.TotalFalse = totalPerUser.TotalFalse;
                    answerAggregated.TotalTrue = totalPerUser.TotalTrue;

                    answerAggregatedRepo.Create(answerAggregated);
                }
                else
                {
                    entryByQuestionAndUserId.LastUpdated = DateTime.Now;

                    entryByQuestionAndUserId.TotalFalse = totalPerUser.TotalFalse;
                    entryByQuestionAndUserId.TotalTrue = totalPerUser.TotalTrue;
                    answerAggregatedRepo.Update(entryByQuestionAndUserId);
                }
            }
        }
    }
}