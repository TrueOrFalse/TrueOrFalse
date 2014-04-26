﻿<%@ Page Title="" Language="C#" 
    MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" 
    Inherits="System.Web.Mvc.ViewPage<MaintenanceModel>"
    ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="col-md-9">        
        <div style="margin:0 0 0 -10px; position: relative;" class="container-fluid">
            <nav class="navbar navbar-default" style="" role="navigation">
                <div class="container">
                    <a class="navbar-brand" href="#">Maintenance</a>
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="/Maintenance">Allgemein</a></li>
                        <li><a href="/Maintenance/Images">Bilder</a></li>
                        <li><a href="/Maintenance/Messages">Nachrichten</a></li>
                    </ul>
                </div>
            </nav>
        </div>
        
        <% Html.Message(Model.Message); %>
    
        <h4>Fragen</h4>
        <a href="<%= Url.Action("RecalculateAllKnowledgeItems", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Alle Antwortwahrscheinlichkeiten neu berechnen
        </a><br/>
        <a href="<%= Url.Action("CalcAggregatedValuesQuestions", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Aggregierte Zahlen aktualisieren
        </a>
        
        <h4>Fragesätze</h4>
        <a href="<%= Url.Action("CalcAggregatedValuesSets", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Aggregierte Zahlen aktualisieren
        </a>&nbsp;&nbsp;
        <a href="<%= Url.Action("DeleteValuationsForRemovedSets", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            cleanup set valuations
        </a>
    
        <h4>Kategorien</h4>
        <a href="<%= Url.Action("UpdateFieldQuestionCountForCategories", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Feld: AnzahlFragen pro Kategorie aktualisieren
        </a>
        
        <h4>Nutzer</h4>
        <a href="<%= Url.Action("UpdateUserReputationAndRankings", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Rankings und Reputation + Aggregates
        </a>&nbsp;
        <a href="<%= Url.Action("UpdateUserWishCount", "Maintenance") %>">
            <i class="fa fa-retweet"></i>
            Aggregates
        </a>

        <h4>Suche</h4>
        Alle für Suche neu indizieren: <br/>
        <a href="<%= Url.Action("ReIndexAllQuestions", "Maintenance") %>">
            <i class="fa fa-retweet"></i>Fragen 
        </a> /
        <a href="<%= Url.Action("ReIndexAllSets", "Maintenance") %>">
            <i class="fa fa-retweet"></i>Fragesätze
        </a> /
        <a href="<%= Url.Action("ReIndexAllCategories", "Maintenance") %>">
            <i class="fa fa-retweet"></i>Kategorien
        </a> /
        <a href="<%= Url.Action("ReIndexAllUsers", "Maintenance") %>">
            <i class="fa fa-retweet"></i>Nutzer
        </a>        
        
        
        <br/><br/>
    </div>

</asp:Content>