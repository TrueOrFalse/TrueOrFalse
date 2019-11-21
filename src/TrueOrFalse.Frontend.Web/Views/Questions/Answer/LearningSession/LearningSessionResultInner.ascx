﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<LearningSessionResultModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<%--    <% if (Model.IsLoggedIn)
        Html.RenderPartial("~/Views/Api/ActivityPoints/ActivityLevelProgress.aspx", new ActivityLevelProgressModel(Sl.SessionUser.User)); %>--%>

<link href="/Views/Questions/Answer/LearningSession/LearningSessionResult.css" rel="stylesheet" />

<input type="hidden" id="hddSolutionTypeNum" value="1" />
<input type="hidden" id="hddCategoryId" value="682" />

<h2 style="margin-bottom: 15px; margin-top: 0px;">
    <span class="<% if (Model.LearningSession.IsDateSession) Response.Write("ColoredUnderline Date");
                    if (Model.LearningSession.IsSetSession) Response.Write("ColoredUnderline Set");
                    if (Model.LearningSession.IsSetsSession) Response.Write("ColoredUnderline Set");
                    if (Model.LearningSession.IsWishSession) Response.Write("ColoredUnderline Knowledge");
                 %>">Ergebnis</span>
</h2>
    

<div class="row">
    <div class="col-sm-9 xxs-stack" id="ResultMainColumn">
        <div class="stackedBarChartContainer"             
             <% if (!Model.ShowSummaryText){ %>
             style="margin-bottom: 0;"
             <% } %>>
            <% if (Model.NumberCorrectPercentage>0) {%>
                <div class="stackedBarChart chartCorrectAnswer" style="width: <%=Model.NumberCorrectPercentage %>%;">
                    <%=Model.NumberCorrectPercentage %>% 
                </div>
            <% } %>                
            <% if (Model.NumberCorrectAfterRepetitionPercentage>0) {%>
                <div class="stackedBarChart chartCorrectAfterRepetitionAnswer" style="width: <%=Model.NumberCorrectAfterRepetitionPercentage %>%;">
                    <%=Model.NumberCorrectAfterRepetitionPercentage %>% 
                </div>
            <% } %>                
            <% if (Model.NumberWrongAnswersPercentage>0) {%>
                <div class="stackedBarChart chartWrongAnswer" style="width: <%=Model.NumberWrongAnswersPercentage %>%;">
                    <%=Model.NumberWrongAnswersPercentage %>% 
                </div>
            <% } %>                
            <% if (Model.NumberNotAnsweredPercentage>0) {%>
                <div class="stackedBarChart chartNotAnswered" style="width: <%=Model.NumberNotAnsweredPercentage %>%;">
                    <%=Model.NumberNotAnsweredPercentage %>% 
                </div>
            <% } %>                
        </div>
        
        <% if (Model.ShowSummaryText) {%>
        <div class="SummaryText" style="clear: left;">
            <p style="margin-bottom: 20px;">In dieser Lernsitzung hast du <%= Model.NumberUniqueQuestions %> Fragen gelernt und dabei</p>
            <div class="row">
                <div class="col-xs-12">
                    <div class="row">
                        <div class="col-xs-2 col-sm-offset-1 sumPctCol"><div class="sumPct sumPctRight"><span class="sumPctSpan"><%=Model.NumberCorrectPercentage %>%</span></div></div>
                        <div class="col-xs-10 col-sm-9 sumExpl">beim 1. Versuch gewusst (<%=Model.NumberCorrectAnswers %> Fragen)</div>
                    </div>
                    <div class="row">
                        <div class="col-xs-2 col-sm-offset-1 sumPctCol"><div class="sumPct sumPctRightAfterRep"><span class="sumPctSpan"><%=Model.NumberCorrectAfterRepetitionPercentage %>%</span></div></div>
                        <div class="col-xs-10 col-sm-9 sumExpl">beim 2. oder 3. Versuch gewusst (<%=Model.NumberCorrectAfterRepetitionAnswers %> Fragen)</div>
                    </div>
                    <div class="row">
                        <div class="col-xs-2 col-sm-offset-1 sumPctCol"><div class="sumPct sumPctWrong"><span class="sumPctSpan"><%=Model.NumberWrongAnswersPercentage %>%</span></div></div>
                        <div class="col-xs-10 col-sm-9 sumExpl">nicht gewusst (<%=Model.NumberWrongAnswers %> Fragen)</div>
                    </div>
                    <div class="row">
                        <div class="col-xs-2 col-sm-offset-1 sumPctCol"><div class="sumPct sumPctNotAnswered"><span class="sumPctSpan"><%=Model.NumberNotAnsweredPercentage %>%</span></div></div>
                        <div class="col-xs-10 col-sm-9 sumExpl">nicht beantwortet (<%=Model.NumberNotAnswered %> Fragen)</div>
                    </div>
                </div>
            </div>
        </div>
        <% } else {
               var tooltip = string.Format("Der Durchschnitt aller Nutzer beantwortete {0}% richtig", Model.PercentageAverageRightAnswers); %>
        <div id="divIndicatorAverageWrapper" style="width: 100%">
            <div id="divIndicatorAverage" style="margin-left: <%= Model.PercentageAverageRightAnswers %>%">
                <i class="fa fa-caret-up fa-4x show-tooltip" style="margin-left: -16px;" title="<%= tooltip %>"></i>
            </div>
            <div id="divIndicatorAverageText">
                <p class="show-tooltip" title="<%= tooltip %>">
                    Nutzerdurchschnitt (<span id="avgPercentageCorrect"><%= Model.PercentageAverageRightAnswers %></span>% richtig)
                </p>
            </div>
        </div>
        
        <% }%> 


        
        <div class="buttonRow">
            <% if (Model.LearningSession.IsSetSession) { %>
                <a href="<%= Links.SetDetail(Url, Model.LearningSession.SetToLearn) %>" class="btn btn-link" style="padding-right: 10px">Zum Lernset (Übersicht)</a>
                <a href="<%= Links.StartLearningSession(Model.LearningSession) %>" class="btn btn-primary" style="padding-right: 10px">
                    Weiterlernen
                </a>
            <% } else if (Model.LearningSession.IsSetsSession) { %>
                <a href="<%= Links.StartLearningSession(Model.LearningSession) %>" class="btn btn-primary" style="padding-right: 10px">
                    Weiterlernen
                </a>
            <% } else if (Model.LearningSession.IsCategorySession) { %>
                <a href="<%= Links.CategoryDetail(Model.LearningSession.CategoryToLearn.Name, Model.LearningSession.CategoryToLearn.Id) %>" class="btn btn-link " style="padding-right: 10px">Zum Thema</a>
                <a href="<%= Links.StartLearningSession(Model.LearningSession) %>" class="btn btn-primary nextLearningTestSession" style="padding-right: 10px">
                    Weiterlernen
                </a>   
            <% } else if (Model.LearningSession.IsWishSession) { %>
                <a href="<%= Links.Knowledge() %>" class="btn btn-link" style="padding-right: 10px">Zur Wissenszentrale</a>
                <a href="<%= Links.StartWishLearningSession() %>" class="btn btn-primary" style="padding-right: 10px">
                    Neue Lernsitzung
                </a>
            <% } else {
                throw new Exception("buttons for this type of learning session not specified");
            } %>
        </div>
            
        <div id="detailedAnswerAnalysis">
            <h3 style="margin-bottom: 25px;">Auswertung deiner Antworten</h3>
            <p class="greyed fontSizeSmall">
                <a href="#" data-action="showAllDetails">Alle Details einblenden</a> | <a href="#" data-action="hideAllDetails">Alle Details ausblenden</a> | <a href="#" data-action="showDetailsExceptRightAnswer">Details zu allen nicht korrekten Fragen einblenden</a>
            </p>
            <% foreach (var uniqueQuestion in Model.AnsweredStepsGrouped)
                {
                    if ((uniqueQuestion.First().AnswerState == StepAnswerState.Answered) && uniqueQuestion.First().AnsweredCorrectly)
                    { %> 
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="QuestionLearned AnsweredRight">
                                    <a href="#" data-action="showAnswerDetails">
                                    <i class="fa fa-check-circle AnswerResultIcon show-tooltip" title="Beim 1. Versuch richtig beantwortet">
                                        &nbsp;&nbsp;
                                    </i><%= uniqueQuestion.First().Question.GetShortTitle(150) %> 
                                    (Details)</a><br/>
                    <% }
                    else if ((uniqueQuestion.Count() > 1) && (uniqueQuestion.Last().AnswerState == StepAnswerState.Answered) && uniqueQuestion.Last().AnsweredCorrectly)
                    { %> 
                        <div class="row">
                            <div class="col-xs-12">
                                    <a href="#" data-action="showAnswerDetails">
                                <div class="QuestionLearned AnsweredRightAfterRepetition">
                                    <i class="fa fa-check-circle AnswerResultIcon show-tooltip" title="Beim 2. oder 3. Versuch richtig beantwortet">
                                        &nbsp;&nbsp;
                                    </i><%= uniqueQuestion.First().Question.GetShortTitle(150) %> 
                                    (Details)</a><br/>

                    <% }
                    else if (uniqueQuestion.All(a => a.AnswerState != StepAnswerState.Answered))
                    { %> 
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="QuestionLearned Unanswered">
                                    <a href="#" data-action="showAnswerDetails">
                                    <i class="fa fa-circle AnswerResultIcon show-tooltip" title="Nicht beantwortet">
                                        &nbsp;&nbsp;
                                    </i><%= uniqueQuestion.First().Question.GetShortTitle(150) %> 
                                    (Details)</a><br/>
                    <% }
                    else if (((uniqueQuestion.Last().AnswerState == StepAnswerState.Answered) && (uniqueQuestion.Last().AnswerCorrectness == AnswerCorrectness.False)) ||
                                ((uniqueQuestion.Last().AnswerState != StepAnswerState.Answered) && (uniqueQuestion.Count() > 1)))
                    { %>
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="QuestionLearned AnsweredWrong">
                                    <a href="#" data-action="showAnswerDetails">
                                    <i class="fa fa-minus-circle AnswerResultIcon show-tooltip" title="Falsch beantwortet">
                                        &nbsp;&nbsp;
                                    </i><%= uniqueQuestion.First().Question.GetShortTitle(150) %> 
                                    (Details)</a><br/>
                    <% }
                    else { // fall-back-option, prevents layout bugs (missing opened divs) in case some answer-case isn't dealt with above  %>
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="QuestionLearned">
                                    <a href="#" data-action="showAnswerDetails">
                                        <i class="fa fa-question-circle AnswerResultIcon show-tooltip" title="Status unbekannt (Fehler)">
                                            &nbsp;&nbsp;
                                        </i><%= uniqueQuestion.First().Question.GetShortTitle(150) %> 
                                        (Details)</a><br/>
                             
                    <% }%>
                                    <div class="answerDetails" data-questionId=<%= uniqueQuestion.First().QuestionId %>>
                                        <div class="row">
                                            <div class="col-xs-3 col-sm-2 answerDetailImage">
                                                <div class="ImageContainer ShortLicenseLinkText">
                                                <%= GetQuestionImageFrontendData.Run(uniqueQuestion.First().Question).RenderHtmlImageBasis(128, true, ImageType.Question, linkToItem: Links.AnswerQuestion(uniqueQuestion.First().Question)) %> 
                                                </div>
                                            </div>
                                            <div class="col-xs-9 col-sm-10">
                                                <p class="rightAnswer">Richtige Antwort: <%= GetQuestionSolution.Run(uniqueQuestion.First().Question).GetCorrectAnswerAsHtml() %><br/></p>
                                                <% int counter = 1;
                                                foreach (var step in uniqueQuestion)
                                                {
                                                    if (step.AnswerState == StepAnswerState.NotViewedOrAborted)
                                                    {
                                                        %> <p class="answerTry">Dein <%= counter %>. Versuch: (abgebrochen)</p><%
                                                    }
                                                    else if (step.AnswerState == StepAnswerState.Skipped)
                                                    {
                                                        %> <p class="answerTry">Dein <%= counter %>. Versuch: (übersprungen)</p><%
                                                    }
                                                    else if (step.AnswerState == StepAnswerState.Uncompleted)
                                                    {
                                                        %> <p class="answerTry">Dein <%= counter %>. Versuch: (noch nicht gesehen)</p><%
                                                    }
                                                    else if (step.AnswerState == StepAnswerState.ShowedSolutionOnly)
                                                    {
                                                        %> <p class="answerTry">Dein <%= counter %>. Versuch: (Lösung angezeigt)</p><%
                                                    }
                                                    else
                                                    {
                                                        %> <p class="answerTry">Dein <%= counter %>. Versuch: <%= Question.AnswersAsHtml(step.AnswerWithInput.AnswerText, step.Question.SolutionType) %></p><%
                                                    }
                                                    counter++;
                                                } %>
                                                <p class="answerLinkToQ"><a href="<%= Links.AnswerQuestion(uniqueQuestion.First().Question) %>"><i class="fa fa-arrow-right">&nbsp;</i>Diese Frage einzeln lernen</a></p>
                                                    
                                            </div>
                                                
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                <% } %>
        </div>
    </div>


    <div id="ResultSideColumn" class="col-sm-3 xxs-stack">
        <% if(Model.LearningSession.IsSetSession) { %>
            <div class="boxInfo">
                <div class="boxInfoHeader">
                    Lernset-Info
                </div>
                <div class="boxInfoContent">
                    <p>
                        Du hast dieses Lernset gelernt:<br />
                        <a href="<%= Links.SetDetail(Url, Model.LearningSession.SetToLearn) %>" style="display: inline-block;">
                            <span class="label label-set"><%: Model.LearningSession.SetToLearn.Name %></span>
                        </a> (insgesamt <%=Model.LearningSession.TotalPossibleQuestions %> Fragen)
                    </p>
                </div>
            </div>
        <% } %>

        <% if(Model.LearningSession.IsSetsSession) { %>
            <div class="boxInfo">
                <div class="boxInfoHeader">
                    <%= Model.LearningSession.SetListTitle %>
                </div>
                <div class="boxInfoContent">
                    <p>
                        Du hast diese Lernsets gelernt:
                    </p>
                    <div class="LabelList">
                        <% foreach (var set in Model.SetsToLearn) { %>
                            <div class="LabelItem LabelItem-Set">
                                <a href="<%= Links.SetDetail(Url, set) %>" style="display: inline-block;">
                                    <span class=""><%: set.Name %></span>
                                </a> (<%= set.Questions().Count %> Fragen)
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>

        <% if(Model.LearningSession.IsWishSession) { %>
            <div class="boxInfo">
                <div class="boxInfoHeader">
                    Wunschwissen
                </div>
                <div class="boxInfoContent">
                    <p>
                        Du hast dein Wunschwissen gelernt. Dein Wunschwissen enthält
                    </p>
                    <ul>
                        <li><a href="<%= Links.QuestionsWish() %>"><%= Model.WishCountQuestions %> Fragen</a></li>
                        <li><a href="<%= Links.SetsWish() %>"><%= Model.WishCountSets %> Lernset<%= StringUtils.PluralSuffix(Model.WishCountSets,"s") %></a></li>
                    </ul>
                </div>
            </div>
        <% } %>
            
        <% if(Model.LearningSession.IsCategorySession) { %>
            <div class="boxInfo">
                <div class="boxInfoHeader">
                    Thema
                </div>
                <div class="boxInfoContent">
                    <p>
                        Du hast dieses Thema gelernt:<br />
                        <a href="<%= Links.CategoryDetail(Model.LearningSession.CategoryToLearn.Name, Model.LearningSession.CategoryToLearn.Id) %>" style="display: inline-block;">
                            <span class="label label-category"><%: Model.LearningSession.CategoryToLearn.Name %></span>
                        </a> (insgesamt <%=Model.LearningSession.TotalPossibleQuestions %> Fragen)
                    </p>
                </div>
            </div>

        <% } %>
    </div>
</div>

                                                            
