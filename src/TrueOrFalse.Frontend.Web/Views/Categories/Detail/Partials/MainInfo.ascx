﻿<%@ Control Language="C#" AutoEventWireup="true" 
    Inherits="System.Web.Mvc.ViewUserControl<CategoryModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>


<div style="padding-bottom: 15px;">
    <div class="BreadcrumbsMobile DesktopHide">
        <% var breadCrumb = Model.BreadCrumb;
            if (breadCrumb.Count == 1 && Model.RootCategoriesList.Contains(breadCrumb.First()))
            { %>
            <a href="/" class="category-icon">
                <i class="fa fa-home show-tooltip" title="Startseite"></i>
            </a>
            <span> <i class="fa fa-chevron-right"></i> </span>
            <a href="<%= Links.CategoryDetail(breadCrumb.First()) %>" class=""><%= breadCrumb.First().Name %></a>
        <% }
           else
           {
                foreach (var rootCategory in Model.RootCategoriesList)
                {
                   if (breadCrumb.First() == rootCategory)
                   {
                        switch (Model.RootCategoriesList.IndexOf(rootCategory))
                        {
                            case 0:
                            %>
                            <a href="<%= Links.CategoryDetail(rootCategory) %>" class="category-icon">
                                <i class="fa fa-child show-tooltip" title="Schule"></i>
                            </a>
                            <%
                            break;

                            case 1:
                            %> 
                            <a href="<%= Links.CategoryDetail(rootCategory) %>" class="category-icon">
                                <i class="fa fa-graduation-cap show-tooltip" title="Studium"></i>
                            </a>
                            <%
                            break;

                            case 2:
                            %>
                            <a href="<%= Links.CategoryDetail(rootCategory) %>" class="category-icon">
                                <i class="fa fa-file-text show-tooltip" title="Zertifikate"></i>
                            </a>
                            <%
                            break;

                            case 3:
                            %>
                            <a href="<%= Links.CategoryDetail(rootCategory) %>" class="category-icon">
                                <i class="fa fa-lightbulb-o show-tooltip" title="Allgemeinwissen"></i>
                            </a>
                            <%
                            break;
                            
                            //default:
                            //throw new Exception("This should not happen");
                        }
                        break;
                   }
                }
            
                for (var i = 1; i < breadCrumb.Count; i++)
                { %>
                <span> <i class="fa fa-chevron-right"></i> </span>
                <a href="<%= Links.CategoryDetail(breadCrumb[i]) %>" class=""><%= breadCrumb[i].Name %></a>
            <% } %>
        <% } %>
    </div>
</div>

