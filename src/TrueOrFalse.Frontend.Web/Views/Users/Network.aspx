﻿<%@ Page Title="Nutzer" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="ViewPage<NetworkModel>" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
    <%= Styles.Render("~/bundles/Users") %>
    <%= Scripts.Render("~/bundles/js/Users") %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SubHeader" runat="server">
    <% Html.RenderPartial("HeaderMobile", Model.HeaderModel); %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
<div id="user-main">
    <% using (Html.BeginForm()) { %>

        <div class="boxtainer-outlined-tabs">
            
            <% Html.RenderPartial("Header", Model.HeaderModel); %>
        
            <div class="boxtainer-content">
                <div class="search-section">
    
                    <h4 style="margin-bottom: 15px; margin-top: 0px;">
                        <span class="ColoredUnderline User">Du folgst <span class="JS-AmountFollowers"><%= Model.UsersIFollow.Count() %></span> Nutzer<%= StringUtils.Plural(Model.UsersIFollow.Count(),"n","","n") %></span>
                    </h4>
                    
                    <% if(!Model.UsersIFollow.Any()){ %>
                        <div class="bs-callout bs-callout-info"  
                            style="margin-top: 0; margin-bottom: 10px;">
                            <h4>Noch folgst du niemanden</h4>
                            <p style="padding-top: 5px;">
                                Um Nutzern zu folgen, gehe zur
                                <a href="<%= Url.Action("Users", "Users") %>">"Alle Nutzer"</a> 
                                Seite und verwende den "Folgen"-Button. <br/><br/>
                            </p>
                        </div>
                    <% } else { %>

                        <div style="clear: both;"> 
                            <% foreach(var row in Model.UsersIFollow){
                                Html.RenderPartial("UserRow", row);
                            } %>
                        </div>
                    
                    <% } %>
                    
                    <div class="clearfix" style="width: 100%"></div>

                    <h4 style="margin-bottom: 15px; margin-top: 0px;" class="clearfix">
                        <span class="ColoredUnderline User">Dir folg<%= StringUtils.Plural(Model.UsersFollowingMe.Count(),"en","t","en") %> <%= Model.UsersFollowingMe.Count() %> Nutzer</span>
                    </h4>
                    
                    <% if (!Model.UsersFollowingMe.Any()){ %>
                    
                        <div class="bs-callout bs-callout-info"  
                            style="margin-top: 0; margin-bottom: 10px;">
                            <h4>Noch folgt dir niemand</h4>
                            <p style="padding-top: 5px;">
                                Nutzer folgen dir, wenn du interessante Inhalte erstellst.<br/>
                                Folgen dir viele Nutzer, erhältst du Badges.
                            </p>
                        </div>
                    
                    <% } else { %>
                        <div style="clear: both;">
                            <% foreach(var row in Model.UsersFollowingMe){
                                Html.RenderPartial("UserRow", row);
                            } %>
                        </div>                    
                    <% } %>

                </div>
            </div>
        </div>
    <% } %>
</div>
</asp:Content>
