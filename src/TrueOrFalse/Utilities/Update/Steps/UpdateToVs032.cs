﻿using NHibernate;
using TrueOrFalse;
using TrueOrFalse.Infrastructure.Persistence;

namespace TrueOrFalse.Updates
{
    public class UpdateToVs032
    {
        public static void Run()
        {
            ServiceLocator.Resolve<UpdateSetDataForQuestion>().Run();

        }
    }
}
