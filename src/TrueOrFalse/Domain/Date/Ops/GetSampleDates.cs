﻿using System;
using System.Collections.Generic;
using System.Linq;

public class GetSampleDates
{
    public static IList<Date> Run()
    {
        var sets = Sl.R<SetRepository>()
            .GetByIds(7, 8, 12);

        var now = DateTime.Now;

        return new List<Date>
        {
            new Date
            {
                Details = "Klassenarbeit Politik", 
                Sets = sets.Where(s => s.Id == 7).ToList(),
                DateTime = new DateTime(now.Year, now.Month, now.Day, 10, 00, 0).AddDays(2)
            },
            new Date
            {
                Details = "LEK Mathe Kapitel 4",
                Sets = sets.Where(s => s.Id == 8).ToList(),                
                DateTime = new DateTime(now.Year, now.Month, now.Day, 15, 30, 0).AddDays(4)
            },
            new Date
            {
                Details = "LEK EK (Länder Afrika)",
                Sets = sets.Where(s => s.Id == 12).ToList(),
                DateTime = new DateTime(now.Year, now.Month, now.Day, 8, 00, 0).AddDays(5)
            }
        };
    }
}