<div id="ItemMainInfo" class="Category Box">
    
    <div>
        <div class="row">
            <div class="col-xs-12">
                <header>
                    <div id="AboveMainHeading" class="greyed">
                        <%= Model.Category.Type == CategoryType.Standard ? "Thema" : Model.Type %> mit <%= Model.AggregatedSetCount %> Lernset<%= StringUtils.PluralSuffix(Model.AggregatedSetCount, "s") %> und <%= Model.AggregatedQuestionCount %> Frage<%= StringUtils.PluralSuffix(Model.AggregatedQuestionCount, "n") %>
                        <% if(Model.IsInstallationAdmin) { %>
                            <span style="margin-left: 10px; font-size: smaller;" class="show-tooltip" data-placement="right" data-original-title="Nur von admin sichtbar">
                                (<i class="fa fa-user-secret">&nbsp;</i><%= Model.GetViews() %> views)
                            </span>    
                        <% } %>
                    </div>
                    <div id="MainHeading">
                        <h1>
                           <%= Model.Name %>
                        </h1>
                        <%--<% Html.RenderPartial("~/Views/Categories/Detail/CategoryKnowledgeBar.ascx", new CategoryKnowledgeBarModel(Model.Category)); %>--%>
                    </div>
                </header>
            </div>
            <div class="xxs-stack col-xs-4 col-sm-3">
                <div class="ImageContainer">
                    <%= Model.ImageFrontendData.RenderHtmlImageBasis(350, false, ImageType.Category, "ImageContainer") %>
                </div>
            </div>
            <div class="xxs-stack col-xs-8 col-sm-9">
                
                <% if (Model.Type != "Standard") { %>
                    <div>                    
                        <% Html.RenderPartial("Reference", Model.Category); %>
                    </div>
                <% } %>
                
                <div class="row">
                    <div class="col-md-12">
                        
                        <div  style="float: right; width: 300px;">
                            <div style="padding-left: 20px; font-weight: lighter; color: darkgrey;">Dein Wissensstand:</div>
                            <div style="padding-left: 20px; padding-bottom: 15px; padding-top: 7px;" id="knowledgeWheelContainer">
                                <% Html.RenderPartial("/Views/Knowledge/Wheel/KnowledgeWheel.ascx", Model.KnowledgeSummary);  %>
                            </div>
                        </div>

                        <div class="Description"><span><%= Model.Description %></span></div>
                    </div>
                    
                </div>
                
                <% if (!String.IsNullOrEmpty(Model.Url)){ %>
                    <div>
                        <div class="WikiLink">
                            <a href="<%= Model.Url %>" target="_blank" class="" title="" data-placement="left" data-html="true">
                                <i class='fa fa-external-link'>&nbsp;&nbsp;</i><%= string.IsNullOrEmpty(Model.Category.UrlLinkText) ? Model.Url : Model.Category.UrlLinkText %>
                            </a>
                        </div>
                    </div>
                <% } %>
                <% if (!String.IsNullOrEmpty(Model.WikipediaURL)){ %>
                    <div>
                        <div class="WikiLink">
                            <a href="<%= Model.WikipediaURL %>" target="_blank" class="show-tooltip" title="<%= Links.IsLinkToWikipedia(Model.WikipediaURL) ? "Link&nbsp;auf&nbsp;Wikipedia" : "" %>" data-placement="left" data-html="true">
                                <% if(Links.IsLinkToWikipedia(Model.WikipediaURL)){ %>
                                    <i class="fa fa-wikipedia-w">&nbsp;</i><% } %><%= Model.WikipediaURL %>
                            </a>
                        </div>
                    </div>
                <% } %>
            
                <div class="Divider" style="margin-top: 10px; margin-bottom: 5px;"></div>
                <div class="BottomBar">
                    <div style="float: left; padding-top: 3px;">
                        <div class="fb-share-button" data-href="<%= Settings.CanonicalHost + Links.CategoryDetail(Model.Name, Model.Id) %>" data-layout="button" data-size="small" data-mobile-iframe="true">
                            <a class="fb-xfbml-parse-ignore" target="_blank" href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fplugins%2F&amp;src=sdkpreparse">Teilen</a>
                        </div>
                    
                        <div class="navLinks">  
                            <% if(Model.IsOwnerOrAdmin){ %>
                                <a href="<%= Links.CategoryEdit(Url, Model.Name, Model.Id) %>" style="font-size: 12px;"><i class="fa fa-pencil"></i>&nbsp;<span class="visible-lg">bearbeiten</span></a> 
                            <% } %>
                            <% if(Model.IsInstallationAdmin){ %>
                                <a href="<%= Links.CreateQuestion(categoryId: Model.Id) %>" style="font-size: 12px;"><i class="fa fa-plus-circle"></i>&nbsp;<span class="visible-lg">Frage hinzufügen</span></a>
                            <% } %>
                        </div>                        
                            
                    </div>
                   
                    <div style="float: right">
                        <span style="display: inline-block; font-size: 16px; font-weight: normal;" class="Pin" data-category-id="<%= Model.Id %>">
                            <%= Html.Partial("AddToWishknowledgeButton", new AddToWishknowledge(Model.IsInWishknowledge)) %>
                        </span>
                    </div>

                </div>
            </div>
        </div>
    </div>    
</div>

