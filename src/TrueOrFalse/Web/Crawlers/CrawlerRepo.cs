﻿using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using NHibernate.Util;

public class CrawlerRepo
{
    private static IList<Crawler> _crawlers;

    public static IList<Crawler> GetAll()
    {
        if (_crawlers != null)
            return _crawlers;

        lock ("{A95EC747-38AB-45BA-9212-E52B9F47193C")
            InitCrawlers();

        return _crawlers;
    }

    private static void InitCrawlers()
    {
        _crawlers = JsonConvert.DeserializeObject<IList<Crawler>>(File.ReadAllText(PathTo.Crawlers()));
        _crawlers.ForEach(crawler => crawler.Pattern = crawler.Pattern.ToLower());
    }
}