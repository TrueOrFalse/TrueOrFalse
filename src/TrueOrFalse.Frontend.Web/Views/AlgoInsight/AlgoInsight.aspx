﻿<%@ Page Title="Algorithmus-Einblick" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="ViewPage<AlgoInsightModel>" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<asp:Content runat="server" ID="header" ContentPlaceHolderID="Head">
    
    <%= Styles.Render("~/bundles/AlgoInsight") %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <% if(Model.Message != null) { %>
        <div class="row">
            <div class="col-xs-12 xxs-stack">
                <% Html.Message(Model.Message); %>
            </div>
        </div>        
    <% } %>

    <h2 style="color: black; margin-bottom: 5px; margin-top: 0px;">
        <span class="ColoredUnderline Knowledge">Algorithmus-Einblick</span>
    </h2>
    
    <div class="alert alert-info col-md-12" style="margin-top: 14px; margin-bottom: 26px;">
        <p>
            Hier erhältst du Einblick in die Algorithmen, die die <b>Antwortwahrscheinlichkeit</b> 
            und den <b>optimalen Wiedervorlage-Zeitpunkt</b> berechnen.
            MEMuchO ist Open Source<a href="https://github.com/TrueOrFalse/TrueOrFalse"> (auf Github)</a>. 
            Wir freuen uns über Verbesserungsvorschläge.
        </p>        
    </div>
            
    <div class="row">
        
        <div id="MobileSubHeader" class="MobileSubHeader DesktopHide" style="margin-top: 0px;">
            <div class="MainFilterBarWrapper">
                <div id="MainFilterBarBackground" class="btn-group btn-group-justified">
                    <div class="btn-group">
                        <a class="btn btn-default disabled">.</a>
                    </div>
                </div>
                <div class="container">
                    <div id="MainFilterBar" class="btn-group btn-group-justified JS-Tabs">

                        <div class="btn-group <%= Model.IsActiveTabForecast ? "active" : "" %>">
                            <a href="<%= Url.Action("Forecast", "AlgoInsight") %>" type="button" class="btn btn-default">
                                Vorhersage
                            </a>
                        </div>
                    
                        <div class="btn-group  <%= Model.IsActiveTabRepetition ? "active" : "" %>">
                            <a  href="<%= Url.Action("Repetition", "AlgoInsight") %>" type="button" class="btn btn-default">
                                Wiederholung
                            </a>
                        </div>
                    
                        <div class="btn-group  <%= Model.IsActiveTabLearningCurve ? "active" : "" %>">
                            <a  href="<%= Url.Action("LearningCurve", "AlgoInsight") %>" type="button" class="btn btn-default">
                                Vergessenskurve
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-12">
            <div class="boxtainer-outlined-tabs" style="margin-top: 0px;">
                <div class="boxtainer-header MobileHide">
                    <ul class="nav nav-tabs">
                        <li class="<%= Html.IfTrue(Model.IsActiveTabForecast, "active") %>">
                            <a href="<%= Url.Action("Forecast", "AlgoInsight") %>" >
                                Vorhersage
                            </a>
                        </li>
                        <li class="<%= Html.IfTrue(Model.IsActiveTabRepetition, "active") %>">
                            <a href="<%= Url.Action("Repetition", "AlgoInsight") %>">
                                Wiederholung
                            </a>
                        </li>
                        <li class="<%= Html.IfTrue(Model.IsActiveTabLearningCurve, "active") %>">
                            <a href="<%= Url.Action("LearningCurve", "AlgoInsight") %>">
                                Vergessenskurve
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="boxtainer-content">
                    <% if(Model.IsActiveTabForecast) { %>
                        <% Html.RenderPartial("TabForecast", new TabForecastModel()); %>
                    <% } %>
                    <% if(Model.IsActiveTabRepetition) { %>
                        <% Html.RenderPartial("TabRepetition", new TabRepetitionModel()); %>
                    <% } %>
                    <% if(Model.IsActiveTabLearningCurve) { %>
                        <% Html.RenderPartial("TabLearningCurve", new TabLearningCurveModel()); %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <% if(Model.IsInstallationAdmin) { %>
        <div class="row">
	        <div class="col-md-12" style="text-align: right; margin-top: 50px;">
		        <a href="<%= Url.Action("Reevaluate", "AlgoInsight") %>" class="btn btn-md btn-info">Teste Algorithmen (dauert mehrere Minuten)</a>
	        </div>
        </div>
    <% } %>

</asp:Content>
