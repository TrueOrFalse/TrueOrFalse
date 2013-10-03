﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NHibernate;
using NHibernate.Transform;

namespace TrueOrFalse
{
    public class GetSetTotal : IRegisterAsInstancePerLifetime
    {
        private readonly ISession _session;

        public GetSetTotal(ISession session){
            _session = session;
        }

        public GetSetTotalResult RunForRelevancePersonal(int questionId)
        {
            return _session.CreateSQLQuery(GetQuery("TotalRelevancePersonalEntries", "TotalRelevancePersonalAvg", questionId))
                            .SetResultTransformer(Transformers.AliasToBean(typeof(GetSetTotalResult)))
                            .UniqueResult<GetSetTotalResult>();
        }

        private string GetQuery(string entriesField, string avgField, int questionId)
        {
            return String.Format("SELECT {0} as Count, {1} as Avg FROM QuestionSet WHERE Id = {2}", 
                                    entriesField, avgField, questionId);
        }
    }
}
