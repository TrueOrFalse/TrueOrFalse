﻿using System;
using System.Collections.Generic;
using NHibernate;
using TrueOrFalse.Tests;

public class ContextHistory
{
	public static ContextHistory New()
	{
		return new ContextHistory();
	}

	public List<Answer> All = new List<Answer>();
	public User User;

	public ContextHistory()
	{
		User = ContextUser.New().Add("Firstname Lastname").Persist().All[0];
	}

	public void WriteHistory(int daysOffset = -3)
	{
	    WriteHistory(User, daysOffset);
	}

    public void WriteHistory(User user, int daysOffset = -3)
    {
        var _session = Sl.R<ISession>();

	    var historyItem = new Answer
	    {
		    UserId = user.Id,
		    Question = ContextQuestion.GetQuestion(),
		    AnswerredCorrectly = AnswerCorrectness.True,
		    DateCreated = DateTime.Now.AddDays(daysOffset)
	    };

        _session.Save(historyItem);
        _session.Flush();

        All.Add(historyItem);
    }
}