﻿public class KnowledgeWheelController : BaseController
{
    public string GetForSet(int setId)
    {
        var set = Sl.SetRepo.GetById(setId);
        var knowledgeSummary = KnowledgeSummaryLoader.Run(UserId, set);
        return RenderPartialView(knowledgeSummary);
    }

    public string GetForCategory(int categoryId)
    {
        var category = Sl.CategoryRepo.GetById(categoryId);
        var knowledgeSummary = KnowledgeSummaryLoader.Run(UserId, category);
        return RenderPartialView(knowledgeSummary);
    }

    private string RenderPartialView(KnowledgeSummary knowledgeSummary) => 
        ViewRenderer.RenderPartialView(
            "/Views/Knowledge/Wheel/KnowledgeWheel.ascx", 
            knowledgeSummary,
            ControllerContext
        );
}