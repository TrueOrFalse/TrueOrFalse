﻿using System;
using NHibernate;
using Seedworks.Lib.Persistance;
using TrueOrFalse.Core;

namespace TrueOrFalse.Core
{
    public class QuestionRepository : RepositoryDb<Question> 
    {
        public QuestionRepository(ISession session) : base(session)
        {
        }
    }
}