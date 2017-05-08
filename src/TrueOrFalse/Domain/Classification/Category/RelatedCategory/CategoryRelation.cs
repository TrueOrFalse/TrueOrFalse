﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Seedworks.Lib.Persistence;

[DebuggerDisplay("{Category.Name}({Category.Id}) [{CategoryRelationType.ToString()}] {RelatedCategory.Name}({RelatedCategory.Id})")]
[Serializable]
public class CategoryRelation : DomainEntity
{
    public virtual Category Category { get; set; }

    public virtual Category RelatedCategory { get; set; }

    public virtual CategoryRelationType CategoryRelationType { get; set; }
}
