﻿using System;
using System.Linq;

public class AnswerLog : IRegisterAsInstancePerLifetime
{
    private readonly AnswerRepo _answerRepo;

    public AnswerLog(AnswerRepo answerRepo)
    {
        _answerRepo = answerRepo;
    }

    public void Run(
        Question question, 
        AnswerQuestionResult answerQuestionResult, 
        int userId,
        Guid questionViewGuid,
        int interactionNumber,
        int millisecondsSinceQuestionView,
        Player player = null,
        Round round = null,
        LearningSession learningSession = null,
        Guid learningSessionStepGuid = default(Guid),
      //  bool countUnansweredAsCorrect = false,
        /*for testing*/ DateTime dateCreated = default(DateTime))
    {
        var answer = new Answer
        {
            Question = question,
            UserId = userId,
            QuestionViewGuid = questionViewGuid,
            InteractionNumber = interactionNumber,
            MillisecondsSinceQuestionView = millisecondsSinceQuestionView,
            AnswerText = answerQuestionResult.AnswerGiven,
            AnswerredCorrectly = answerQuestionResult.IsCorrect ? AnswerCorrectness.True : AnswerCorrectness.False,
            Round = round,
            Player = player,
            LearningSession = learningSession,
            LearningSessionStepGuid = learningSessionStepGuid,
            DateCreated = dateCreated == default(DateTime)
                ? DateTime.Now
                : dateCreated
        };

        _answerRepo.Create(answer);
    }

    public void CountLastAnswerAsCorrect(Question question, int userId)
    {
        var correctedAnswer = _answerRepo.GetByQuestion(question.Id, userId, includingSolutionViews: false).OrderByDescending(x => x.DateCreated).FirstOrDefault();
        if (correctedAnswer != null && correctedAnswer.AnswerredCorrectly == AnswerCorrectness.False)
        {
            correctedAnswer.AnswerredCorrectly = AnswerCorrectness.MarkedAsTrue;
            _answerRepo.Update(correctedAnswer);
        }
    }

    public void CountUnansweredAsCorrect(Question question, int userId)
    {
        var answer = new Answer
        {
            Question = question,
            UserId = userId,
            AnswerText = "",
            AnswerredCorrectly = AnswerCorrectness.MarkedAsTrue,
            DateCreated = DateTime.Now
        };

        _answerRepo.Create(answer);
    }

    public void LogAnswerView(Question question, int userId, Guid questionViewGuid, int interactionNumber, int millisecondsSinceQuestionView, int? roundId = null)
    {
        var answer = new Answer
        {
            Question = question,
            UserId = userId,
            QuestionViewGuid = questionViewGuid,
            InteractionNumber = interactionNumber,
            MillisecondsSinceQuestionView = millisecondsSinceQuestionView,
            AnswerText = "",
            AnswerredCorrectly = AnswerCorrectness.IsView,
            DateCreated = DateTime.Now
        };

        if (roundId != null)
            answer.Round = Sl.R<RoundRepo>().GetById((int) roundId);

        _answerRepo.Create(answer);
    }
}
