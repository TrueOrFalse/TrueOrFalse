﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using TrueOrFalse.Frontend.Web.Code;
using TrueOrFalse.View.Web.Views.Api;
using TrueOrFalse.Web;

[SetUserMenu(UserMenuEntry.None)]
public class EditCategoryController : BaseController
{
    private readonly CategoryRepository _categoryRepository;
    private const string _viewPath = "~/Views/Categories/Edit/EditCategory.aspx";
    private const string _viewPathTypeControls = "~/Views/Categories/Edit/TypeControls/{0}.ascx";

    public EditCategoryController(CategoryRepository categoryRepository)
    {
        _categoryRepository = categoryRepository;
        ActionInvoker = new JavaScriptActionInvoker();
    }

    [SetMainMenu(MainMenuEntry.Categories)]
    [SetThemeMenu]
    public ViewResult Create(string name, string parent, string type)
    {
        var model = new EditCategoryModel { Name = name ?? "", PreselectedType = !String.IsNullOrEmpty(type) ? (CategoryType)Enum.Parse(typeof(CategoryType), type) : CategoryType.Standard };

        if (!string.IsNullOrEmpty(parent))
            model.ParentCategories.Add(_categoryRepository.GetById(Convert.ToInt32(parent)));

        return View(_viewPath, model);
    }

    //[SetMenu(MainMenuEntry.Categories)]
    [SetThemeMenu(true)]
    public ViewResult Edit(int id)
    {
        var category = _categoryRepository.GetById(id);

        if (!IsAllowedTo.ToEdit(category))
            throw new SecurityException("Not allowed to edit category");

        _sessionUiData.VisitedCategories.Add(new CategoryHistoryItem(category, HistoryItemType.Edit));

        var model = new EditCategoryModel(category) { IsEditing = true };

        if (TempData["createCategoryMsg"] != null)
            model.Message = (SuccessMessage)TempData["createCategoryMsg"];

        return View(_viewPath, model);
    }

    [HttpPost]
    //[SetMenu(MainMenuEntry.Categories)]
    [SetThemeMenu(true)]
    public ViewResult Edit(int id, EditCategoryModel model)
    {
        var category = _categoryRepository.GetById(id);
        _sessionUiData.VisitedCategories.Add(new CategoryHistoryItem(category, HistoryItemType.Edit));

        if (!IsAllowedTo.ToEdit(category))
            throw new SecurityException("Not allowed to edit categoty");

        var categoryAllowed = new CategoryNameAllowed();

        model.FillReleatedCategoriesFromPostData(Request.Form);
        model.UpdateCategory(category);

        var isChangeParents = !GraphService.IsCategoryParentEqual(model.ParentCategories,
            EntityCache.GetCategory(category.Id).ParentCategories()); 

        if (model.Name != category.Name && categoryAllowed.No(model, category.Type))
        {
            model.Message = new ErrorMessage(
                $"Es existiert bereits ein Thema mit dem Namen <strong>'{categoryAllowed.ExistingCategories.First().Name}'</strong>.");
        }
        else
        {
            _categoryRepository.Update(category, _sessionUser.User, (Request["ImageIsNew"] == "true"));

            model.Message
                = new SuccessMessage(
                    "Das Thema wurde gespeichert. <br>" + "Du kannst es weiter bearbeiten oder" +
                    $" <a href=\"{Links.CategoryDetail(category)}\">zur Detailansicht wechseln</a>.");
        }
        StoreImage(id);
        if(isChangeParents)
            UserEntityCache.ReInitAllActiveCategoryCaches();
        else
            UserEntityCache.ChangeCategoryInUserEntityCaches(category);



        model.Init(category);
        model.IsEditing = true;
        model.DescendantCategories = Sl.R<CategoryRepository>().GetDescendants(category.Id).ToList();

        return View(_viewPath, model);
    }

