﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate;

namespace TrueOrFalse
{
    public class DeleteValuationsForNonExisitingSets : IRegisterAsInstancePerLifetime
    {
        private readonly ISession _session;
        private readonly UpdateSetDataForQuestion _updateSetDataForQuestion;
        private readonly UpdateWishcount _updateWishCount;

        public DeleteValuationsForNonExisitingSets(
            ISession session,
            UpdateSetDataForQuestion updateSetDataForQuestion,
            UpdateWishcount updateWishCount)
        {
            _session = session;
            _updateSetDataForQuestion = updateSetDataForQuestion;
            _updateWishCount = updateWishCount;
        }

        public void Run()
        {
//            var affectedUserIds = _session.CreateSQLQuery(@"
//                SELECT distinct(sv.UserId) FROM setvaluation sv
//                LEFT JOIN questionset s
//                ON sv.SetId = s.Id
//                WHERE s.Id IS NULL").List<int>();

            _session.CreateSQLQuery(@"
                DELETE sv FROM setvaluation sv
                LEFT JOIN questionset s
                ON sv.SetId = s.Id
                WHERE s.Id IS NULL").ExecuteUpdate();

            _updateSetDataForQuestion.Run();
            _updateWishCount.Run();
        }
    }
}
