﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

public class CommentMap : ClassMap<Comment>
{
    public CommentMap ()
    {
        Id(x => x.Id);

        Map(x => x.Type);
        Map(x => x.TypeId);

        References(x => x.AnswerTo).Column("AnswerTo").Cascade.None();
        HasMany(x => x.Answers).Cascade.None().KeyColumn("AnswerTo");
        

        Map(x => x.Creator);
        Map(x => x.Text);

        Map(x => x.DateCreated);
        Map(x => x.DateModified);        

//        ManyToOnePart<>
    }
}
