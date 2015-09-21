﻿using FluentNHibernate.Mapping;

public class QuestionViewMap : ClassMap<QuestionView>
{
    public QuestionViewMap()
    {
        Id(x => x.Id);
        Map(x => x.UserId);
        Map(x => x.QuestionId);

        References(x => x.Round).Cascade.None();
        References(x => x.Player).Cascade.None();
        References(x => x.LearningSessionStep).Cascade.None();

        Map(x => x.DateCreated);
    }
}