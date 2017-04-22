﻿<%@ Page Title="memucho-Quiz in Wordpress einbetten" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link href="/Views/Help/Widget.css" rel="stylesheet" />
    <script type="text/javascript" >

        $(function () {
            $("span.mailme")
                .each(function() {
                    var spt = this.innerHTML;
                    var at = / at /;
                    var dot = / dot /g;
                    var addr = spt.replace(at, "@").replace(dot, ".");
                    $(this).after('<a href="mailto:' + addr + '" title="Schreibe eine E-Mail">' + addr + '</a>');
                    $(this).remove();
                });
        });
    </script>    

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <% Html.RenderPartial("~/Views/Help/WidgetMenu.ascx", new WidgetMenuModel());  %>

    <div class="row">
        <div class="col-xs-12">

            <div class="well">

                <h1 class="PageHeader"><span class="ColoredUnderline GeneralMemucho">In Wordpress einbinden</span></h1>
                <p class="teaserText">
                    Die Lerntechnologie und die Lerninhalte von memucho können als Widget leicht in bestehende Wordpress-Webseiten und Blogs integriert werden. 
                    Nötig ist eine Zeile HTML-Code, die du einfach von memucho kopieren kannst. memucho hat verschiedene Widgets zur Auswahl 
                    (<a href="<%= Links.HelpWidget() %>" class="">zur Widget-Übersicht</a>).
                </p>
                   
            </div>
        </div>
    </div>



    <div class="row">
        <div class="col-xs-12">
            <div class="well explanationBox">

                <h2 class="PageHeader">
                    <span class="ColoredUnderline GeneralMemucho">Einbindung memucho-Widget in Wordpress: Anleitung</span>
                </h2>
                <p>
                    Auf der Seite des Fragesatzes, Video-Fragesatzes oder der einzelnen Frage findest du einen Link <code><i class="fa fa-code">&nbsp;</i>Einbetten</code>. 
                    Dort kannst das Widget, wenn du möchtest, konfigurieren und erhältst die Code-Zeile zur Einbettung des Widgets. Die Widgets werden ausführlich in der 
                    <a href="<%= Links.HelpWidget() %>">Widget-Übersicht</a> beschrieben.
                </p>
                <p>
                    Diese Code-Zeile kannst du in Wordpress einfach an die Stelle deines Beitrags (Posts) oder deiner Seite (Page) einfügen, wo der Quiz erscheinen soll.
                    Dafür musst du dich aber im HTML bzw. Text-Modus befinden. Das geht ganz leicht:
                </p>
                <h4>1. Seite oder Beitrag zum Editieren in Wordpress öffnen</h4>
                <p class="screenshotExplanation">
                    Öffne die Seite oder den Beitrag in Wordpress, wo du das Widget einbinden möchtest und editiere ihn. 
                    Im Texteditor-Fenster gehst du mit dem Cursor an die Stelle, wo das Widget erscheinen soll.
                </p>
                <p class="screenshot">
                    <img src="/Images/Screenshots/widget-wordpress-01.png" />
                </p>

                <h4>2. In den Text-Modus gehen</h4>
                <p class="screenshotExplanation">
                    Am oberen Rand des Editor-Fensters findest du rechts einen Umschalter von "Visuell" zu "Text": <img src="/Images/Screenshots/widget-wordpress-textmode-small.png"/><br/>
                    Klicke auf "Text", um den Text- bzw. HTML-Modus zu öffnen. Nun siehst du den gleichen Text, aber zum Teil mit den Formatierungen in der HTML-Sprache, die du an den spitzen Klammern erkennst.
                </p>
                <p class="screenshotExplanation">
                    Genau dort, wo der Cursor noch ist, kannst du nun die Code-Zeile des Widgets einfügen.
                </p>
                <p class="screenshot">
                    <img src="/Images/Screenshots/widget-wordpress-02.png" />
                </p>
                
                <h4>3. Fertig!</h4>
                <p class="screenshotExplanation">
                    Jetzt kannst du deine Seite anschauen und sehen, dass alles geklappt hat. Viel Spaß!
                </p>


                <p style="margin-top: 30px;">
                    <strong>Achtung:</strong> Bei einigen Wordpress-Versionen gehen Einstellungen des Widgets verloren, wenn zwischendurch wieder im "Visuell"-Modus gearbeitet wird. 
                    Dann musst du die Code-Zeile für das Widget am besten noch einmal vollständig einfügen.
                </p>
            </div>
        </div>
    </div>
    
   
    <div class="row">
        <div class="col-xs-12">
            <div class="well" style="margin-top: 25px;">

                <h2 class="PageHeader">
                    <span class="ColoredUnderline GeneralMemucho">Fragen oder Probleme?</span>
                </h2>
                <div class="row">
                    <div class="col-xs-4 col-md-3 TeamPic">
                        <img src="/Images/Team/team_christof_20170404_P3312344_155.jpg" alt="Foto Christof"/>
                    </div>
                    <div class="col-xs-8 col-md-9">
                        <p>
                            Sind noch Fragen offen? Gibt es technische Probleme? Kein Problem, melde dich einfach bei uns, wir helfen dir gerne weiter.
                            Dein Ansprechpartner für alle Fragen zum Widget ist:<br/>
                        </p>
                        <p>
                            <strong>Christof Mauersberger</strong><br/>
                            E-Mail: <span class="mailme">christof at memucho dot de</span><br/>
                            Telefon: 01577-6825707<br/>
                        </p>
                        
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>