﻿using System;
using System.Linq;

public class AddRoundsToGame : IRegisterAsInstancePerLifetime
{
    public void Run(Game game)
    {
        var allQuestions = game.Sets
            .SelectMany(x => x.QuestionsInSet)
            .GroupBy(x => x.Question.Id)
            .Select(x => x.First())
            .ToList();

        allQuestions.Shuffle();

        var rnd = new Random(new Guid().GetHashCode());
        while (allQuestions.Count < game.RoundCount)
        {
            var toAdd = allQuestions[rnd.Next(0, allQuestions.Count)];
            if(allQuestions[allQuestions.Count - 1].Question.Id == toAdd.Question.Id)
                continue;

            allQuestions.Add(toAdd);    
        }


        for (var i = 0; i < game.RoundCount; i++)
        {
            game.AddRound(new Round
            {
                Set = allQuestions[i].Set,
                Question = allQuestions[i].Question,
            });            
        }
    }
}