﻿<%@ Page Title="Frage erstellen" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master"
    Inherits="ViewPage<EditQuestionModel>" %>

<%@ Import Namespace="System.Web.Mvc.Html" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="TrueOrFalse" %>
<asp:Content runat="server" ID="head" ContentPlaceHolderID="Head">
    <script src="/Views/Categories/Edit/RelatedCategories.js" type="text/javascript"></script>
    <link href="/Views/Questions/Edit/EditQuestion.css" rel="stylesheet" />
    <link type="text/css" href="/Content/blue.monday/jplayer.blue.monday.css" rel="stylesheet" />
    <%= Scripts.Render("~/bundles/markdown") %>
    <%= Scripts.Render("~/bundles/questionEdit") %>
    <%= Scripts.Render("~/bundles/fileUploader") %>
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    
<input type="hidden" id="questionId" value="<%= Model.Id %>"/>
    
<div class="col-md-9">
    
    <% using (Html.BeginForm(Model.IsEditing ? "Edit" : "Create", "EditQuestion", null, FormMethod.Post, new { enctype = "multipart/form-data", style="margin:0px;" })){ %>
        <div class="row">
            <div class="col-md-8 pageHeader">
                <h2 class="pull-left"><%=Model.FormTitle %></h2>
            </div>
    
            <div class="col-md-4">
                <div class="pull-right">
                    <div>
                        <a href="<%= Url.Action(Links.Questions, Links.QuestionsController) %>" class="SimpleTextLink" style="font-size: 12px;
                            margin: 0;"><i class="fa fa-list"></i> <span class="TextSpan">zur Übersicht</span></a>
                    </div>
                    <% if (!Model.ShowSaveAndNewButton){ %>
                        <div style="line-height: 12px">
                            <a href="<%= Url.Action(Links.CreateQuestion, Links.EditQuestionController) %>" style="font-size: 12px;
                                margin: 0px;"><i class="fa fa-plus-circle"></i> Frage erstellen</a>
                        </div>
                    <%} %>
                    
                    <% if(Model.IsEditing){ %>
                        <div style="line-height: 12px; padding-top: 3px;">
                            <a href="<%= Links.AnswerQuestion(Url, Model.Question, (int)Model.Id) %>" style="font-size: 12px;
                                margin: 0px;"><i class="fa fa-check-square"></i> Frage beantworten</a>
                        </div>                    
                    <% } %>
                </div>
            </div>
        </div>
        

        <div class="row">
            <div class="col-md-4 col-md-push-8" style="margin-bottom: 11px;">
                <div class="form-horizontal" role="form">
                    <div class="form-group">
                        <%= Html.LabelFor(m => m.Visibility, new { @class = "labelVisibility col-xs-2 xxs-stack control-label" })%>
                    
                        <div class="col-md-12 col-xs-10 xxs-stack">
                            <label style="font-weight: normal">
                                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.All)%>
                                für alle <span class="smaller">(öffentliche Frage)</span> &nbsp;&nbsp;
                            </label>

                            <label style="font-weight: normal">
                                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.Owner)  %>
                                für mich <span class="smaller">(private Frage <i class="fa fa-lock"></i>)</span> &nbsp;&nbsp;
                            </label>

                            <label style="font-weight: normal">
                                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.OwnerAndFriends)  %>
                                für mich und meine Freunde <span class="smaller">(private Frage <i class="fa fa-lock"></i>)</span>
                            </label>
                            <div style="background-color: lavender; padding: 0 10px;">
                                0 von 30 privaten Fragen verwendet.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-8 col-md-pull-4">
                <div class="form-horizontal" role="form">
                <div>
                    <% Html.Message(Model.Message); %>
                </div>
                        
                    <div class="form-group">
                        <%= Html.LabelFor(m => m.Question, new { @class = "col-xs-2 xxs-stack control-label" })%>
                        <div class="col-xs-10 xxs-stack">
                            <%= Html.TextAreaFor(m => m.Question, new { @class="form-control", placeholder = "Bitte gib den Fragetext ein", rows = 4})%>
                            <div style="padding-top: 4px;">
                                <a href="#" id="openExtendedQuestion" class="SimpleTextLink"><i class="fa fa-plus-circle"></i> <span class="TextSpan">Erweiterte Beschreibung (z.B.: mit Bildern, Formeln oder Quelltext)</span></a> 
                            </div>    
                        </div>
                    </div>
                    
                    <div class="form-group markdown" style="display: none" id="extendedQuestion">
                        <%= Html.LabelFor(m => m.QuestionExtended, new { @class = "col-xs-2 xxs-stack control-label" })%>
                        <div class="col-xs-10 xxs-stack">
                            <div class="wmd-panel">
                                <div id="wmd-button-bar-1"></div>
                                <%= Html.TextAreaFor(m => m.QuestionExtended, new 
                                    { @class= "wmd-input form-control", id="wmd-input-1", placeholder = "Erweiterte Beschreibung" })%>
                            </div>                            
                            <div id="wmd-preview-1" class="wmd-panel wmd-preview"></div>
                        </div>
                    </div>

                    <%--
                    <div class="form-group">
                        <% if (!String.IsNullOrEmpty(Model.SoundUrl)){
                                Html.RenderPartial("AudioPlayer", Model.SoundUrl); } %>
                        <label for="soundfile" class="control-label">Ton:</label>
                        &nbsp;&nbsp;<input type="file" name="soundfile" id="soundfile" />
                    </div>--%>

                    <div class="form-group">
                        <%= Html.LabelFor(m => m.SolutionType, new { @class = "col-xs-2 xxs-stack control-label" }) %>
                        <div class="col-xs-4 xxs-stack">
                            <%= Html.DropDownListFor(m => Model.SolutionType, Model.AnswerTypeData, new {@id = "ddlAnswerType", @class="form-control"})%>
                        </div>
                    </div>
                    <div id="question-body">
                    </div>
                    <script type="text/javascript">
                        function updateSolutionBody() {
                            var selectedValue = $("#ddlAnswerType").val();
                            $.ajax({
                                url: '<%=Url.Action("SolutionEditBody", "EditQuestion") %>?questionId=<%:Model.Id %>&type=' + selectedValue,
                                type: 'GET',
                                beforeSend: function () { /* some loading indicator */ },
                                success: function (data) { $("#question-body").html(data); },
                                error: function (data) { /* handle error */ }
                            });
                        }
                        $("#ddlAnswerType").change(updateSolutionBody);
                        updateSolutionBody();
                    </script>
                    
                    
                    <div class="form-group">    
                        <label class="col-xs-2 xxs-stack control-label show-tooltip" title = "Kategorien helfen bei der Einordnung der Frage u. ermöglichen Dir und anderen die Fragen wiederzufinden." data-placement = "left">
                            Kategorien
                        </label>

                        <div id="relatedCategories" class="col-xs-10 xxs-stack">
                            <script type="text/javascript">
                                $(function () {
                                    <%foreach (var category in Model.Categories) { %>
                                        $("#txtNewRelatedCategory").val('<%=category %>');
                                        $("#addRelatedCategory").click();
                                    <% } %>
                                });
                            </script>
                            <input id="txtNewRelatedCategory" class="form-control" style="width: 190px;" type="text" placeholder="Wähle eine Kategorie" />
                            <a href="#" id="addRelatedCategory" style="display: none">
                                <img alt="" src='/Images/Buttons/add.png' />
                            </a>
                        </div>
                    </div>
                    
                    <div class="form-group markdown">
                        <label class="col-xs-2 xxs-stack control-label show-tooltip"  title = "Je ausführlicher die Erklärung, desto besser! Verwende Links u. Bilder aber achte auf die Urheberrechte." data-placement = "left">
                            Erklärungen
                        </label>
                        <div class="col-xs-10 xxs-stack">
                            <div class="wmd-panel">
                                <div id="wmd-button-bar-2"></div>
                                <%= Html.TextAreaFor(m => m.Description, new 
                                    { @class= "form-control wmd-input", id="wmd-input-2", placeholder = "Erklärung der Antwort und Quellen.", rows = 4 })%>
                            </div>
                            <div id="wmd-preview-2" class="wmd-panel wmd-preview"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="col-xs-2 xxs-stack control-label">Quellen</label>
                        <div class="col-xs-3">
                            <input class="form-control col-sm-2" type="text" />
                        </div>
                        <div class="col-xs-3">
                            <select class="form-control ">
                                <option>Wikipedia</option>
                                <option>Webseite</option>
                                <option>Offline: Buch</option>
                                <option>Offline: Zeitung/Zeitschrift</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="col-xs-offset-2  col-xs-10">
                            <%= Html.CheckBoxFor(x => x.ConfirmContentRights) %>
                            Ich stelle diesen Eintrag unter eine LGPL Lizenz. 
                            Der Eintrag kann ohne Einschränkung weiter genutzt werden, 
                            wie zum Beispiel bei Wikipedia-Einträgen. 
                            <a href="" target="_blank">mehr erfahren</a> <br />
                            Die Frage und Anwort ist meine eigene Arbeit und
                            nicht aus urheberichtlich geschützten Quellen kopiert. 
                            <a href="" target="_blank">mehr erfahren</a>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-xs-offset-2 col-xs-10 xxs-stack">
                            <button type="submit" class="btn btn-primary" name="btnSave" value="save">Speichern</button>&nbsp;&nbsp;&nbsp;
                            <% if (Model.ShowSaveAndNewButton){ %>
                                <button type="submit" class="btn btn-default" name="btnSave" value="saveAndNew" >Speichern & Neu</button>&nbsp;
                            <% } %>                        
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <% Html.RenderPartial("../Shared/ImageUpload/ImageUpload"); %>

</asp:Content>