    [HttpPost]
    [SetMainMenu(MainMenuEntry.Categories)]
    [SetThemeMenu]
    public ActionResult Create(EditCategoryModel model, HttpPostedFileBase file)
    {
        model.FillReleatedCategoriesFromPostData(Request.Form);

        var convertResult = model.ConvertToCategory();
        if (convertResult.HasError)
        {

            if (convertResult.TypeModel == null)
                throw new Exception("Dear developer, please assign the type model!");

            EditCategoryTypeModel.SaveToSession(convertResult.TypeModel, convertResult.Category);
            model.Message = convertResult.ErrorMessage;
            return View(_viewPath, model);
        }

        var category = convertResult.Category;
        category.Creator = _sessionUser.User;

        var categoryNameAllowed = new CategoryNameAllowed();

        if (categoryNameAllowed.No(category))
        {
            model.Message = new ErrorMessage(
                string.Format("Das Thema <strong>'{0}'</strong> existiert bereits. " +
                              "<a href=\"{1}\">Klicke hier</a>, um es zu bearbeiten.",
                              categoryNameAllowed.ExistingCategories.First().Name,
                              Links.CategoryEdit(categoryNameAllowed.ExistingCategories.First())));

            return View(_viewPath, model);
        }

        if (categoryNameAllowed.ForbiddenWords(category.Name))
        {
            model.Message = new ErrorMessage("Der Themen Name ist verboten, bitte wähle einen anderen Namen! ");

            return View(_viewPath, model);
        }

        _categoryRepository.Create(category);

        StoreImage(category.Id);

        EditCategoryTypeModel.RemoveRecentTypeModelFromSession();

        TempData["createCategoryMsg"]
            = new SuccessMessage(string.Format(
                 "Das Thema <strong>'{0}'</strong> {1} wurde angelegt.<br>" +
                 "Du kannst das Thema weiter bearbeiten," +
                 " <a href=\"{2}\">zur Detailansicht wechseln</a>" +
                 " oder ein <a href=\"{3}\">neues Thema anlegen</a>.",
                category.Name,
                category.Type == CategoryType.Standard ? "" : "(" + category.Type.GetShortName() + ")",
                Links.CategoryDetail(category),
                Links.CategoryCreate()));

        new CategoryApiModel().Pin(category.Id); 

        return Redirect(Links.CategoryDetail(category));
    }

    [HttpPost]
    public JsonResult ValidateName(string name)
    {
        var dummyCategory = new Category();
        dummyCategory.Name = name;
        dummyCategory.Type = CategoryType.Standard;
        var categoryNameAllowed = new CategoryNameAllowed();
        if (categoryNameAllowed.No(dummyCategory))
        {

            return Json(new
            {
                categoryNameAllowed = false,
                name,
                url = Links.CategoryDetail(EntityCache.GetByName(name).FirstOrDefault(c => c.Type == CategoryType.Standard)), 
                errorMsg = " ist bereits vergeben, bitte wähle einen anderen Namen!"
            });
        }

        if (categoryNameAllowed.ForbiddenWords(name))
        {
            return Json(new
            {
                categoryNameAllowed = false,
                name,
                errorMsg = " ist verboten, bitte wähle einen anderen Namen!"
            });
        }

        return Json(new
        {
            categoryNameAllowed = true
        });
    }

    [HttpPost]
    public JsonResult QuickCreate(string name, int parentCategoryId)
    {
        var category = new Category(name);
        var parentCategory = EntityCache.GetCategory(parentCategoryId);
        ModifyRelationsForCategory.AddParentCategory(category, parentCategory);

        category.Creator = _sessionUser.User;
        category.Type = CategoryType.Standard;
        _categoryRepository.Create(category);

        CategoryInKnowledge.Pin(category.Id, Sl.SessionUser.User);
        StoreImage(category.Id);
        return Json(new
        {
            success = true,
            url = Links.CategoryDetail(category),
            id = category.Id
        });
    }

    [HttpPost]
    public JsonResult QuickCreateWithCategories(string name, int parentCategoryId, int[] childCategoryIds)
    {
        var category = new Category(name) {Creator = _sessionUser.User};

        JobExecute.RunAsTask(scope =>
        {
            var parentCategory = EntityCache.GetCategory(parentCategoryId);
            ModifyRelationsForCategory.AddParentCategory(category, parentCategory);
        }, "ModifyRelationForCategoryJob");

        Sl.CategoryRepo.Create(category);

        foreach (var childCategoryId in childCategoryIds)
        {
            var childCategory = EntityCache.GetCategory(childCategoryId);
            RemoveParent(parentCategoryId, childCategoryId);

            var updatedParentList = childCategory.ParentCategories().Where(c => c.Id != parentCategoryId).ToList();
            updatedParentList.Add(category);
            ModifyRelationsForCategory.UpdateCategoryRelationsOfType(childCategory, updatedParentList, CategoryRelationType.IsChildCategoryOf);
            Sl.CategoryRepo.Update(childCategory, _sessionUser.User);
        }
        UserEntityCache.ReInitAllActiveCategoryCaches();

        return Json(new
        {
            success = true,
            url = Links.CategoryDetail(category),
            id = category.Id
        });
    }

