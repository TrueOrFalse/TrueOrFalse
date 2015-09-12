﻿using FluentNHibernate.Mapping;

public class UserMap : ClassMap<User>
{
    public UserMap()
    {
        Id(x => x.Id);
        Map(x => x.PasswordHashedAndSalted);
        Map(x => x.Salt);
        Map(x => x.EmailAddress);
        Map(x => x.Name);
        Map(x => x.IsEmailConfirmed);
        Map(x => x.IsInstallationAdmin);
        Map(x => x.AllowsSupportiveLogin);
        Map(x => x.ShowWishKnowledge);

        Map(x => x.CorrectnessProbability);
        Map(x => x.CorrectnessProbabilityAnswerCount);

        HasMany(x => x.MembershipPeriods)
            .Cascade.All().Not.LazyLoad();

        HasManyToMany(x => x.Followers)
            .ParentKeyColumn("User_id")
            .ChildKeyColumn("Follower_id")
            .Cascade.All().LazyLoad()
            .Table("user_to_follower");

        HasManyToMany(x => x.Following)
            .ParentKeyColumn("Follower_id")
            .ChildKeyColumn("User_id")
            .Cascade.All().LazyLoad()
            .Table("user_to_follower");

        Map(x => x.Reputation);
        Map(x => x.ReputationPos);

        Map(x => x.WishCountQuestions);
        Map(x => x.WishCountSets);

        Map(x => x.Birthday);
        Map(x => x.DateCreated);
        Map(x => x.DateModified);
    }
}