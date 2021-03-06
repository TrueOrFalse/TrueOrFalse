﻿<%@ Page Title="Maintenance: ContentCreatedReport" Language="C#" MasterPageFile="~/Views/Shared/Site.Sidebar.Master" Inherits="System.Web.Mvc.ViewPage<ContentCreatedReportModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="Head">
    <link href="/Style/site.css" rel="stylesheet" />
    <link href="/Views/Maintenance/ContentCreatedReport.css" rel="stylesheet" />
      <% Model.TopNavMenu.BreadCrumb.Add(new TopNavMenuItem{Text = "Administrativ", Url = "/Maintenance", ToolTipText = "Administrativ"});
         Model.TopNavMenu.BreadCrumb.Add(new TopNavMenuItem{Text = "Cnt-Created", Url = "/Maintenance/ContentCreatedReport", ToolTipText = "Cnt-Created"});
        Model.TopNavMenu.IsCategoryBreadCrumb = false; %>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <nav class="navbar navbar-default" style="" role="navigation">
        <div class="container">
            <a class="navbar-brand" href="#">Maintenance</a>
            <ul class="nav navbar-nav">
                <li><a href="/Maintenance">Allgemein</a></li>
                <li><a href="/MaintenanceImages/Images">Bilder</a></li>
                <li><a href="/Maintenance/Messages">Nachrichten</a></li>
                <li><a href="/Maintenance/Tools">Tools</a></li>
                <li><a href="/Maintenance/CMS">CMS</a></li>
                <li class="active"><a href="/Maintenance/ContentCreatedReport">Cnt-Created</a></li>
                <li><a href="/Maintenance/Statistics">Stats</a></li>
            </ul>
        </div>
    </nav>
        
    <div class="row">
        <div class="col-xs-12">
            <h1 class="" style="margin-top: 0;">Erstellte/Bearbeitete Inhalte</h1>
            <ul>
                <li><a href="#CategoriesAdded">Themen erstellt</a></li>
                <li><a href="#CategoriesEdited">Themen bearbeitet</a></li>
                <li><a href="#RecentQuestionsAddedNotMemucho">Fragen erstellt ohne memucho</a></li>
                <li><a href="#RecentQuestionsAddedMemucho">Fragen erstellt memucho</a></li>
            </ul>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12">
            <h4 id="CategoriesAdded">Themen, die seit <%= Model.Since %> erstellt wurden: <%= Model.CategoriesAdded.Count %></h4>
            <span class="greyed" style="font-size: 10px;"><a href="#Top">(nach oben)</a></span>

            <% foreach (var category in Model.CategoriesAdded) {%>
                <div>
                    <span class="greyed" style="font-size: 10px;"><%= category.DateCreated %></span> 
                    <a href="<%= Links.UserDetail(category.Creator) %>" class="linkUser"><%= category.Creator.Name %></a>: 
                    <a href="<%= Links.CategoryDetail(category) %>"><%: category.Name %></a> 
                </div>
            <%} %>
        </div>

        <div class="col-xs-12">
            <h4 id="CategoriesEdited">Themen, die seit <%= Model.Since %> bearbeitet wurden</h4>
            <span class="greyed" style="font-size: 10px;"><a href="#Top">(nach oben)</a></span>

            <% foreach (var categoryChangeGroup in Model.CategoriesChanged) {%>
                <div style="margin-bottom: 10px;">
                    <a href="<%= Links.CategoryDetail(categoryChangeGroup.Key) %>"><%: categoryChangeGroup.Key.Name %></a> 
                    <% foreach (var categoryChange in categoryChangeGroup) { %>
                        <div style="margin-left: 20px;">
                            <a href="<%= Links.UserDetail(categoryChange.Author) %>" class="linkUser"><%= categoryChange.Author.Name %></a>  
                            <span class="greyed" style="font-size: 10px;">am <%= categoryChange.DateCreated %></span> (Datenlänge neu: <%= categoryChange.Data.Length %>)
                        </div>
                    <% } %>
                </div>
            <%} %>
        </div>

        <div class="col-xs-12">
            <h4 id="RecentQuestionsAddedNotMemucho">Alle nicht von memucho seit <%= Model.Since %> erstellten Fragen: <%= Model.RecentQuestionsAddedNotMemucho.Count %></h4>
            <span class="greyed" style="font-size: 10px;"><a href="#Top">(nach oben)</a></span>

            <% foreach (var question in Model.RecentQuestionsAddedNotMemucho) {%>
                <div class="LabelItem LabelItem-Question">
                    <span class="greyed" style="font-size: 10px;"><%= question.DateCreated %></span> 
                    <a href="<%= Links.UserDetail(question.Creator) %>" class="linkUser"><%= question.Creator.Name %></a>: 
                    <%= question.IsPrivate()? "<i class='fa fa-lock'></i> " : "" %>
                    <a href="<%= Links.AnswerQuestion(question) %>"><%: question.Text %></a>
                </div>
            <%} %>
        </div>

        <div class="col-xs-12">
            <h4 id="RecentQuestionsAddedMemucho">Alle von memucho seit <%= Model.Since %> erstellten Fragen: <%= Model.RecentQuestionsAddedMemucho.Count %></h4>
            <span class="greyed" style="font-size: 10px;"><a href="#Top">(nach oben)</a></span>

            <% foreach (var question in Model.RecentQuestionsAddedMemucho) {%>
                <div class="LabelItem LabelItem-Question">
                    <span class="greyed" style="font-size: 10px;"><%= question.DateCreated %></span> 
                    <%= question.IsPrivate()? "<i class='fa fa-lock'></i> " : "" %>
                    <a href="<%= Links.AnswerQuestion(question) %>"><%: question.Text %></a>
                </div>
            <%} %>
        </div>
    </div>

</asp:Content>