﻿using System;
using TrueOrFalse;

public class AnswerQuestion : IRegisterAsInstancePerLifetime
{
    private readonly QuestionRepo _questionRepo;
    private readonly AnswerHistoryLog _answerHistoryLog;
    private readonly LearningSessionStepRepo _learningSessionStepRepo;

    public AnswerQuestion(QuestionRepo questionRepo, 
                            AnswerHistoryLog answerHistoryLog, 
                            LearningSessionStepRepo learningSessionStepRepo)
    {
        _questionRepo = questionRepo;
        _answerHistoryLog = answerHistoryLog;
        _learningSessionStepRepo = learningSessionStepRepo;
    }

    public AnswerQuestionResult Run(
        int questionId, 
        string answer, 
        int userId, 
        int playerId,
        int roundId)
    {
        var player = Sl.R<PlayerRepo>().GetById(playerId);
        var round = Sl.R<RoundRepo>().GetById(roundId);

        return Run(questionId, answer, userId, (question, answerQuestionResult) => {
            _answerHistoryLog.Run(question, answerQuestionResult, userId, player, round);
        });
    }

    public AnswerQuestionResult Run(
       int questionId,
       string answer,
       int userId,
       int stepId,
        /*for testing*/ DateTime dateCreated = default(DateTime))
    {
        var learningSessionStep = _learningSessionStepRepo.GetById(stepId);

        return Run(questionId, answer, userId, (question, answerQuestionResult) => {
            _answerHistoryLog.Run(question, answerQuestionResult, userId, learningSessionStep: learningSessionStep, dateCreated: dateCreated);
            
            learningSessionStep.AnswerState = StepAnswerState.Answered;
            _learningSessionStepRepo.Update(learningSessionStep);

        });
    }

    public AnswerQuestionResult Run(
        int questionId, 
        string answer, 
        int userId,
        /*for testing*/ DateTime dateCreated = default(DateTime))
    {
        return Run(questionId, answer, userId, (question, answerQuestionResult) => {
            _answerHistoryLog.Run(question, answerQuestionResult, userId, dateCreated: dateCreated); 
        });
    }

    public AnswerQuestionResult Run(
        int questionId,
        int userId,
        bool countLastAnswerAsCorrect = false,
        bool countUnansweredAsCorrect = false,
        /*for testing*/ DateTime dateCreated = default(DateTime))
    {
        
        if(countLastAnswerAsCorrect && countUnansweredAsCorrect)
            throw new Exception("either countLastAnswerAsCorrect OR countUnansweredAsCorrect should be set to true, not both");
        
        if (countLastAnswerAsCorrect)
            return Run(questionId, "", userId,
            (question, answerQuestionResult) =>
                {
                    _answerHistoryLog.CountLastAnswerAsCorrect(question, userId);
                },
            countLastAnswerAsCorrect: true);

        if (countUnansweredAsCorrect)
            return Run(
                questionId, "", userId,
                (question, answerQuestionResult) =>
                    {
                        _answerHistoryLog.CountUnansweredAsCorrect(question, userId);
                    },
                countUnansweredAsCorrect: true);

        throw new Exception("neither countLastAnswerAsCorrect nor countUnansweredAsCorrect true");
    }

    public AnswerQuestionResult Run(
        int questionId, 
        string answer, 
        int userId,
        Action<Question, AnswerQuestionResult> action,
        bool countLastAnswerAsCorrect = false,
        bool countUnansweredAsCorrect = false)
    {
        var question = _questionRepo.GetById(questionId);
        var solution = new GetQuestionSolution().Run(question);

        var result = new AnswerQuestionResult();
        result.IsCorrect = solution.IsCorrect(answer.Trim());
        result.CorrectAnswer = solution.CorrectAnswer();
        result.AnswerGiven = answer;

        action(question, result);

        ProbabilityUpdate_Question.Run(question);
        if (countLastAnswerAsCorrect)
        {
            Sl.R<UpdateQuestionAnswerCount>().ChangeOneWrongAnswerToCorrect(questionId);
        } 
        else
        {
            Sl.R<UpdateQuestionAnswerCount>().Run(questionId, countUnansweredAsCorrect || result.IsCorrect);
        }
        Sl.R<ProbabilityUpdate_Valuation>().Run(questionId, userId);

        return result;
    }
}