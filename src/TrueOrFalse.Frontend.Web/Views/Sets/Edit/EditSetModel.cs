﻿using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using Seedworks.Lib;
using TrueOrFalse;
using TrueOrFalse.Frontend.Web.Models;
using TrueOrFalse.Infrastructure;
using TrueOrFalse.Web;
using TrueOrFalse.Web.Context;

public class EditSetModel : BaseModel
{
    public Message Message;

    public string ImageIsNew { get; set; }
    public string ImageSource { get; set; }
    public string ImageWikiFileName { get; set; }
    public string ImageGuid { get; set; }
    public string ImageLicenceOwner { get; set; }

    public int Id { get; set; }
    public bool IsEditing { get; set; }

    [Required]
    [DisplayName("Titel")]
    public string Title { get; set;  }

    [Required]
    [DataType(DataType.MultilineText)]
    [DisplayName("Beschreibung")]
    public string Text { get; set; }

    public IEnumerable<string> Categories = new List<string>(); 

    public string Username;

    public string ImageUrl_206px;

    public string PageTitle;
    public string FormTitle;

    public IList<QuestionInSet> QuestionsInSet = new List<QuestionInSet>();

    public EditSetModel(){
        Username = new SessionUser().User.Name;
        ImageUrl_206px = QuestionSetImageSettings.Create(-1).GetUrl_206px_square().Url;    
    }

    public EditSetModel(Set set)
    {
        Id = set.Id;
        Title = set.Name;
        Text = set.Text;
        ImageUrl_206px = QuestionSetImageSettings.Create(set.Id).GetUrl_206px_square().Url;
        Username = new SessionUser().User.Name;
        QuestionsInSet = set.QuestionsInSet;
    }

    public Set ToQuestionSet(){
        return Fill(new Set());
    }

    public Set Fill(Set set){
        set.Name = Title;
        set.Text = Text;
        ImageUrl_206px = QuestionSetImageSettings.Create(set.Id).GetUrl_206px_square().Url;
        QuestionsInSet = set.QuestionsInSet;

        return set;
    }

    public void SetToCreateModel()
    {
        IsEditing = false;
        PageTitle = FormTitle = "Fragesatz erstellen";
    }

    public void SetToUpdateModel()
    {
        PageTitle = "Fragesatz bearbeiten (" + Title.Truncate(30, "...") +")";
        FormTitle = string.Format("Fragesatz '{0}' bearbeiten", Title.TruncateAtWord(30)); ;
        IsEditing = true;
    }

    public bool IsOwner(int userId)
    {
        return _sessionUser.IsOwner(userId);
    }
}