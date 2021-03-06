﻿using System.Collections.Generic;
using System.Linq;

public class NetworkModel : BaseModel
{
    public int TotalUsers;

    public IEnumerable<UserRowModel> UsersIFollow = new List<UserRowModel>();
    public IEnumerable<UserRowModel> UsersFollowingMe = new List<UserRowModel>();

    public HeaderModel HeaderModel  = new HeaderModel();

    public NetworkModel()
    {
        HeaderModel.TotalUsers = R<GetTotalUsers>().Run();
        HeaderModel.IsNetworkTab = true;

        if (!IsLoggedIn)
            return;

        var user = R<UserRepo>().GetById(UserId);

        var allInNetwork = new List<FollowerInfo>();
        allInNetwork.AddRange(user.Following);
        allInNetwork.AddRange(user.Followers);

        var followerIAm = R<FollowerIAm>().Init(allInNetwork, UserId);

        UsersIFollow = user.Following.Select(u => new UserRowModel(u.User, -1, followerIAm));
        UsersFollowingMe = user.Followers.Select(u => new UserRowModel(u.Follower, -1, followerIAm));

        HeaderModel.TotalIFollow = UsersIFollow.Count();
        HeaderModel.TotalFollowingMe = UsersFollowingMe.Count();
    }
}