﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Sidebar.Master" Inherits="System.Web.Mvc.ViewPage<CategoryModel>"%>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="ContentHeadSEO" ContentPlaceHolderID="HeadSEO" runat="server">
    <% Title = Model.MetaTitle; %>
    <link rel="canonical" href="<%= Settings.CanonicalHost + Links.CategoryDetail(Model.Name, Model.Id) %>">
    <meta name="description" content="<%= Model.MetaDescription %>"/>
    <meta property="og:title" content="<%: Model.Name %>" />
    <meta property="og:url" content="<%= Settings.CanonicalHost + Links.CategoryDetail(Model.Name, Model.Id) %>" />
    <meta property="og:type" content="article" />
    <meta property="og:image" content="<%= Model.ImageFrontendData.GetImageUrl(350, false, imageTypeForDummy: ImageType.Category).Url %>" />
    
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</asp:Content>

<asp:Content ID="head" ContentPlaceHolderID="Head" runat="server">
    <link href="/Views/Questions/Answer/LearningSession/LearningSessionResult.css" rel="stylesheet" />
    <%= Styles.Render("~/bundles/AnswerQuestion") %>
    <%= Styles.Render("~/bundles/Category") %>
    <%= Scripts.Render("~/bundles/js/Category") %>
    <%= Scripts.Render("~/bundles/js/DeleteQuestion") %>
    <%= Scripts.Render("~/bundles/js/AnswerQuestion") %>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script src="http://d3js.org/d3.v4.min.js"></script>
    <% Model.SidebarModel.AutorCardLinkText = Model.CreatorName;
        Model.SidebarModel.AutorImageUrl = Model.ImageUrl_250;
        Model.SidebarModel.Creator = Model.Creator;
        Model.SidebarModel.MultipleImageUrl.Add(Model.ImageUrl_250);
        Model.SidebarModel.MultipleCreatorName.Add(Model.Creator.Name);
        Model.SidebarModel.MultipleCreator.Add(Model.Creator);
        foreach(var child in Model.CategoriesChildren)
        {
            if (!(Model.SidebarModel.MultipleCreatorName.Where(o=> string.Equals(child.Creator.Name, o, StringComparison.OrdinalIgnoreCase)).Any())) {
                  var imageResult = new UserImageSettings(child.Creator.Id).GetUrl_250px(child.Creator);
                  Model.SidebarModel.MultipleImageUrl.Add(imageResult.Url);
                  Model.SidebarModel.MultipleCreatorName.Add(child.Creator.Name);
                  Model.SidebarModel.MultipleCreator.Add(child.Creator);
            }
        }%>    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hhdCategoryId" value="<%= Model.Category.Id %>"/>
    <input type="hidden" id="hddUserId" value="<%= Model.UserId %>"/>
   

    <% Html.RenderPartial("~/Views/Categories/Detail/Partials/CategoryHeader.ascx", Model);%>
                
    <div id="TopicTabContent" class="TabContent">
        <% Html.RenderPartial("~/Views/Categories/Detail/Tabs/TopicTab.ascx", Model); %>
    </div>
    <div id="LearningTabContent" class="TabContent" style="display: none;">
        <% Html.RenderPartial("~/Views/Categories/Detail/Tabs/LearningTab.ascx", Model); %>
    </div>
    <div id="AnalyticsTabContent" class="TabContent"></div>  
</asp:Content>