﻿using System;
using NHibernate;

namespace TrueOrFalse
{
    public class GetTotalQuestionCount : IRegisterAsInstancePerLifetime
    {
        private readonly ISession _session;

        public GetTotalQuestionCount(ISession session){
            _session = session;
        }

        public int Run(){
            return (int)_session.CreateQuery("SELECT Count(Id) FROM Question").UniqueResult<Int64>();
        }
    }
}
