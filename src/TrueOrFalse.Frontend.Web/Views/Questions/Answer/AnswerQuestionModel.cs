﻿using System;
using System.Collections.Generic;
using System.Web.Mvc;
using TrueOrFalse;
using TrueOrFalse.Core;
using TrueOrFalse.Frontend.Web.Code;
using TrueOrFalse.Frontend.Web.Models;


public class AnswerQuestionModel : ModelBase
{
    public AnswerQuestionModel(){}

    public AnswerQuestionModel(Question question, 
                               TotalPerUser valuationForUser, 
                               QuestionValuation questionValuationForUser, 
                               QuestionSearchSpec questionSearchSpec, 
                               int elementOnPage = -1) : this()
    {
        CreatorId = question.Creator.Id.ToString();
        CreatorName = question.Creator.Name;
        CreationDate = question.DateCreated.ToString("dd.MM.yyyy HH:mm:ss");
        CreationDateNiceText = TimeElapsedAsText.Run(question.DateCreated);

        QuestionId = question.Id.ToString();
        QuestionText = question.Text;
        SolutionType = question.SolutionType.ToString();
        SolutionModel = new GetQuestionSolution().Run(question.SolutionType, question.Solution);

        TimesAnsweredTotal = question.TotalAnswers();
        PercenctageCorrectAnswers = 34;
        TimesAnsweredCorrect = question.TotalTrueAnswers;
        TimesAnsweredWrongTotal = question.TotalFalseAnswers;
        TimesJumpedOver = 0;

        TimesAnsweredUser = valuationForUser.Total();
        TimesAnsweredUserTrue = valuationForUser.TotalTrue;
        TimesAnsweredUserWrong = valuationForUser.TotalFalse;

        TotalViews = question.TotalViews;

        TotalQualityAvg = question.TotalQualityAvg.ToString();
        TotalQualityEntries = question.TotalQualityEntries.ToString();
        TotalRelevanceForAllAvg = question.TotalRelevanceForAllAvg.ToString();
        TotalRelevanceForAllEntries = question.TotalRelevanceForAllEntries.ToString();
        TotalRelevancePersonalAvg = question.TotalRelevancePersonalAvg.ToString();
        TotalRelevancePersonalEntries = question.TotalRelevancePersonalEntries.ToString();

        questionSearchSpec.PageSize = 1;
        if (elementOnPage != -1)
            questionSearchSpec.CurrentPage = elementOnPage;

        PageCurrent = questionSearchSpec.CurrentPage.ToString();
        PagesTotal = questionSearchSpec.PageCount.ToString();

        AverageAnswerTime = "";

        AjaxUrl_SendAnswer = url => Links.SendAnswer(url, question);
        AjaxUrl_GetAnswer = url => Links.GetAnswer(url, question);

        ImageUrl = new GetQuestionImageUrl().Run(question);
        SoundUrl = new GetQuestionSoundUrl().Run(question);

        FeedbackRows = new List<FeedbackRowModel>();
        FeedbackRows.Add(new FeedbackRowModel{
            Key = "RelevancePersonal",
            Title = "Merken. [UhrIcon]",
            FeedbackAverage = Math.Round(question.TotalRelevancePersonalAvg / 10d, 1).ToString(),
            FeedbackCount = question.TotalRelevancePersonalEntries.ToString(),
            HasUserValue = questionValuationForUser.IsSetRelevancePersonal(),
            UserValue = questionValuationForUser.RelevancePersonal.ToString()
        });
        FeedbackRows.Add(new FeedbackRowModel{
            Key = "Quality",
            Title = "Qualität",
            FeedbackAverage = Math.Round(question.TotalQualityAvg / 10d, 1).ToString(),
            FeedbackCount = question.TotalQualityEntries.ToString(),
            HasUserValue = questionValuationForUser.IsSetQuality(),
            UserValue = questionValuationForUser.Quality.ToString()
        });
        FeedbackRows.Add(new FeedbackRowModel{
            Key = "RelevanceForAll",
            Title = "Sollte jeder wissen",
            FeedbackAverage = Math.Round(question.TotalRelevanceForAllAvg / 10d, 1).ToString(),
            FeedbackCount = question.TotalRelevanceForAllEntries.ToString(),
            HasUserValue = questionValuationForUser.IsSetRelevanceForAll(),
            UserValue = questionValuationForUser.RelevanceForAll.ToString()
        });
    }

    public string QuestionId;
    public string CreatorId { get; private set; }
    public string CreatorName { get; private set; }

    public string PageCurrent;
    public string PagesTotal;
    
    public string TotalQualityAvg;
    public string TotalQualityEntries;
    public string TotalRelevanceForAllAvg;
    public string TotalRelevanceForAllEntries;
    public string TotalRelevancePersonalAvg;
    public string TotalRelevancePersonalEntries;
    public string SolutionType;
    public object SolutionModel;
    public string ImageUrl;
    public string SoundUrl;
    public IList<FeedbackRowModel> FeedbackRows;
    public int TotalViews;
    
    public int TimesAnsweredUser;
    public int TimesAnsweredUserTrue;
    public int TimesAnsweredUserWrong;

    public bool HasImage
    {
        get { return !string.IsNullOrEmpty(ImageUrl); }
    }

    public bool HasSound
    {
        get { return !string.IsNullOrEmpty(SoundUrl); }
    }

    public string CreationDateNiceText { get; private set; }
    public string CreationDate { get; private set; }

    public int TimesAnsweredTotal { get; private set; }
    public int PercenctageCorrectAnswers { get; private set; }
    public int TimesAnsweredCorrect { get; private set; }
    public int TimesAnsweredWrongTotal { get; private set; }
    public int TimesJumpedOver { get; private set; }

    public string AverageAnswerTime { get; private set; }

    public string QuestionText { get; private set; }

    public Func<UrlHelper, string> AjaxUrl_SendAnswer { get; private set; }
    public Func<UrlHelper, string> AjaxUrl_GetAnswer { get; private set; }
}
