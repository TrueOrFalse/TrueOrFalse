﻿using TrueOrFalse.Core;
using TrueOrFalse.Core.Infrastructure;
using TrueOrFalse.Core.Infrastructure.Persistence;

namespace TrueOrFalse.Updates
{
    public class UpdateToVs1InitialStep
    {
        public static void Run()
        {
            ServiceLocator.Resolve<ExecuteSqlFile>().Run(ScriptPath.Get("1-create-setting-tbl.sql"));
            CreateInitialRecord();
        }

        private static void CreateInitialRecord()
        {
            var dbSettingsRepository = ServiceLocator.Resolve<DbSettingsRepository>();
            var dbSettings = new DbSettings {AppVersion = 1};
            dbSettingsRepository.Create(dbSettings);
        }
    }
}