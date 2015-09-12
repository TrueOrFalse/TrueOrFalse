﻿using System.Diagnostics;

public class ProbabilityUpdate_Question : IRegisterAsInstancePerLifetime
{
    public static void Run()
    {
        var sp = Stopwatch.StartNew();

        foreach (var question in Sl.R<QuestionRepository>().GetAll())
            Run(question);

        Logg.r().Information("Calculated all question probabilities in {elapsed} ", sp.Elapsed);
    }

    public static void Run(Question question)
    {
        var answerHistoryItems = Sl.R<AnswerHistoryRepository>().GetByQuestion(question.Id);

        question.CorrectnessProbability = ProbabilityCalc_Question.Run(answerHistoryItems);
        question.CorrectnessProbabilityAnswerCount = answerHistoryItems.Count;

        Sl.R<QuestionRepository>().Update(question);
    }
}