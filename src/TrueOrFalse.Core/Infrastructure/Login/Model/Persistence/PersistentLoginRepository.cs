﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using NHibernate;
using TrueOrFalse.Core.Registration;

namespace TrueOrFalse.Core
{
    public class PersistentLoginRepository
    {
        private readonly ISession _session;

        public PersistentLoginRepository(ISession session){
            _session = session;
        }

        public PersistentLogin Get(int userId, string guid)
        {
            return _session.QueryOver<PersistentLogin>()
                           .Where(x => x.UserId == userId && x.LoginGuid == HashPassword.Run(guid, "someSalt"))
                           .SingleOrDefault();
        }

        public void Create(PersistentLogin persistentLogin)
        {
            persistentLogin.LoginGuid = HashPassword.Run(persistentLogin.LoginGuid, "someSalt");
            persistentLogin.Created = DateTime.Now;
            _session.Save(persistentLogin);
        }

        public void Delete(PersistentLogin persistentLogin){ _session.Delete(persistentLogin); }
        public void Delete(int userId, string loginGuid){
            _session.CreateQuery("DELETE PersistentLogin WHERE UserId= '" + userId + "' AND LoginGuid = '" + HashPassword.Run(loginGuid, "someSalt") + "'").ExecuteUpdate();
        }
        
        public void DeleteAllForUser(int userId){
            _session.CreateQuery("DELETE PersistentLogin WHERE UserId= '" + userId + "'").ExecuteUpdate();
        }


    }
}
