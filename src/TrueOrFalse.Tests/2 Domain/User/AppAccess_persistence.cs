﻿using System;
using NUnit.Framework;

public class AppAccess_persistence : BaseTest
{
    [Test]
    public void Should_persist_AppAccess()
    {
        var userContext = ContextUser.New().Add("Firstname Lastname").Persist();

        var appAccess = new AppAccess();
        appAccess.User = userContext.All[0];
        appAccess.AccessToken = Guid.NewGuid().ToString();
        appAccess.AppInfo = new AppInfo
        {
            CurrentPlatform = "Android",
            CurrentPlatformVersion = "1",
            DeviceInformation = "DeviceInfo",
            IsAndroid = true
        };
        appAccess.DeviceKey = "DeviceKey";

        R<AppAccessRepo>().Create(appAccess);

        RecycleContainer();

        var appAccessFromDb = R<AppAccessRepo>().GetByUser(userContext.All[0], appAccess.AppKey);
        Assert.That(appAccess.AccessToken, Is.EqualTo(appAccessFromDb.AccessToken));
        Assert.That(appAccess.AppInfo.CurrentPlatform, Is.EqualTo(appAccessFromDb.AppInfo.CurrentPlatform));

        appAccessFromDb = R<AppAccessRepo>().GetByAccessToken(appAccess.AccessToken);
        Assert.That(appAccess.User, Is.EqualTo(appAccessFromDb.User));
    }

}