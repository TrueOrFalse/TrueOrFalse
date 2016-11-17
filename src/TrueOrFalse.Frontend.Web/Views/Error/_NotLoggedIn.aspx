﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="System.Web.Mvc.ViewPage<BaseModel>" 
        Title="Fehler"
%>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" >

    /* Source http://www.html-advisor.com/javascript/hide-email-with-javascript-jquery/ */
    $(function () {
        var spt = $('span.mailme');
        var at = / at /;
        var dot = / dot /g;
        var addr = $(spt).text().replace(at, "@").replace(dot, ".");
        $(spt).after('<a href="mailto:' + addr + '" title="Send an email">' + addr + '</a>').hover(function () { window.status = "Send a letter!"; }, function () { window.status = ""; });
        $(spt).remove();
    });
</script>    
        
    <h1 style="margin-top: 0px;">Nicht angemeldet.</h1>
    
    <p>
        Um die Funktion zu nutzen, mußt du eingeloggt sein.
        <br />
        <br />
        <a href="<%= Url.Action("Login", "Welcome") %>" class="btn btn-success">Jetzt einloggen</a> oder
        <a href="<%= Url.Action("Register", "Welcome") %>"> registrieren</a>
    </p>

</asp:Content>