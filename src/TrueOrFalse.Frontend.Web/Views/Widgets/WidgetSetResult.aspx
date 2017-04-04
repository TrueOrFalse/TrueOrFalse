﻿<%@ Page Title="Spielen" Language="C#" 
    MasterPageFile="~/Views/Shared/Site.Widget.Master" 
    Inherits="ViewPage<WidgetSetResultModel>" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<asp:Content ID="Content3" ContentPlaceHolderID="Head" runat="server">
    <style type="text/css">
        html { height: auto;}
    </style>
    <%= Scripts.Render("~/bundles/js/TestSessionResult") %>
    <link href="/Views/Questions/Answer/LearningSession/LearningSessionResult.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    
    
    <% if(Model.TestSessionResultModel.TestSession.SessionNotFound) { %>
    
        <h2>Uuups...</h2>
        <p>die Testsitzung ist nicht mehr aktuell.</p>

    <% } else { %>

        <% Html.RenderPartial("~/Views/Questions/Answer/TestSession/TestSessionResultHead.ascx", Model.TestSessionResultModel);  %>
        
        <div class="row">
            <div class="col-sm-12">
                <% Html.RenderPartial("~/Views/Questions/Answer/TestSession/TestSessionResultDetails.ascx", Model.TestSessionResultModel);  %>
            </div>
        </div>
    
        <div class="buttonRow">
            <a href="<%= Model.TestSessionResultModel.LinkForRepeatTest %>" class="btn btn-primary show-tooltip" style="padding-right: 10px"
                    title="Neue Fragen <% if (Model.TestSessionResultModel.TestSession.IsSetSession) Response.Write("aus dem gleichen Fragesatz");
                                                else if (Model.TestSessionResultModel.TestSession.IsSetsSession) Response.Write("aus den gleichen Fragesätzen");
                                                else if (Model.TestSessionResultModel.TestSession.IsCategorySession) Response.Write("zum gleichen Thema");%>
                " rel="nofollow">
                <i class="fa fa-play-circle AnswerResultIcon">&nbsp;&nbsp;</i>Weitermachen!
            </a>
        </div>
    
    <% } %>

</asp:Content>