<% if (!Model.Category.DisableLearningFunctions) { %>

    <div class="row BoxButtonBar">
        <div class="BoxButtonColumn">
            <% var tooltipGame = "Tritt zu diesem Thema gegen andere Nutzer im Echtzeit-Quizspiel an.";
               if (Model.CountSets == 0)
                   tooltipGame = "Noch keine Lernsets zum Spielen zu diesem Thema vorhanden"; %>

            <div class="BoxButton show-tooltip 
                <%= !Model.IsLoggedIn ? "LookDisabled" : "" %> 
                <%= Model.CountSets == 0 ? "LookNotClickable" : "" %>"
                data-original-title="<%= tooltipGame %>">
                <div class="BoxButtonIcon"><i class="fa fa-gamepad"></i></div>
                <div class="BoxButtonText">
                    <span>Spiel starten</span>
                </div>
                <% if (Model.CountSets > 0)
                   { %>
                    <a href="<%= Links.GameCreateFromCategory(Model.Id) %>" rel="nofollow"
                    data-allowed="logged-in" data-allowed-type="game">
                    </a>
                <% } %>
            </div>
        </div>
        <div class="BoxButtonColumn">
            <% var tooltipDate = "Gib an, bis wann du alle Lernsets zu diesem Thema lernen musst und erhalte deinen persönlichen Lernplan.";
               if (Model.CountSets == 0)
                   tooltipDate = "Noch keine Lernsets zu diesem Thema vorhanden"; %>
            <div class="BoxButton show-tooltip 
                <%= !Model.IsLoggedIn ? "LookDisabled" : "" %>
                <%= Model.CountSets == 0 ? "LookNotClickable" : "" %>"
                data-original-title="<%= tooltipDate %>">
                <div class="BoxButtonIcon"><i class="fa fa-calendar"></i></div>
                <div class="BoxButtonText">
                    <span>Prüfungstermin anlegen</span> 
                </div>
                <% if (Model.CountSets > 0)
                   { %>
                    <a href="<%= Links.DateCreateForCategory(Model.Id) %>" rel="nofollow" data-allowed="logged-in" data-allowed-type="date-create"></a>
                <% } %>
            </div>
        </div>
        <div class="BoxButtonColumn">
            <% var tooltipTest = "Teste dein Wissen mit " + Settings.TestSessionQuestionCount + " zufällig ausgewählten Fragen zu diesem Thema und jeweils nur einem Antwortversuch.";
               if (Model.CountSets == 0 && Model.CountAggregatedQuestions == 0)
                   tooltipTest = "Noch keine Lernsets oder Fragen zum Testen zu diesem Thema vorhanden"; %>
            <div class="BoxButton show-tooltip 
                <%= Model.CountSets == 0 && Model.CountAggregatedQuestions == 0 ? "LookNotClickable" : "" %>"
                data-original-title="<%= tooltipTest %>">
                <div class="BoxButtonIcon"><i class="fa fa-play-circle"></i></div>
                <div class="BoxButtonText">
                    <span>Wissen testen</span>
                </div>
                <% if (Model.CountSets > 0 || Model.CountAggregatedQuestions > 0)
                   { %>
                    <a href="<%= Links.TestSessionStartForCategory(Model.Name, Model.Id) %>" rel="nofollow"></a>
                <% } %>
            </div>
        </div>
        <div class="BoxButtonColumn">
            <% var tooltipLearn = "Lerne zu diesem Thema genau die Fragen, die du am dringendsten wiederholen solltest.";
               if (Model.CountSets == 0 && Model.CountAggregatedQuestions == 0)
                   tooltipLearn = "Noch keine Lernsets oder Fragen zum Lernen zu diesem Thema vorhanden"; %>
             <div class="BoxButton show-tooltip 
                <%= !Model.IsLoggedIn ? "LookDisabled" : "" %>
                <%= Model.CountSets == 0 && Model.CountAggregatedQuestions == 0 ? "LookNotClickable" : "" %>"
                data-original-title="<%= tooltipLearn %>">
                <div class="BoxButtonIcon"><i class="fa fa-line-chart"></i></div>
                <div class="BoxButtonText">
                    <span>Lernen</span>
                </div>
                <% if (Model.CountSets > 0 || Model.CountAggregatedQuestions > 0)
                   { %>
                    <a href="<%= Links.StartCategoryLearningSession(Model.Id) %>" rel="nofollow" data-allowed="logged-in" data-allowed-type="date-create"></a>
                <% } %>
            </div>
        </div>
    </div>

<% } %>

