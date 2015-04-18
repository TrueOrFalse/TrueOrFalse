﻿using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Seedworks.Lib;
using TrueOrFalse.Frontend.Web.Code;

public class SetRowModel
{
    public int Id;
    public string Name;
    public string DescriptionShort;

    public int IndexInResult;

    public int QuestionCount;
    public IList<Category> Categories; 

    public Func<UrlHelper, string> DetailLink;
    public Func<UrlHelper, string> UserLink;

    public ImageFrontendData ImageFrontendData;

    public string CreatorName;
    public int CreatorId;
    public bool IsOwner;

    public int RelevancePersonal;
    public string TotalPins;

    public bool IsInWishknowledge;

    public SetRowModel(
        Set set, 
        SetValuation setValuation,
        int indexInResultSet, 
        int currentUserid)
    {
        Id = set.Id;
        Name = set.Name;
        CreatorId = set.Creator.Id;

        DescriptionShort = !String.IsNullOrEmpty(set.Text) ? (set.Text.Wrap(150)) : "";
        
        QuestionCount = set.QuestionsInSet.Count;
        CreatorName = set.Creator.Name;
        IsOwner = currentUserid == set.Creator.Id;
        IndexInResult = indexInResultSet;

        var imageMetaData = ServiceLocator.Resolve<ImageMetaDataRepository>().GetBy(set.Id, ImageType.QuestionSet);
        ImageFrontendData = new ImageFrontendData(imageMetaData);

        RelevancePersonal = setValuation.RelevancePersonal;
        IsInWishknowledge = setValuation.IsInWishknowledge();

        TotalPins = set.TotalRelevancePersonalEntries.ToString();

        DetailLink = urlHelper => Links.SetDetail(urlHelper, set, indexInResultSet);
        UserLink = urlHelper => Links.UserDetail(urlHelper, set.Creator.Name, set.Creator.Id);

        Categories = set.Categories;
    }

}