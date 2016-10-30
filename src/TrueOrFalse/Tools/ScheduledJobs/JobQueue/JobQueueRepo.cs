﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NHibernate;
using Seedworks.Lib.Persistence;

public class JobQueueRepo : RepositoryDb<JobQueue>
{
    public JobQueueRepo(ISession session) : base(session)
    {
    }

    public void Add(JobQueueType jobQueueType, string jobContent)
    {
        Session.Save(new JobQueue
        {
            JobQueueType = jobQueueType,
            JobContent = jobContent
        });
        Session.Flush();
    }

    public void DeleteById(IList<int> jobIds)
    {
        var query = $"DELETE FROM jobqueue WHERE jobqueue.Id IN ({string.Join(", ", jobIds)})";
        _session.CreateSQLQuery(query).ExecuteUpdate(); 
    }

    public void DeleteAllJobs(JobQueueType jobQueueType)
    {
        var query = $"DELETE FROM jobqueue WHERE jobqueue.JobQueueType = {(int)jobQueueType}";
        _session.CreateSQLQuery(query).ExecuteUpdate();
    }

    public IList<JobQueue> GetReputationUpdateUsers()
    {
        return 
            _session.QueryOver<JobQueue>().Where(j => j.JobQueueType == JobQueueType.UpdateReputationForUser).List();
    }
}
    