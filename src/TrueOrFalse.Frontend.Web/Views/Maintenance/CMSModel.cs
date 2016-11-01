﻿using System;
using System.Collections.Generic;
using System.Linq;
using TrueOrFalse.Infrastructure;
using TrueOrFalse.Web;

public class CMSModel : BaseModel
{
    public UIMessage Message;

    public string SuggestedGames { get; set; }
    public IList<Set> SuggestedGameSets = new List<Set>();

    public string SuggestedSetsIdString { get; set; }
    public List<Set> SuggestedSets = new List<Set>();

    public CMSModel Init()
    {
        ConsolidateGames();
        ConsolidateSuggestedSets();
        return this;
    }

    public void ConsolidateSuggestedSets()
    {
        var settings = Sl.R<DbSettingsRepo>().Get();

        if (String.IsNullOrEmpty(SuggestedSetsIdString))
        {
            settings.SuggestedSetsIdString = SuggestedSetsIdString;
            Sl.R<DbSettingsRepo>().Update(settings);
            return;
        }

        var setIds = SuggestedSetsIdString.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        var validatedSetIds = new List<int>();

        foreach (var setId in setIds)
        {
            int setIdInt;
            if (int.TryParse(setId, out setIdInt))
            {
                var set = Sl.R<SetRepo>().GetById(setIdInt);
                if (set != null)
                {
                    SuggestedSets.Add(set);
                    validatedSetIds.Add(set.Id);
                }
            }
        }

        SuggestedSetsIdString = validatedSetIds
            .Select(x => x.ToString())
            .Aggregate((a, b) => a + "," + b);

        settings.SuggestedSetsIdString = SuggestedSetsIdString;
        Sl.R<DbSettingsRepo>().Update(settings);
    }

    public void ConsolidateGames()
    {
        var settings = Sl.R<DbSettingsRepo>().Get();

        if (String.IsNullOrEmpty(SuggestedGames))
        {    
            settings.SuggestedGames = SuggestedGames;
            Sl.R<DbSettingsRepo>().Update(settings);
            return;
        }

        var setIds = SuggestedGames.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        var validatedSetIds = new List<int>();

        foreach (var setId in setIds)
        {
            int setIdInt;
            if (int.TryParse(setId, out setIdInt))
            {
                var set = Sl.R<SetRepo>().GetById(setIdInt);
                if (set != null)
                {
                    SuggestedGameSets.Add(set);
                    validatedSetIds.Add(set.Id);
                }
            }
        }

        SuggestedGames = validatedSetIds
            .Select(x => x.ToString())
            .Aggregate((a, b) => a + "," + b);

        settings.SuggestedGames = SuggestedGames;
        Sl.R<DbSettingsRepo>().Update(settings);
    }
}