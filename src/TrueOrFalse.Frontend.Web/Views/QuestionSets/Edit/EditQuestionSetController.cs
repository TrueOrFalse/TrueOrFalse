﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TrueOrFalse;
using TrueOrFalse.Web;

public class EditQuestionSetController : BaseController
{
    private const string _viewLocation = "~/Views/QuestionSets/Edit/EditQuestionSet.aspx";

    public ActionResult Create(EditQuestionSetModel model)
    {
        if (ModelState.IsValid)
        {
            var questionSet = model.ToQuestionSet();
            questionSet.Creator = _sessionUser.User;
            Resolve<QuestionSetRepository>().Create(questionSet);
            model.Message = new SuccessMessage("Fragesatz wurde gespeichert");
        }

        return View(_viewLocation, new EditQuestionSetModel());
    }

    public ActionResult Update()
    {
        return View(_viewLocation, new EditQuestionSetModel());
    }
}