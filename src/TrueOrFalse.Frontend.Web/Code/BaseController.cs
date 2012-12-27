﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TrueOrFalse;
using TrueOrFalse.Web.Context;


public class BaseController : Controller
{
    protected SessionUser _sessionUser{ get { return Resolve<SessionUser>(); } }

    protected T Resolve<T>()
    {
        return ServiceLocator.Resolve<T>();
    }
}
