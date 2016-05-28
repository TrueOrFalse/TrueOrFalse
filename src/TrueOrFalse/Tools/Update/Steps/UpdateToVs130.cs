﻿using NHibernate;

namespace TrueOrFalse.Updates
{
    public class UpdateToVs130
    {
        public static void Run()
        {
            Sl.Resolve<ISession>()
              .CreateSQLQuery(
                @"ALTER TABLE `trainingdate`
	                ADD COLUMN `AllQuestionsJson` TEXT NULL DEFAULT NULL AFTER `DateTime`;"
            ).ExecuteUpdate();
        }
    }
}