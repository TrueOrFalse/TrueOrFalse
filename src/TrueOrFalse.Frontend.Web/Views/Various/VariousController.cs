﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TrueOrFalse.Frontend.Web.Models;

namespace TrueOrFalse.View.Web.Views
{
    public class VariousController : Controller
    {
        public ActionResult Imprint()
        {
            return View(new ModelBase().ShowLeftMenu_TopUsers().ShowRightLogin());
        }

        public ActionResult NotDoneYet()
        {
            return View(new ModelBase().ShowLeftMenu_Empty());
        }

        public ActionResult WelfareCompany()
        {
            return View(new ModelBase().ShowLeftMenu_Empty().ShowRightLogin());
        }
    }
}
