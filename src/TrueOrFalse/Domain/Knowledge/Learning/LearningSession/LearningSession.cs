﻿using System;
using System.Collections.Generic;
using System.Linq;
using FluentNHibernate.Utils;
using Newtonsoft.Json;
using RabbitMQ.Client.Impl;
using Seedworks.Lib.Persistence;
using TrueOrFalse.Web.Uris;

public class LearningSession : DomainEntity, IRegisterAsInstancePerLifetime
{
    public virtual User User { get; set; }
    public virtual IList<LearningSessionStep> Steps{ get; set; }

    public virtual string StepsJson
    {
        get { return JsonConvert.SerializeObject(Steps); }
        set
        {
            if (value == null)
            {
                Steps = new List<LearningSessionStep>();
                return;
            }

            Steps = JsonConvert.DeserializeObject<IList<LearningSessionStep>>(value).Where(s => s.Question != null).OrderBy(s => s.Idx).ToList();
        }
    }

    public virtual Set SetToLearn { get; set; }
    public virtual IList<Set> SetsToLearn
    {
        get
        {
            if (string.IsNullOrEmpty(SetsToLearnIdsString))
                return new List<Set>();

            var setIds = SetsToLearnIdsString
                .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => Convert.ToInt32(x));

            var setRepo = Sl.R<SetRepo>();

            return setIds
                .Select(setId => setRepo.GetById(setId))
                .Where(set => set != null)
                .ToList();
        }
        set
        {
            SetsToLearnIdsString = value.Count == 0 ? null : string.Join(",", value.Select(x => x.Id.ToString()));
        }
    }
    public virtual string SetsToLearnIdsString { get; set; }
    public virtual string SetListTitle { get; set; }
    public virtual Date DateToLearn { get; set; }
    public virtual Category CategoryToLearn { get; set; }

    public virtual bool IsCompleted { get; set; }

    public virtual string UrlName
    {
        get
        {
            if (SetToLearn != null)
                return "Fragesatz-" + UriSegmentFriendlyUser.Run(SetToLearn.Name);

            if (SetsToLearn != null)
                return "Fragesaetze-" + UriSegmentFriendlyUser.Run(SetListTitle);

            if (CategoryToLearn != null)
                return "Kategorie-" + UriSegmentFriendlyUser.Run(CategoryToLearn.Name);

            if (DateToLearn != null)
                return "Termin-" + DateToLearn.DateTime.ToString("D").Replace(",", "").Replace(" ", "_").Replace(".", "");

            if (IsWishSession)
                return "Wunschwissen";

            throw new Exception("unknown session type");
        }
    }

    public virtual bool IsSetSession { get { return SetToLearn != null; } }

    public virtual bool IsSetsSession { get { return SetsToLearn != null; } }

    public virtual bool IsDateSession{ get { return DateToLearn != null; }}

    public virtual bool IsCategorySession{ get { return CategoryToLearn != null; }}

    public virtual bool IsWishSession { get; set; }

    public virtual int TotalPossibleQuestions
    {
        get
        {
            if (IsSetSession)
                return SetToLearn.Questions().Count;

            if (IsSetsSession)
                return SetsToLearn.Sum(s => s.Questions().Count);

            if (IsDateSession)
                return DateToLearn.AllQuestions().Count;

            if (IsCategorySession)
                return GetQuestionsForCategory.AllIncludingQuestionsInSet(CategoryToLearn.Id).Count;

            if (IsWishSession)
                return User.WishCountQuestions;

            throw new Exception("unknown session type");
        }
    }

    public virtual IList<Question> Questions()
    {
        return Steps.Select(s => s.Question).Distinct().ToList();
    }

    public virtual int CurrentLearningStepIdx()
    {
        return Steps.ToList()
            .FindIndex(s => s.AnswerState == StepAnswerState.Uncompleted);
    }


    public virtual void CompleteSession()
    {
        if(IsCompleted) return;

        Steps.Where(s => s.AnswerState == StepAnswerState.Uncompleted)
            .Each(s => s.AnswerState = StepAnswerState.NotViewedOrAborted);

        IsCompleted = true;

        Sl.R<LearningSessionRepo>().Update(this);
    }

    public static LearningSession InitDateSession(Date date, TrainingDate trainingDate)
    {
        var learningSession = new LearningSession
        {
            DateToLearn = date,
            User = date.User
        };

        if (trainingDate == null
            || (trainingDate.IsBoostingDate
                && !date.TrainingPlan.BoostingPhaseHasStarted()))
        {
            learningSession.Steps = GetLearningSessionSteps
                .Run(date.AllQuestions(),
                date.TrainingPlanSettings.QuestionsPerDate_Minimum);
        }
        else if (trainingDate.LearningSession != null)
        {
            learningSession = trainingDate.LearningSession;
        }
        else
        {
            learningSession.Steps = GetLearningSessionSteps.Run(trainingDate);
            trainingDate.LearningSession = learningSession;
        }

        Sl.R<LearningSessionRepo>().Create(learningSession);

        if (trainingDate != null)
        {
            Sl.R<TrainingDateRepo>().Update(trainingDate);
        }

        return learningSession;
    }

    public virtual void SkipStep(int stepIdx)
    {
        var stepToSkip = Steps[stepIdx];
        if (stepToSkip != null && stepToSkip.AnswerState != StepAnswerState.Answered)
        {
            stepToSkip.AnswerState = StepAnswerState.Skipped;
            Sl.R<LearningSessionRepo>().Update(this);
        }
    }

    public virtual void UpdateAfterWrongAnswer(LearningSessionStep affectedStep)
    {
        if(LimitForThisQuestionHasBeenReached(affectedStep) 
            || LimitForNumberOfRepetitionsHasBeenReached())
            return;

        var newStepForRepetion = new LearningSessionStep
        {
            Guid = Guid.NewGuid(),
            Question = affectedStep.Question,
            IsRepetition = true,
        };

        var idxOfNewStep = Math.Min(affectedStep.Idx + 3, Steps.Count);

        Steps = Steps.OrderBy(s => s.Idx).ToList();

        Steps.Insert(idxOfNewStep, newStepForRepetion);

        ReindexSteps();

        Sl.R<LearningSessionRepo>().Update(this);
    }

    public virtual void ReindexSteps()
    {
        var idx = 0;

        foreach (var step in Steps)
        {
            step.Idx = idx;
            idx++;
        }
    }

    public virtual bool LimitForThisQuestionHasBeenReached(LearningSessionStep step)
    {
        return Steps.Count(s => s.Question == step.Question) >= 3;
    }

    public virtual bool LimitForNumberOfRepetitionsHasBeenReached()
    {
        return Steps.Count > Steps.Select(s => s.Question).Distinct().Count()*2;
    }

    public static LearningSessionStep GetStep(int learningSessionId, Guid learningSessionStepGuid)
    {
        var learningSession = Sl.R<LearningSessionRepo>().GetById(learningSessionId);
        var steps = learningSession.Steps.Where(s => s.Guid == learningSessionStepGuid).ToList();
        if(steps.Count > 1)
            throw new Exception("duplicate Guid");

        return steps.FirstOrDefault();
    }
}