    [HttpPost]
    [AccessOnlyAsLoggedIn]
    public JsonResult SaveCategoryContent(int categoryId, string content = null)
    {
        if (categoryId == RootCategory.RootCategoryId && !IsInstallationAdmin)
            return Json("Die Startseite kann nur von einem Admin bearbeitet werden");
        
        var category = EntityCache.GetCategory(categoryId);
        if (category != null)
        {
            if (content != null)
                category.Content = content;
            else category.Content = null;

            Sl.CategoryRepo.Update(category, User_());
            return Json(true);
        }
        return Json(false);
    }

    [HttpPost]
    [AccessOnlyAsLoggedIn]
    public JsonResult SaveSegments(int categoryId, List<SegmentJson> segmentation = null)
    {
        if (categoryId == 0 && !IsInstallationAdmin)
            return Json("Die Startseite kann nur von einem Admin bearbeitet werden");
        var category = EntityCache.GetCategory(categoryId);

        if (category != null)
        {
            if (segmentation != null)
                category.CustomSegments = JsonConvert.SerializeObject(segmentation, new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                });

            Sl.CategoryRepo.Update(category, User_());

            return Json(true);
        }
        return Json(false);
    }

    [HttpPost]
    public JsonResult RemoveParent(int parentCategoryIdToRemove, int childCategoryId)
    {
        var childCategory = EntityCache.GetCategory(childCategoryId);
        
        if (!IsAllowedTo.ToEdit(childCategory))
            throw new SecurityException("Not allowed to edit category");

        var updatedParentList = childCategory.ParentCategories().Where(c => c.Id != parentCategoryIdToRemove).ToList();
        ModifyRelationsForCategory.UpdateCategoryRelationsOfType(childCategory, updatedParentList, CategoryRelationType.IsChildCategoryOf);
        UserEntityCache.ReInitAllActiveCategoryCaches();

        Sl.CategoryRepo.Update(childCategory, _sessionUser.User);
        
        return Json(new
        {
            success = true,
        });
    }

    [HttpPost]
    public JsonResult RemoveChildren(int parentCategoryId, int[] childCategoryIds)
    {
        foreach (int childCategoryId in childCategoryIds)
            RemoveParent(parentCategoryId, childCategoryId);

        return Json(new
        {
            success = true,
        });
    }

    public ActionResult DetailsPartial(int? categoryId, CategoryType type, string typeModelGuid)
    {
        Category category = null;

        if (categoryId.HasValue && categoryId.Value > 0)
        {
            category = _categoryRepository.GetById(categoryId.Value);
        }

        return View(string.Format(_viewPathTypeControls, type), new EditCategoryTypeModel(category, type));
    }

    private void StoreImage(int categoryId)
    {
        if (Request["ImageIsNew"] == "true")
        {
            if (Request["ImageSource"] == "wikimedia")
            {
                Resolve<ImageStore>().RunWikimedia<CategoryImageSettings>(
                    Request["ImageWikiFileName"], categoryId, ImageType.Category, _sessionUser.User.Id);
            }
            if (Request["ImageSource"] == "upload")
            {
                Resolve<ImageStore>().RunUploaded<CategoryImageSettings>(
                    _sessionUiData.TmpImagesStore.ByGuid(Request["ImageGuid"]), categoryId, _sessionUser.User.Id, Request["ImageLicenseOwner"]);
            }
        }
    }


    [HttpPost]
    [AccessOnlyAsAdmin]
    public void EditAggregation(int categoryId, string categoriesToExcludeIdsString, string categoriesToIncludeIdsString)
    {
        var category = _categoryRepository.GetById(categoryId);

        category.CategoriesToExcludeIdsString = categoriesToExcludeIdsString;
        category.CategoriesToIncludeIdsString = categoriesToIncludeIdsString;

        ModifyRelationsForCategory.UpdateRelationsOfTypeIncludesContentOf(category);
    }

    [HttpPost]
    [AccessOnlyAsAdmin]
    public void ResetAggregation(int categoryId)
    {
        var catRepo = Sl.CategoryRepo;

        var category = catRepo.GetById(categoryId);

        var relationsToRemove =
            category.CategoryRelations.Where(r => r.CategoryRelationType == CategoryRelationType.IncludesContentOf).ToList();

        foreach (var relation in relationsToRemove)
        {
            category.CategoryRelations.Remove(relation);
        }

        catRepo.Update(category);
    }

    public ActionResult GetEditCategoryAggregationModalContent(int categoryId)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);
        return View("~/Views/Categories/Modals/EditAggregationModal.ascx", new EditCategoryModel(category));
    }

    public string GetCategoryGraphDisplay(int categoryId)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);
        return ViewRenderer.RenderPartialView("~/Views/Categories/Edit/GraphDisplay/CategoryGraph.ascx", new CategoryGraphModel(category), ControllerContext);
    }
}