﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FluentNHibernate.Mapping;
using TrueOrFalse.Core.Infrastructure.Persistence;

namespace TrueOrFalse.Core
{
    public class QuestionMap : ClassMap<Question>
    {
        public QuestionMap()
        {
            Id(x => x.Id);
            Map(x => x.Text).Length(Constants.VarCharMaxLength);
            Map(x => x.Description).Length(Constants.VarCharMaxLength);
            Map(x => x.Visibility);
            References(x => x.Creator);

            Map(x => x.TotalTrueAnswers);
            Map(x => x.TotalFalseAnswers);

            Map(x => x.TotalQualityAvg);
            Map(x => x.TotalQualityEntries);
            
            Map(x => x.TotalRelevanceForAllAvg);
            Map(x => x.TotalRelevanceForAllEntries);
            
            Map(x => x.TotalRelevancePersonalAvg);
            Map(x => x.TotalRelevancePersonalEntries);
            
            Map(x => x.DateCreated);
            Map(x => x.DateModified);
            
            Map(x => x.Solution);
            Map(x => x.SolutionType);
            HasManyToMany(x => x.Categories).Table("CategoriesToQuestions").Cascade.All();
        }
    }
}
