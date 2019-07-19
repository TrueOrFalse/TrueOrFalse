﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Policy;
using System.Web.Mvc;
using TrueOrFalse.Frontend.Web.Code;
using TrueOrFalse.Web;

[SetUserMenu(UserMenuEntry.None)]
public class CategoryController : BaseController
{
    private const string _viewLocation = "~/Views/Categories/Detail/Category.aspx";
    private const string _topicTab = "~/Views/Categories/Detail/Tabs/TopicTab.ascx";

    public ActionResult Category(int id, int? version)
    {
        var modelAndCategoryResult = LoadModel(id, version);
        modelAndCategoryResult.CategoryModel.IsInTopic = true; 

        return View(_viewLocation, modelAndCategoryResult.CategoryModel);
    }

    public ActionResult CategoryLearningTab(int id, int? version)
    {
        var modelAndCategoryResult = LoadModel(id, version);
        modelAndCategoryResult.CategoryModel.IsInLearningTab = true; 

        return View(_viewLocation, modelAndCategoryResult.CategoryModel);
    }

    public ActionResult CategoryAnalyticsTab(int id, int? version)
    {
        var modelAndCategoryResult = LoadModel(id, version);
        modelAndCategoryResult.CategoryModel.IsInAnalyticsTab = true; 

        return View(_viewLocation, modelAndCategoryResult.CategoryModel);
    }

    private LoadModelResult LoadModel(int id, int? version)
    {
        var result = new LoadModelResult();
        var category = Resolve<CategoryRepository>().GetById(id);

        _sessionUiData.VisitedCategories.Add(new CategoryHistoryItem(category));
        result.Category = category;
        result.CategoryModel = GetModelWithContentHtml(category);

        if (version != null)
            ApplyCategoryChangeToModel(result.CategoryModel, (int)version);
        else
            SaveCategoryView.Run(result.Category, User_());

        return result;
    }

    [HttpPost]
    public ActionResult GetTopicTabAsync(int id , int? version)
    {
        return View(_topicTab, LoadModel(id, version).CategoryModel);
    }

    private CategoryModel GetModelWithContentHtml(Category category)
    {
        return new CategoryModel(category)
        {
            CustomPageHtml = MarkdownToHtml.Run(category.TopicMarkdown, category, ControllerContext)
        };
    }
    
    private void ApplyCategoryChangeToModel(CategoryModel categoryModel, int version)
    {
        var categoryChange = Sl.CategoryChangeRepo.GetByIdEager(version);
        Sl.Session.Evict(categoryChange);
        var historicCategory = categoryChange.ToHistoricCategory();
        categoryModel.Name = historicCategory.Name;
        categoryModel.CategoryChange = categoryChange;
        categoryModel.CustomPageHtml = MarkdownToHtml.Run(historicCategory.TopicMarkdown, historicCategory, ControllerContext);
        categoryModel.Description = MarkdownToHtml.Run(historicCategory.Description, historicCategory, ControllerContext);
        categoryModel.WikipediaURL = historicCategory.WikipediaURL;
        categoryModel.NextRevExists = Sl.CategoryChangeRepo.GetNextRevision(categoryChange) != null;
    }

    public void CategoryById(int id)
    {
        Response.Redirect(Links.CategoryDetail(Resolve<CategoryRepository>().GetById(id)));
    }

    [RedirectToErrorPage_IfNotLoggedIn]
    public ActionResult Restore(int categoryId, int categoryChangeId)
    {
        RestoreCategory.Run(categoryChangeId, this.User_());

        var categoryName = Sl.CategoryRepo.GetById(categoryId).Name;
        return Redirect(Links.CategoryDetail(categoryName, categoryId));
    }

    public ActionResult StartTestSession(int categoryId)
    {
        var category = Sl.CategoryRepo.GetByIdEager(categoryId);
        var testSession = new TestSession(category);

        Sl.SessionUser.AddTestSession(testSession);

        return Redirect(Links.TestSession(testSession.UriName, testSession.Id));
    }

    public ActionResult StartTestSessionForSetsInCategory(List<int> setIds, string setListTitle, int categoryId)
    {
        var sets = Sl.SetRepo.GetByIds(setIds);
        var category = Sl.CategoryRepo.GetByIdEager(categoryId);
        var testSession = new TestSession(sets, setListTitle, category);

        Sl.SessionUser.AddTestSession(testSession);

        return Redirect(Links.TestSession(testSession.UriName, testSession.Id));
    }

    [RedirectToErrorPage_IfNotLoggedIn]
    public ActionResult StartLearningSession(int categoryId)
    {
        var learningSession = CreateLearningSession.ForCategory(categoryId);

        return Redirect(Links.LearningSession(learningSession));
    }

    [RedirectToErrorPage_IfNotLoggedIn]
    public ActionResult StartLearningSessionForSets(List<int> setIds, string setListTitle)
    {
        var sets = Sl.SetRepo.GetByIds(setIds);
        var questions = sets.SelectMany(s => s.Questions()).Distinct().ToList();

        if (questions.Count == 0)
            throw new Exception("Cannot start LearningSession with 0 questions.");

        var learningSession = new LearningSession
        {
            SetsToLearnIdsString = string.Join(",", sets.Select(x => x.Id.ToString())),
            SetListTitle = setListTitle,
            Steps = GetLearningSessionSteps.Run(questions),
            User = _sessionUser.User
        };

        R<LearningSessionRepo>().Create(learningSession);

        return Redirect(Links.LearningSession(learningSession));
    }

    public string Tab(string tabName, int categoryId)
    {
        return ViewRenderer.RenderPartialView(
            "/Views/Categories/Detail/Tabs/" + tabName + ".ascx",
            GetModelWithContentHtml(Sl.CategoryRepo.GetById(categoryId)),
            ControllerContext
        );
    }

    public string KnowledgeBar(int categoryId) => 
        ViewRenderer.RenderPartialView(
            "/Views/Categories/Detail/CategoryKnowledgeBar.ascx",
            new CategoryKnowledgeBarModel(Sl.CategoryRepo.GetById(categoryId)), 
            ControllerContext
        );

  
    public string WishKnowledgeInTheBox(int categoryId) =>
        ViewRenderer.RenderPartialView( 
            "/Views/Categories/Detail/Partials/WishKnowledgeInTheBox.ascx",
            new WishKnowledgeInTheBoxModel(Sl.CategoryRepo.GetById(categoryId)),
            ControllerContext
        );


    [HttpPost]
    [AccessOnlyAsLoggedIn]
    public ActionResult SaveMarkdown(int categoryId, string markdown)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);

        if (category != null && markdown != null)
        {
            var elements = TemplateParser.Run(markdown, category);
            var description = Document.GetDescription(elements);
            category.Description = description;
            category.TopicMarkdown = markdown;
            Sl.CategoryRepo.Update(category, User_());

            return Json(true);
        }
        else
        {
            return Json(false);
        }
        
    }

    [HttpPost]
    [AccessOnlyAsLoggedIn]
    public ActionResult RenderMarkdown(int categoryId, string markdown)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);

        return Json(MarkdownSingleTemplateToHtml.Run(markdown, category, this.ControllerContext, true));
    }

    public string GetKnowledgeGraphDisplay(int categoryId)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);
        return ViewRenderer.RenderPartialView("~/Views/Categories/Detail/Partials/KnowledgeGraph/KnowledgeGraph.ascx", new KnowledgeGraphModel(category), ControllerContext);
    }
}
public class LoadModelResult
{
    public Category Category;
    public CategoryModel CategoryModel;
}