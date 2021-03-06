﻿using System.Collections.Concurrent;
using System.Web;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using NHibernate;
using System.Threading;
using TrueOrFalse.Search;

public class Sl
{
    public static T Resolve<T>(){return ServiceLocator.Resolve<T>();}
    public static T R<T>() { return ServiceLocator.Resolve<T>(); }

    public static ISession Session => R<ISession>();
    public static SessionUser SessionUser => R<SessionUser>();
    public static SessionUiData SessionUiData => R<SessionUiData>();

    public static UserRepo UserRepo => R<UserRepo>();
    public static ActivityPointsRepo ActivityPointsRepo => R<ActivityPointsRepo>();

    public static CategoryRepository CategoryRepo => R<CategoryRepository>();
    public static CategoryRelationRepo CategoryRelationRepo => R<CategoryRelationRepo>();
    public static CategoryValuationRepo CategoryValuationRepo => R<CategoryValuationRepo>();
    public static CategoryViewRepo CategoryViewRepo => R<CategoryViewRepo>();
    public static CategoryChangeRepo CategoryChangeRepo => R<CategoryChangeRepo>();

    public static SetRepo SetRepo => R<SetRepo>();
    public static SetViewRepo SetViewRepo => R<SetViewRepo>();

    public static QuestionRepo QuestionRepo => R<QuestionRepo>();
    public static QuestionValuationRepo QuestionValuationRepo => R<QuestionValuationRepo>();
    public static QuestionChangeRepo QuestionChangeRepo => R<QuestionChangeRepo>();

    public static SearchIndexCategory SearchIndexCategory => R<SearchIndexCategory>();

    public static SearchCategories SearchCategories => R<SearchCategories>();
    public static SearchQuestions SearchQuestions => R<SearchQuestions>();
    public static SearchUsers SearchUsers => R<SearchUsers>();

    public static SaveQuestionView SaveQuestionView => R<SaveQuestionView>();

    public static AnswerRepo AnswerRepo => R<AnswerRepo>();

    public static ImageMetaDataRepo ImageMetaDataRepo => R<ImageMetaDataRepo>();

    public static WidgetViewRepo WidgetViewRepo => R<WidgetViewRepo>();

    public static UserActivityRepo UserActivityRepo => R<UserActivityRepo>();
    
    public static JobQueueRepo JobQueueRepo => R<JobQueueRepo>();

    public static int CurrentUserId => R<SessionUser>().UserId;

    public static ImageStore ImageStore => R<ImageStore>();

    public static MembershipRepo MembershipRepo => R<MembershipRepo>();
}

public static class SlExt
{
    public static T R<T>(this object o) => Sl.R<T>();
}

public class ServiceLocator
{
    private static IContainer _container;
    private static readonly ConcurrentDictionary<int /*managed thread id*/, ILifetimeScope> _liftimeScopes = 
        new ConcurrentDictionary<int, ILifetimeScope>();

    public static void Init(IContainer container)
    {
        _container = container;
    }

    public static void AddScopeForCurrentThread(ILifetimeScope lifetimeScope)
    {
        if(!_liftimeScopes.TryAdd(Thread.CurrentThread.ManagedThreadId, lifetimeScope))
            Logg.r().Error("Could not add lifetime scope");    

    }

    public static void RemoveScopeForCurrentThread()
    {
        if(!_liftimeScopes.TryRemove(Thread.CurrentThread.ManagedThreadId, out _))
            Logg.r().Error("Could not remove lifetime scope");
    }

    public static T Resolve<T>()
    {
        var currentThreadId = Thread.CurrentThread.ManagedThreadId;
        if (_liftimeScopes.ContainsKey(currentThreadId))
            return _liftimeScopes[currentThreadId].Resolve<T>();

        if (HttpContext.Current == null)
            return _container.Resolve<T>();

        return ((AutofacDependencyResolver) DependencyResolver.Current).RequestLifetimeScope.Resolve<T>();
    }

    public static IContainer GetContainer()
    {
        return _container;
    }

    public static T R<T>(){
        return Resolve<T>();
    }
}