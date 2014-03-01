﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="TrueOrFalse.Web.Context" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>


<a class="SimpleTextLink" href="<%= Url.Action(Links.HelpWillkommen, Links.HelpController) %>">
    <i class="fa fa-question-circle" id="tabInfoMyKnowledge"></i>
    <span class="TextSpan hidden-xs">Hilfe & mehr</span>
</a> 
<%
    var userSession = new SessionUser();
    
    if (userSession.IsLoggedIn)
    {
        var imageSetttings = new UserImageSettings(userSession.User.Id);
%>
        <div class="dropdown" style="display: inline-block;">
            <a class="SimpleTextLink dropdown-toggle" id="dLabel" role="button" data-toggle="dropdown" data-target="#" href="#">
                <span class="TextSpan">Hallo <b><%= userSession.User.Name%></b>!</span>
                <b class="caret"></b>
                <img src="<%= imageSetttings.GetUrl_30px_square(userSession.User.EmailAddress).Url %>" /> 
            </a>
            <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dLabel">            
                <li><a href="<%=Url.Action(Links.User, Links.UserController, new {name = userSession.User.Name, id = userSession.User.Id}) %>">Dein Profil</a></li>
                <li><a href="<%= Url.Action(Links.UserSettings, Links.UserSettingsController) %>"><i class="fa fa-wrench" title="Einstellungen"></i> Einstellungen</a></li>
                <li class="divider"></li>
                 
                <li><a href="<%= Url.Action(Links.Logout, Links.AccountController) %>"><i class="fa fa-power-off" title="Abmelden"></i> Abmelden</a>  </li>
                <% if(userSession.IsInstallationAdmin){ %>
                    <li><a href="<%= Url.Action("RemoveAdminRights", Links.AccountController) %>"><i class="fa fa-power-off" title="Abmelden"></i> Adminrechte abgeben</a>  </li>
                <% } %>
            </ul>
        </div>
<%
    }else {
%> 
        <a class="SimpleTextLink" href="<%=Url.Action("LogOn", Links.AccountController) %>"><span class="TextSpan">Anmelden</span></a>
<%
    }
%>    