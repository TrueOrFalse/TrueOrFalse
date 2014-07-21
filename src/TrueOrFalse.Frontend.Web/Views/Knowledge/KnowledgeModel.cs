﻿using System.Collections.Generic;
using System.Web.Mvc;
using TrueOrFalse;
using TrueOrFalse.Web.Context;

public class KnowledgeModel : BaseModel
{
    public string UserName
    {
        get
        {
            if (_sessionUser.User == null)
                return "Unbekannte(r)";
            return _sessionUser.User.Name;
        }
    }

    public GetAnswerStatsInPeriodResult AnswersThisWeek;
    public GetAnswerStatsInPeriodResult AnswersThisMonth;
    public GetAnswerStatsInPeriodResult AnswersThisYear;
    public GetAnswerStatsInPeriodResult AnswersLastMonth;
    public GetAnswerStatsInPeriodResult AnswersLastWeek;
    public GetAnswerStatsInPeriodResult AnswersLastYear;
    public GetAnswerStatsInPeriodResult AnswersEver;

    public int QuestionsCount;
    public int QuestionsSetCount;

    public KnowledgeModel()
    {
        var getWishQuestionCount = Resolve<GetWishQuestionCountCached>();
        QuestionsCount = getWishQuestionCount.Run(UserId);

        var getAnswerStatsInPeriod = Resolve<GetAnswerStatsInPeriod>();
        AnswersThisWeek = getAnswerStatsInPeriod.RunForThisWeek(UserId);
        AnswersThisMonth = getAnswerStatsInPeriod.RunForThisMonth(UserId);
        AnswersThisYear = getAnswerStatsInPeriod.RunForThisYear(UserId);
        AnswersLastWeek = getAnswerStatsInPeriod.RunForLastWeek(UserId);
        AnswersLastMonth = getAnswerStatsInPeriod.RunForLastMonth(UserId);
        AnswersLastYear = getAnswerStatsInPeriod.RunForLastYear(UserId);
        AnswersEver = getAnswerStatsInPeriod.Run(UserId);
    }
}