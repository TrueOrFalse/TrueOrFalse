﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="System.Web.Mvc.ViewPage<AnswerQuestionModel>" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="TrueOrFalse" %>
<%@ Import Namespace="TrueOrFalse.Web" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="StackExchange.Profiling" %>

<asp:Content ID="head" ContentPlaceHolderID="Head" runat="server">
    <title>Frage - <%= Model.QuestionText %></title>    
    <link href="/Views/Questions/Answer/AnswerQuestion.css" rel="stylesheet" />
    <%= Scripts.Render("~/bundles/AnswerQuestion") %>

    <style type="text/css">
         .selectorShowAnswer{/* marker class */}
               
        .sparklineTotals{ position: relative;top: 1px; }
        .sparklineTotalsUser{ position: relative;top: 1px; }

        .valRow .valColumn2 .imgDelete{position: relative; left: 10px;top: -3px;  }
        .valRow .valColumn2 .valMine{margin-top: -2px; padding-top: 0;padding-left: 5px; float: left; }
    </style>

    <script type="text/javascript">
        var questionId = "<%= Model.QuestionId %>";
        var qualityAvg = "<%= Model.TotalQualityAvg %>";
        var qualityEntries = "<%= Model.TotalQualityEntries %>";

        var relevancePeronalAvg = "<%= Model.TotalRelevancePersonalAvg %>";
        var relevancePersonalEntries = "<%= Model.TotalRelevancePersonalEntries %>";
        var relevanceForAllAvg = "<%= Model.TotalRelevanceForAllAvg %>";
        var relevanceForAlleEntries = "<%= Model.TotalRelevanceForAllEntries %>";

        var ajaxUrl_SendAnswer = "<%= Model.AjaxUrl_SendAnswer(Url) %>";
        var ajaxUrl_GetAnswer = "<%= Model.AjaxUrl_GetAnswer(Url) %>";
        var ajaxUrl_CountLastAnswerAsCorrect = "<%= Model.AjaxUrl_CountLastAnswerAsCorrect(Url) %>";
    </script>

    <link type="text/css" href="/Content/blue.monday/jplayer.blue.monday.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-lg-9 col-xs-9 xxs-stack">
            <ul id="AnswerQuestionPager" class="pager" style="margin-top: 0;">
                <li class="previous <%= Model.HasPreviousPage ? "" : "disabled" %>">
                    <a href="<%= Model.PreviousUrl(Url) %>"><i class="fa fa-arrow-left"></i></a>
                </li>
                <li>
                    <% if (Model.SourceIsCategory){ %>
                        <a href="<%= Links.CategoryDetail(Model.SourceCategory) %>">
                            Kategorie:
                            <span class="label label-category"><%= Model.SourceCategory.Name %></span>
                        </a>                                    
                    <% } %>
                    <% if (Model.SourceIsSet){ %>
                        <a href="<%= Links.SetDetail(Url, Model.Set) %>">
                            Fragesatz:
                            <span class="label label-set"><%= Model.Set.Name %></span>
                        </a>            
                    <% } %>
                    
                    <% if (Model.SourceIsTabWish || Model.SourceIsTabMine || Model.SourceIsTabAll){ %>
                        <a href="<%= QuestionSearchSpecSession.GetUrl(Model.SearchTabOverview) %>">                        
                            <span >
                                <i class="fa fa-list"></i> 
                                <% if(Model.SourceIsTabWish){ %> mein Wunschwissen <%} %>
                                <% if(Model.SourceIsTabMine){ %> meine Fragen <%} %>
                                <% if(Model.SourceIsTabAll){ %> alle Fragen <%} %>
                            </span>
                        </a>
                    <% } %>                    
                </li>
                <li>
                    <span><%= Model.PageCurrent %> von <%= Model.PagesTotal %></span>
                </li>
                <li class="next">
                    <% if (Model.HasNextPage) { %>
                        <a href="<%= Model.NextUrl(Url) %>"><i class="fa fa-arrow-right"></i> </a>
                    <% } %>
                </li>
            </ul>
        </div>

        <div class="col-xs-3 xxs-stack">
            <% if(Model.IsOwner){ %>
                <div id="EditQuestion">
                    <a href="<%= Links.EditQuestion(Url, Model.QuestionId) %>" class="TextLinkWithIcon">
                        <i class="fa fa-pencil"></i>
                        <span class="TextSpan">Frage bearbeiten</span>
                    </a>
                </div>
            <% } %>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-9 col-xs-9 xxs-stack">
            <div class="well">
                                
                <div style="float: right; margin-left: 10px;">
                    <a href="#" class="noTextdecoration" style="font-size: 22px; height: 10px;">
                        <i class="fa fa-heart show-tooltip <%= Model.IsInWishknowledge ? "" : "hide2" %>" id="iAdded" style="color:#b13a48;" title="Aus deinem Wunschwissen entfernen"></i>
                        <i class="fa fa-heart-o show-tooltip <%= Model.IsInWishknowledge ? "hide2" : "" %>" id="iAddedNot" style="color:#b13a48;" title="Zu deinem Wunschwissen hinzuzufügen"></i>
                        <i class="fa fa-spinner fa-spin hide2" id="iAddSpinner" style="color:#b13a48;"></i>
                    </a>
                </div>    
                <span style="font-size: 22px; padding-bottom: 20px;">
                    <%= Model.QuestionText %>
                </span>
                
                <p><%= Model.QuestionTextMarkdown %></p>
            
                <% if (Model.HasSound){ Html.RenderPartial("AudioPlayer", Model.SoundUrl); } %>
        
                <div class="alert alert-info" id="divWrongAnswer" style="display: none; background-color: white; color:#2E487B;">
                    <span id="spnWrongAnswer" style="color: #B13A48"><b>Falsche Antwort </b></span>
                    <a href="#" id="CountWrongAnswers" style="float: right; margin-right: -5px;">(zwei Versuche)</a><br/>
                
                    <div style="margin-top:5px;" id="answerFeedback">Du könntest es wenigstens probieren!</div>
                
                    <div style="margin-top:7px; display: none;" id="divWrongAnswers" >
                        <span class="WrongAnswersHeading">Deine bisherigen Antwortversuche:</span>
                        <ul style="padding-top:5px;" id="ulAnswerHistory">
                        </ul>
                    </div>
                </div>
        
                <div id="AnswerInputSection">
                    <input type="hidden" id="hddSolutionMetaDataJson" value="<%: Model.SolutionMetaDataJson %>"/>
                    <%
                        string userControl = "SolutionType" + Model.SolutionType + ".ascx";
                        if (Model.SolutionMetadata.IsDate)
                            userControl = "SolutionTypeDate.ascx";
                        
                        Html.RenderPartial("~/Views/Questions/Answer/AnswerControls/" + userControl, Model.SolutionModel); 
                    %>
                </div>
                
                <div id="SolutionDetailsSpinner" style="display: none;">
                    <i class="fa fa-spinner fa-spin" style="color:#b13a48;"></i>
                </div>
                <div id="SolutionDetails" class="alert alert-info" style="display: none; background-color: white; color:#2E487B;">
                    
                     <div class="" id="divAnsweredCorrect" style="display: none; margin-top:5px;">
                        <b style="color: green;">Richtig!</b> <span id="wellDoneMsg"></span>
                    </div>

                    <div id="Solution" class="Detail" style="display: none;">
                        <div class="Label">Richtige Antwort:</div>
                        <div class="Content"></div>
                    </div>
                    <div id="Description" class="Detail" style="display: none;">
                        <div class="Label">Ergänzungen:</div>
                        <div class="Content"></div>
                    </div>
                     <div id="References" class="Detail" style="display: none;">
                        <div class="Label">Quellen:</div>
                        <div class="Content"></div>
                    </div>
                </div>
            
                <div id="Buttons" style="margin-bottom: 10px; margin-top: 10px;">
                    <%--<%= Buttons.Submit("Überspringen", inline:true)%>--%>
                    <div id="buttons-first-try" class="pull-right">
                        <a href="#" class="selectorShowAnswer btn btn-info">Antwort anzeigen</a>
                        <a href="#" id="btnCheck" class="btn btn-primary" style="padding-right: 10px">Antworten</a>
                    </div>
                    
                    <div id="buttons-next-answer" class="pull-right" style="display: none;">
                        <a href="#" id="btnCountAsCorrect" class="btn btn-info show-tooltip" title="Drücke hier und deine letzte Antwort wird als richtig gewertet (bei anderer Schreibweise, Formulierung ect). Aber nicht schummeln!" style="display: none;">Hab ich gewusst!</a>
                        <a href="<%= Model.NextUrl(Url) %>" id="btnNext" class="btn btn-success pull-right">N&auml;chste Frage</a>
                    </div>

                    <div id="buttons-edit-answer" class="pull-right" style="display: none;">
                        <a href="#" class="selectorShowAnswer btn btn-info">Antwort anzeigen</a>
                        <a href="#" id="btnEditAnswer" class="btn btn-warning">Antwort &Uuml;berarbeiten</a>
                    </div>
                    <div id="buttons-answer-again" class="pull-right" style="display: none">
                        <a href="#" class="selectorShowAnswer btn btn-info">Antwort anzeigen</a>
                        <a href="#" id="btnCheckAgain" class="btn btn-warning pull-right">Nochmal Antworten</a>
                    </div>
                    
                    <div style="clear: both"></div>
                </div>
            </div>
            
            <div style="margin-top: 30px; color: darkgray; font-weight: bold;" class="row">

                <div class="col-xs-4">
                    <h4 style="padding:0; margin:0;">Kommentare</h4>    
                </div>
                
                <div class="col-xs-8 " style="vertical-align: text-bottom; 
                      vertical-align: bottom; margin-top: 3px; text-align: right">
                    <% if(Model.IsLoggedIn){ %>
                        <span style="padding-right: 2px">
                            Die Frage bitte: &nbsp;
                            <a href="#modalImprove" data-toggle="modal"><i class="fa fa-repeat"></i> verbessern!</a>&nbsp; / 
                            <a href="#modalDelete" data-toggle="modal"><i class="fa fa-fire"></i> entfernen!</a>
                        </span>
                    <% } %>
                </div>
            </div>  
            
            <div id="comments">
                <% foreach(var comment in Model.Comments){ %>
                    <% Html.RenderPartial("~/Views/Questions/Answer/Comments/Comment.ascx", comment); %>
                <% } %>
            </div>
                        
            <% if(Model.IsLoggedIn){ %>
                <div class="panel panel-default" style="margin-top: 7px;">
                    <div class="panel-heading">Neuen Kommentar hinzufügen</div>
                    <div class="panel-body">
                        <div class="col-xs-2">
                            <img style="width:100%; border-radius:5px;" src="<%= Model.ImageUrlAddComment %>">
                        </div>
                        <div class="col-xs-10">
                            <i class="fa fa-spinner fa-spin hide2" id="saveCommentSpinner"></i>
                            <textarea style="width: 100%; min-height: 82px;" class="form-control" id="txtNewComment" placeholder="Bitte höflich, freundlich und sachlich schreiben :-)"></textarea>
                        </div>
                    
                        <div class="col-xs-12" style="padding-top: 7px;">
                            <a href="#" class="btn btn-default pull-right" id="btnSaveComment">Speichern</a>
                        </div>
                    </div>                
                </div>
            <% } else { %>
                <div class="row">
                    <div class="col-xs-12" style="padding-top: 10px; color: darkgray">
                        Um zu kommentieren, musst du angemeldet sein.
                    </div>                     
                </div>
            <% } %>

        </div>
        
        <div class="col-xs-3 well" style="background-color: white;">
            
            <p>
                von: <a href="<%= Links.UserDetail(Url, Model.Creator) %>"><%= Model.CreatorName %></a><%= Model.Visibility != QuestionVisibility.All ? " <i class='fa fa-lock show-tooltip' title='Private Frage'></i>" : "" %><br />
                vor <a href="#" class="show-tooltip" title="erstellt am <%= Model.CreationDate %>" ><%= Model.CreationDateNiceText%></a> <br />
            </p>
        
            <% if(Model.Categories.Count > 0){ %>
                <p style="padding-top: 10px;">
                    <% foreach (var category in Model.Categories){ %>
                        <a href="<%= Links.CategoryDetail(category) %>"><span class="label label-category" style="margin-top: 3px;"><%= category.Name %></span></a>    
                    <% } %>
                </p>
            <% } %>
        
            <% if(Model.SetMinis.Count > 0){ %>
                <% foreach (var setMini in Model.SetMinis){ %>
                    <a href="<%= Links.SetDetail(Url, setMini) %>" style="margin-top: 3px; display: inline-block;"><span class="label label-set"><%: setMini.Name %></span></a>
                <% } %>
        
                <% if (Model.SetCount > 5){ %>
                    <div style="margin-top: 3px;">
                        <a href="#" popover-all-sets-for="<%= Model.QuestionId %>">+  <%= Model.SetCount -5 %> weitere </a>
                    </div>
                <% } %>

            <% } %>
    
            <div style="padding-top: 20px; padding-bottom: 20px;" id="answerHistory">
                <% Html.RenderPartial("HistoryAndProbability", Model.HistoryAndProbability); %>
            </div>
        
            <p>
                <span class="show-tooltip" title="Die Frage wurde <%= Model.TotalRelevancePersonalEntries %>x zum Wunschwissen hinzugefügt.">
                    <i class="fa fa-heart" style="color:silver;"></i> 
                    <span id="sideWishKnowledgeCount"><%= Model.TotalRelevancePersonalEntries %>x</span><br />
                </span>                
                <span class="show-tooltip" title="Die Frage wurde <%= Model.TotalViews %>x mal gesehen.">
                    <i class="fa fa-eye" style="color:darkslategray;"></i> <%= Model.TotalViews %>x
                </span><br />
            </p>

            <p style="width: 150px;">
                <div class="fb-like" data-send="false" data-layout="button_count" data-width="100" data-show-faces="false" data-action="recommend" data-font="arial"></div>
            </p>
        </div>
    
        <%--MODAL IMPROVE--%>
        <div id="modalImprove" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button class="close" data-dismiss="modal">×</button>
                        <h3>Diese Frage verbessern</h3>
                    </div>
                    <div class="modal-body">
                        <div >
                            <p>
                                Ich bitte darum, dass diese Frage verbessert wird weil: 
                            </p>
                            <ul style="list-style-type: none">
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbImprove" value="shouldBePrivate"/> 
                                            <%= ShouldReasons.ByKey("shouldBePrivate") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbImprove" value="sourcesAreWrong"/> 
                                            <%= ShouldReasons.ByKey("sourcesAreWrong") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbImprove" value="answerNotClear"/> 
                                            <%= ShouldReasons.ByKey("answerNotClear") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbImprove" value="improveOtherReason"/>
                                            <%= ShouldReasons.ByKey("improveOtherReason") %>
                                        </label>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <p style="padding-top: 10px;">
                            Erläuterung zum Verbesserungsvorschlag:
                        </p>
                        <textarea style="width: 500px;" rows="3" id="txtImproveBecause"></textarea>
                        <p style="padding-top: 15px;">
                            Die Verbesserungsanfrage wird als Kommentar veröffentlicht und 
                            als Nachricht an <%= Model.CreatorName %> gesendet.
                        </p>
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn" data-dismiss="modal">Schliessen</a>
                        <a href="#" class="btn btn-primary btn-success" id="btnImprove">Absenden</a>
                    </div>
                </div>
            </div>
        </div>
    
        <%--MODAL DELETE--%>
        <div id="modalDelete" class="modal fade">
             <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button class="close" data-dismiss="modal">×</button>
                        <h3>Diese Frage bitte löschen</h3>
                    </div>
                    <div class="modal-body">
                        <div >
                            <p>
                                Ich bitte darum, dass diese Frage gelöscht wird weil: 
                            </p>
                            <ul style="list-style-type: none">
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbDelete" value="deleteIsOffending"/>
                                            <%= ShouldReasons.ByKey("deleteIsOffending") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbDelete" value="deleteIsOffending"/>
                                            <%= ShouldReasons.ByKey("deleteCopyright") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbDelete" value="deleteIsSpam"/>
                                            <%= ShouldReasons.ByKey("deleteIsSpam") %>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="ckbDelete" value="deleteIsSpam"/>
                                            <%= ShouldReasons.ByKey("deleteOther") %>
                                        </label>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <p>
                            Weiter Erläuterung (optional).
                        </p>
                        <textarea style="width: 500px;" rows="3" id="txtDeleteBecause"></textarea>
            
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-default" data-dismiss="modal" id="A1">Schliessen</a>
                        <a href="#" class="btn btn-primary btn-danger" id="btnShouldDelete">Absenden</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>