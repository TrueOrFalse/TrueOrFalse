﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FluentNHibernate.Mapping;

namespace TrueOrFalse.Core
{
    public class ClassificationItemMap : ClassMap<ClassificationItem>
    {
        public ClassificationItemMap()
        {
            Id(x => x.Id);
            References(x => x.Classification);
            Map(x => x.Name);
            Map(x => x.DateCreated);
            Map(x => x.DateModified);
        }
    }
}
