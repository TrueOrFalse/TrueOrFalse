﻿using System.Linq;

public class DateRowModel : BaseModel
{
    public Date Date;

    public int KnowledgeNotLearned;
    public int KnowledgeNeedsLearning;
    public int KnowledgeNeedsConsolidation;
    public int KnowledgeSolid;

    public int AmountQuestions;

    public bool ShowMinutesLeft;
    public bool ShowHoursLeft;
    
    public TimeSpanLabel RemainingLabel;

    public bool IsPast;
    public bool IsNetworkDate;

    public bool HideEditPlanButton;

    public int TrainingDateCount;
    public string TrainingLength;
    public int NumberOfTrainingsDone;

    public TrainingPlan TrainingPlan;

    public DateRowModel(Date date, bool isNetworkDate = false, bool hideEditPlanButton = false)
    {
        Date = date;

        var allQuestions = date.AllQuestions();
        AmountQuestions = allQuestions.Count;

        var summary = KnowledgeSummaryLoader.Run(UserId, allQuestions.GetIds(), onlyValuated: false);

        KnowledgeNotLearned = summary.NotLearned;
        KnowledgeNeedsLearning = summary.NeedsLearning;
        KnowledgeNeedsConsolidation = summary.NeedsConsolidation;
        KnowledgeSolid = summary.Solid;

        TrainingPlan = date.TrainingPlan ?? new TrainingPlan();
        TrainingDateCount = TrainingPlan.OpenDates.Count;
        TrainingLength = new TimeSpanLabel(TrainingPlan.TimeRemaining).Full;
        NumberOfTrainingsDone = TrainingPlan.PastDates.Where(d => d.LearningSession != null).ToList().Count;

        var remaining = date.Remaining();
        IsPast = remaining.TotalSeconds < 0;
        RemainingLabel = new TimeSpanLabel(remaining, IsPast);
        IsNetworkDate = isNetworkDate;
        HideEditPlanButton = hideEditPlanButton;
    }
}