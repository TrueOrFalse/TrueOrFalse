﻿using NHibernate;

namespace TrueOrFalse.Updates
{
    public class UpdateToVs091
    {
        public static void Run()
        {
            Sl.Resolve<ISession>()
              .CreateSQLQuery(
                @"ALTER TABLE `imagemetadata`
	                ADD COLUMN `LicenseState` TINYINT NULL DEFAULT NULL AFTER `Notifications`;"
            ).ExecuteUpdate();

        }
    }
}