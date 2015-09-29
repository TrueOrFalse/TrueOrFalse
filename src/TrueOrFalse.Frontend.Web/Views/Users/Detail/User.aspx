﻿<%@ Page Title="Nutzer" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master"
    Inherits="System.Web.Mvc.ViewPage<UserModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <title>Benutzer <%=Model.Name %> </title>
    <%= Styles.Render("~/bundles/User") %>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="xxs-stack col-xs-12">
            <div class="row">
                <div class="col-xs-9 xxs-stack" style="margin-bottom: 10px;">
                    <h2 class="pull-left ColoredUnderline User" style="margin-bottom: 10px; margin-top: 0px;  font-size: 30px;">
                        <%= Model.Name %>
                        <span style="display: inline-block; font-size: 20px; font-weight: normal;">
                            &nbsp;(Reputation: <%=Model.ReputationTotal %> - Rang <%= Model.ReputationRank %>)
                        </span>
                    </h2>
                </div>
                <div class="col-xs-3 xxs-stack">
                    <div class="navLinks">
                        <a href="<%= Url.Action("Users", "Users")%>" style="font-size: 12px; margin: 0px;"><i class="fa fa-list"></i>&nbsp;zur Übersicht</a>
                        <% if (Model.IsCurrentUser) { %>
                            <a href="<%= Url.Action(Links.UserSettings, Links.UserSettingsController) %>" style="font-size: 12px; margin: 0px;"><i class="fa fa-pencil"></i>&nbsp;bearbeiten</a> 
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    
        <div class="col-lg-10 col-xs-9 xxs-stack">
            <div class="box-content" style="min-height: 120px; clear: both; ">
            
                <div class="column">
                    <h4 style="margin-top: 0px;">Reputation</h4>
                    <div>- <%= Model.Reputation.ForQuestionsCreated %> für erstellte Fragen</div>
                    <div>- <%= Model.Reputation.ForQuestionsWishKnow + Model.Reputation.ForQuestionsWishCount %> für eigene Fragen im Wunschwissen anderer </div>
                    <div>- <%= Model.Reputation.ForSetWishCount + Model.Reputation.ForSetWishKnow %> für eigene Fragesätze im Wunschwissen anderer</div>
                </div>
                <div class="column" >
                    <h4 style="margin-top: 0px;">Erstellte Inhalte</h4>
                    <div><a href="<%= Links.QuestionWithCreatorFilter(Url, Model.User) %>"><%= Model.AmountCreatedQuestions %> Fragen erstellt</a></div>
                    <div><%= Model.AmountCreatedSets %> Fragesätze erstellt</div>
                    <div><%= Model.AmountCreatedCategories %>  Kategorien erstellt</div>
                </div>
            
                <div class="column">
                    <h4 style="margin-top: 0px;">Wunschwissen</h4>
                    <div><%= Model.AmountWishCountQuestions %> Fragen gemerkt</div>
                    <div><%= Model.AmountWishCountSets %> Fragesätze gemerkt</div>
                    <div></div>
                </div>

            </div>
        </div>
        
        <div class="col-lg-2 col-xs-3 xxs-stack">
            <img style="width:100%; border-radius:5px;" src="<%=Model.ImageUrl_250 %>" />          
        </div>
    </div>
    
    <div class="row" id="user-main">
        
        <div id="MobileSubHeader" class="MobileSubHeader DesktopHide" style="margin-top: 20px;">
            <div class="MainFilterBarWrapper">
                <div id="MainFilterBarBackground" class="btn-group btn-group-justified">
                    <div class="btn-group">
                        <a class="btn btn-default disabled">.</a>
                    </div>
                </div>
                <div class="container">
                    <div id="MainFilterBar" class="btn-group btn-group-justified JS-Tabs">

                        <div class="btn-group <%= Model.IsActiveTabKnowledge? "active" : "" %>">
                            <a  href="<%= Links.UserDetail(Model.User) %>" type="button" class="btn btn-default">
                                Wunsch<span class="hidden-xxs">wissen</span>
                            </a>
                        </div>
                    
                        <div class="btn-group  <%= Model.IsActiveTabBadges  ? "active" : "" %>">
                            <a  href="<%= Links.UserDetailBadges(Model.User) %>" type="button" class="btn btn-default">
                                Badges
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-12">
            <div class="boxtainer-outlined-tabs" style="margin-top: 20px;">
                <div class="boxtainer-header MobileHide">
                    <ul class="nav nav-tabs">
                        <li class="<%= Html.IfTrue(Model.IsActiveTabKnowledge, "active") %>">
                            <a href="<%= Links.UserDetail(Model.User) %>" >
                                Wunschwissen
                            </a>
                        </li>
                        <li class="<%= Html.IfTrue(Model.IsActiveTabBadges, "active") %>">
                            <a href="<%= Links.UserDetailBadges(Model.User) %>">
                                Badges (0 von <%= BadgeTypes.All().Count %>)
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="boxtainer-content">
                    <% if(Model.IsActiveTabKnowledge) { %>
                        <% Html.RenderPartial("~/Views/Users/Detail/TabKnowledge.ascx", new TabKnowledgeModel(Model)); %>
                    <% } %>
                    <% if(Model.IsActiveTabBadges) { %>
                        <% Html.RenderPartial("~/Views/Users/Detail/TabBadges.ascx", new TabBadgesModel(Model)); %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
