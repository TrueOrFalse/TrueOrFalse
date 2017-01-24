﻿
using NHibernate;
using NHibernate.Criterion;
using Seedworks.Lib.Persistence;

public class SetViewRepo : RepositoryDb<SetView>
{
    public SetViewRepo(ISession session) : base(session) { }

    public int GetViewCount(int setId)
    {
        return _session.QueryOver<SetView>()
            .Select(Projections.RowCount())
            .Where(x => x.Set.Id == setId)
            .FutureValue<int>()
            .Value;
    }
}
