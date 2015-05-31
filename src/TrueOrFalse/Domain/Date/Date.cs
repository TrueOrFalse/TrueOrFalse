﻿using System;
using System.Collections.Generic;
using Seedworks.Lib.Persistence;
public class Date : DomainEntity
{
    public virtual string Details { get; set; }

    public virtual DateTime DateTime { get; set; }

    public virtual IList<Set> Sets { get; set; }
}