﻿using System;
using System.Collections.Generic;
using System.Linq;
using Seedworks.Lib.Persistence;

public class Game : DomainEntity
{
    public virtual DateTime WillStartAt { get; set; }

    public virtual User Creator { get; set; }
    public virtual IList<User> Players { get; set; }

    public virtual int MaxPlayers { get; set; }

    public virtual int RoundCount { get; set; }
    public virtual IList<GameRound> Rounds { get; set; } 

    public virtual IList<Set> Sets { get; set; }
    public virtual GameStatus Status { get; set; }
    public virtual string Comment { get; set; }

    public virtual bool AddPlayer(User user)
    {
        if(Players == null)
            Players = new List<User>();

        if (Players.Any(u => u.Id == user.Id))
            return false;

        Players.Add(user);
        return true;
    }

    public Game()
    {
        Rounds = new List<GameRound>();
    }

    public virtual Game AddRound(GameRound round)
    {
        round.Status = GameRoundStatus.Open;
        round.DateCreated = DateTime.Now;
        round.DateModified = DateTime.Now;
        Rounds.Add(round);

        return this;
    }
}
