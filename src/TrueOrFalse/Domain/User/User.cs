﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;
using Seedworks.Lib.Persistence;

namespace TrueOrFalse
{
    [DebuggerDisplay("Id={Id} Name={Name}")]
    public class User : DomainEntity
    {
        public virtual string PasswordHashedAndSalted { get; set; }
        public virtual string Salt { get; set; }

        public virtual string EmailAddress { get; set; }

        public virtual string Name { get; set; }

        public virtual Boolean IsEmailConfirmed { get; set;  }
        public virtual Boolean IsInstallationAdmin { get; set; }
        public virtual Boolean AllowsSupportiveLogin { get; set; }

        public virtual DateTime? Birthday { get; set; }

        public virtual int Reputation { get; set; }
        public virtual int ReputationPos { get; set; }
    }
}
