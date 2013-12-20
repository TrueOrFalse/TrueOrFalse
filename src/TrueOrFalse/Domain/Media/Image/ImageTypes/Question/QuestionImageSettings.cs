﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

public class QuestionImageSettings : IImageSettings
{
    public int Id { get; private set; }

    public IEnumerable<int> SizesSquare { get { return new[] { 512, 128, 50, 20 }; } }
    public IEnumerable<int> SizesFixedWidth { get { return new[] { 500, 435, 100 }; } }

    public string BasePath { get { return "/Images/Questions/"; } }

    public string ServerPathAndId(){
        return HttpContext.Current.Server.MapPath("/Images/Questions/" + Id);
    }

    public QuestionImageSettings(){}

    public QuestionImageSettings(int questionId){
        Init(questionId);
    }

    public void Init(int questionId){
        Id = questionId;
    }

    public ImageUrl GetUrl_128px_square() { return GetUrl(128, isSquare: true); }
    public ImageUrl GetUrl_128px() { return GetUrl(128); }
    public ImageUrl GetUrl_435px() { return GetUrl(435); }
    public ImageUrl GetUrl_500px() { return GetUrl(500); }

    private ImageUrl GetUrl(int width, bool isSquare = false){
        return ImageUrl.Get(this, width, isSquare, arg => "/Images/no-question-" + width + ".png");
    }

    public static QuestionImageSettings Create(int questionId)
    {
        var result = new QuestionImageSettings();
        result.Init(questionId);
        return result;
    }
}