﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Sidebar.Master" Inherits="ViewPage<CategoryHistoryDetailModel>" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
    <%= Styles.Render("~/bundles/CategoryHistoryDetail") %>
    <%= Scripts.Render("~/bundles/js/CategoryHistoryDetail") %>
    <%= Scripts.Render("~/bundles/js/diff2html") %>
    <%= Styles.Render("~/bundles/diff2html") %>
    <%--<script src="Js/jquery-2.0.3.js"></script>--%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col-12">
            <h1>Änderungen für '<%= Model.CategoryName %>'</h1>
        </div>
    </div>
    
    <div class="change-detail-model">
        <div class="row">
            <div class="col-xs-3">            
                <a href="<%= Links.UserDetail(Model.CurrentAuthor) %>"><img src="<%= Model.AuthorImageUrl %>" height="20"/></a>
                <b><a href="<%= Links.UserDetail(Model.CurrentAuthor) %>"><%= Model.AuthorName %></a></b><br/>
                vom <%= Model.CurrentDateCreated %> 
            </div>
            
            <div class="col-xs-9">
                <nav class="navbar-right">
                    <a class="btn btn-primary navbar-btn" href="<%= Links.CategoryHistory(Model.CategoryId) %>">
                        <i class="fa fa-chevron-left"></i> Zurück zur Bearbeitungshistorie
                    </a>
                    <% if (new SessionUser().IsLoggedIn && Model.NextRevExists) { %>
                        <a id="restoreButton" class="btn btn-default navbar-btn" onclick="$('#alertConfirmRestore').show();">
                            <i class="fa fa-undo"></i> Wiederherstellen
                        </a>
                    <% } %>
                </nav>
            </div>
        </div>
        
        <% if (new SessionUser().IsLoggedIn && Model.NextRevExists) { %>
            <div id="alertConfirmRestore" class="row" style="display: none">
                <br/>
                <div class="alert alert-warning" role="alert">
                    <div class="col-12">
                        Der aktuelle Stand wird durch diese Version ersetzt. Wollen Sie das wirklich?
                    </div>
                    <br/>
                    <div class="col-12">
                        <nav>
                            <a class="btn btn-default navbar-btn" href="<%= Links.CategoryRestore(Model.CategoryId, Model.CurrentId) %>">
                                <i class="fa fa-undo"></i> Ja, Wiederherstellen
                            </a>
                            <a class="btn btn-primary navbar-btn" onclick="$('#alertConfirmRestore').hide();">
                                <i class="fa fa-remove"></i> Nein, Abbrechen
                            </a>
                        </nav>
                    </div>
                </div>
            </div>
        <% } %>
        
        <div class="row">
            <div class="col-12">
                <% if (!Model.PrevRevisionExists) {  %>
                    <br />
                    <div class="alert alert-info" role="alert">
                        Dies ist die <b>initiale Revision</b> des Themas, weswegen hier keine Änderungen angezeigt werden können.
                    </div>
                <% } else { %>
                    <% if (!Model.NextRevExists) { %>
                        <br />
                        <div class="alert alert-info" role="alert">
                            Dies ist die <b>aktuelle Revision</b> des Themas.
                        </div>
                    <% } else { %>
                        <br />
                    <% } %>
                    <div id="noChangesAlert" class="alert alert-info" role="alert" style="display: none;">
                        Zwischen den beiden Revisionen (vom <%= Model.PrevDateCreated %> und 
                        vom <%= Model.CurrentDateCreated %>) gibt es <b>keine inhaltlichen Unterschiede</b>.
                    </div>
                    <input type="hidden" id="currentName" value="<%= Server.HtmlEncode(Model.CurrentName) %>"/>
                    <input type="hidden" id="prevName" value="<%= Server.HtmlEncode(Model.PrevName) %>"/>
                    <input type="hidden" id="currentMarkdown" value="<%= Server.HtmlEncode(Model.CurrentMarkdown) %>"/>
                    <input type="hidden" id="prevMarkdown" value="<%= Server.HtmlEncode(Model.PrevMarkdown) %>"/>
                    <input type="hidden" id="currentDescription" value="<%= Server.HtmlEncode(Model.CurrentDescription) %>"/>
                    <input type="hidden" id="prevDescription" value="<%= Server.HtmlEncode(Model.PrevDescription) %>"/>
                    <input type="hidden" id="currentWikipediaUrl" value="<%= Server.HtmlEncode(Model.CurrentWikipediaUrl) %>"/>
                    <input type="hidden" id="prevWikipediaUrl" value="<%= Server.HtmlEncode(Model.PrevWikipediaUrl) %>"/>
                    <input type="hidden" id="currentRelations" value="<%= Server.HtmlEncode(Model.CurrentRelations) %>"/>
                    <input type="hidden" id="prevRelations" value="<%= Server.HtmlEncode(Model.PrevRelations) %>"/>
                    <input type="hidden" id="currentDateCreated" value="<%= Model.CurrentDateCreated %>" />
                    <input type="hidden" id="prevDateCreated" value="<%= Model.PrevDateCreated %>" />
                    <div id="diffPanel">
                        <div id="diffName"></div>
                        <div id="diffDescription"></div>
                        <div id="diffWikipediaUrl"></div>
                        <div id="diffData"></div>
                        <div id="diffRelations"></div>
                        <div id="noRelationsAlert" class="alert alert-info" role="alert" style="display: none;">
                            Es können <b>keine Beziehungsdaten</b> angezeigt werden, da für die gewählten Revisionen keine enstsprechenden Daten vorliegen.
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

</asp:Content>
