﻿using System.Collections.Generic;
using System.Linq;

namespace System.Web.Mvc
{
    public class SetThemeMenu : ActionFilterAttribute
    {
        private readonly bool _isCategoryPage;
        private readonly bool _isQuestionSetPage;
        private readonly bool _isQuestionPage;
        private readonly bool _isTestSessionPage;
        private readonly bool _isLearningSessionPage;

        public SetThemeMenu(bool isCategoryPage = false, bool isQuestionSetPage = false, bool isQuestionPage = false, bool isTestSessionPage = false, bool isLearningSessionPage = false)
        {
            _isCategoryPage = isCategoryPage;
            _isQuestionSetPage = isQuestionSetPage;
            _isQuestionPage = isQuestionPage;
            _isTestSessionPage = isTestSessionPage;
            _isLearningSessionPage = isLearningSessionPage;
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (_isCategoryPage || _isQuestionSetPage || _isQuestionPage || _isTestSessionPage || _isLearningSessionPage)
            {
                var httpContextData = HttpContext.Current.Request.RequestContext.RouteData.Values;

                var activeCategories = new List<Category>();

                if (_isCategoryPage)
                {
                    var categoryId = (string)httpContextData["id"];

                    if (int.TryParse(categoryId, out var categoryIdNumber))
                        activeCategories.Add(EntityCache.GetCategory(categoryIdNumber, true));
                }
                
                if (_isQuestionPage)
                {
                    activeCategories.AddRange(ThemeMenuHistoryOps.GetQuestionCategories(Convert.ToInt32(httpContextData["id"])));
                }

                if (_isLearningSessionPage)
                {
                    activeCategories.Add(EntityCache.GetCategory(684));
                }
            }

            base.OnActionExecuting(filterContext);
        }
    }
}