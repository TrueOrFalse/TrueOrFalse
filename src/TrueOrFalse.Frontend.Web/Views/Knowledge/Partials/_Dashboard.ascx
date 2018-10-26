﻿<%@ Language="C#" Inherits="System.Web.Mvc.ViewUserControl<KnowledgeModel>"%>

<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%= Styles.Render("~/bundles/_dashboard") %>

<script>
    $(function () {
        $("#inCategoeryOverTime-1").sparkline([1, 4, 4, 2, 1, 8, 7, 9], { type: 'line', sliceColors: ['#3e7700', '#B13A48'] });
        $("#question-1").sparkline([5, 5], { type: 'pie', sliceColors: ['#90EE90', '#FFA07A'] });
        $("#inCategory-1").sparkline([5, 5], { type: 'pie', sliceColors: ['#90EE90', '#FFA07A'] });
    });
</script>
     <script>
       
         if (isGoogleApiInitialized)
             Initialize();
         else
             google.setOnLoadCallback(Initialize);

         function Initialize() {
             drawKnowledgeChart("chartKnowledgeP");
             drawActivityChart();
             <% for (var i = 0; i < Model.Dates.Count; i++){ %>
 
                 drawKnowledgeChartDate("chartKnowledgeDate" + <%= (i+1) %>,
                     <%= Model.DateRowModelList[i].KnowledgeSolid %>,
                     <%= Model.DateRowModelList[i].KnowledgeNeedsConsolidation %>,
                     <%= Model.DateRowModelList[i].KnowledgeNeedsLearning %>,
                     <%= Model.DateRowModelList[i].KnowledgeNotLearned %>);
            <%}%>
         }


         function drawKnowledgeChart(chartElementId) {
             if ($("#" + chartElementId).length === 0) {
                 return;
             }

             var data = google.visualization.arrayToDataTable([
                 ['Wissenslevel', 'link', 'Anteil in %'],
                 ['Sicheres Wissen', '/Fragen/Wunschwissen/?filter=solid', <%= Model.KnowledgeSummary.Solid %>],
                 ['Solltest du festigen', '/Fragen/Wunschwissen/?filter=consolidate', <%= Model.KnowledgeSummary.NeedsConsolidation %>],
                 ['Solltest du lernen', '/Fragen/Wunschwissen/?filter=learn', <%= Model.KnowledgeSummary.NeedsLearning %>],
                 ['Noch nicht gelernt', '/Fragen/Wunschwissen/?filter=notLearned', <%= Model.KnowledgeSummary.NotLearned %>],
             ]);

             var options = {
                 pieHole: 0.6,
                 tooltip: { isHtml: true },
                 legend: { position: 'labeled' },
                 pieSliceText: 'none',
                 chartArea: { 'width': '100%', height: '100%', top: 10 },
                 slices: {
                     0: { color: '#afd534' },
                     1: { color: '#fdd648' },
                     2: { color: 'lightsalmon' },
                     3: { color: 'silver' }
                 },
                 pieStartAngle: 0
             };

             var view = new google.visualization.DataView(data);
             view.setColumns([0, 2]);

             var chart = new google.visualization.PieChart(document.getElementById(chartElementId));
             chart.draw(view, options);

             google.visualization.events.addListener(chart, 'select', selectHandler);

             function selectHandler(e) {
                 var urlPart = data.getValue(chart.getSelection()[0].row, 1);
                 location.href = urlPart;
             }
         }

         function drawKnowledgeChartDate(chartElementId, amountSolid, amountToConsolidate, amountToLearn, amountNotLearned) {

             var chartElement = $("#" + chartElementId);

             var data = google.visualization.arrayToDataTable([
                 ['Wissenslevel', 'Anteil in %'],
                 ['Sicheres Wissen', amountSolid],
                 ['Solltest du festigen', amountToConsolidate],
                 ['Solltest du lernen', amountToLearn],
                 ['Noch nicht gelernt', amountNotLearned],
             ]);

             var options = {
                 pieHole: 0.5,
                 legend: { position: 'none' },
                 pieSliceText: 'none',
                 height: 80,
                 chartArea: { width: '100%', height: '100%', top: 10 },
                 slices: {
                     0: { color: '#afd534' },
                     1: { color: '#FFD603' },
                     2: { color: '#FF001F' },
                     3: { color: 'silver' }
                 },
                 pieStartAngle: 0
             };

             var chart = new google.visualization.PieChart(chartElement.get()[0]);
             chart.draw(data, options);
         }

         function drawActivityChart() {
             var data = google.visualization.arrayToDataTable([
                 [
                     'Datum', 'Richtig beantwortet', 'Falsch beantwortet', { role: 'annotation' }
                 ],
                 <% foreach (var stats in Model.Last30Days)
         { %>
                 <%= "['" + stats.DateTime.ToString("dd.MM") + "', " + stats.TotalTrueAnswers + ", "+ stats.TotalFalseAnswers +", '']," %> 
                 <% } %>
             ]);

             var view = new google.visualization.DataView(data);
             view.setColumns([0, 1,
                 {
                     calc: "stringify",
                     sourceColumn: 1,
                     type: "string",
                     role: "annotation"
                 },
                 2]);

             var options = {
                 legend: { position: 'top', maxLines: 30 },
                 tooltip: { isHtml: true },
                 bar: { groupWidth: '89%' },
                 chartArea: { 'width': '98%', 'height': '60%', top: 30, bottom: -10 },
                 colors: ['#afd534', 'lightsalmon'],
                 isStacked: true
             };

             
             <% if (!Model.HasLearnedInLast30Days)
         { %>
             var infoDivNotLearned = document.createElement('div');
             infoDivNotLearned.setAttribute('style', ' margin-top: 50px; left: 20px; right: 20px; height: 150px; padding-top: 40px');
             infoDivNotLearned.setAttribute('class', 'alert alert-info');
             infoDivNotLearned.innerHTML = '<p>Du hast in den letzten 30 Tagen keine Fragen beantwortet, daher kann hier keine Übersicht angezeigt werden.</p>';
             document.getElementById("chartActivityLastDays").appendChild(infoDivNotLearned);
             <% }
                else
                {%>
                    var chart = new google.visualization.ColumnChart(document.getElementById("chartActivityLastDays"));
                    chart.draw(view, options);
               <% } %>

         }
     </script>
<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans" />
<input type="hidden" id="hddCountDates" value="<%=Model.Dates.Count %>"/>
<input type="hidden" id="hddUserId" value="<%=Model.UserId %>"/>


<div class="container-fluid">
    <div class="row first-row">
        <div class="col-xs-3 " >
            <h3>Dein Wissenstand</h3>
            <div id="chartKnowledgeP" ></div>
        </div>
        <!-- Dein Training -->
        <div class ="col-xs-5">
            <h3> Dein Training</h3>
            <div id="chartActivityLastDays"></div>
        </div>
        <div class="col-xs-4">
            <h3> Dein Wunschwissen</h3>
            <div><i class="bold"><%=Model.TopicCount %></i> Themen <i class="bold"><%=Model.User.WishCountSets %></i> Lernsets <i class="bold"><%=Model.User.WishCountQuestions %></i> Fragen</div> 
        </div>
    </div>
    <div class="row second-row">
        <div class="col-xs-3">
            <span>
                <h3>Deine Reputation</h3>
                <p>
                    <a href="<%= Links.UserDetail(Model.User) %>">Details auf deiner Profilseite</a>
                </p>
                <p>
                    <b class="reputation-number"><%= Model.TopicCreatedCount %></b><span>erstellte Themen</span><br/>
                    <b class="reputation-number"><%= Model.SetsCreatedCount %></b><span>erstellte Lernsets</span><br/>
                    <b class="reputation-number"><%= Model.QuestionsCreatedCount %></b><span>erstellte Fragen</span> <br/>
                    <h3 id="rang">Rang <%=Model.ReputationRank %></h3>
                    <b>(<%= Model.ReputationTotal %> ReputationsPunkte)</b>
                    </p>
             <%--   <p>
                    <i class="fa fa-question-circle show-tooltip" data-original-title="Reputationspunkte erhältst du, wenn du gute Lerninhalte erstellst und andere damit lernen."></i>
                    <br/>
                </p>--%>
            </span>
        </div>
        
        <div class="col-xs-5">
            <h3 >Dein erreichtes Level</h3>
            <div  class="learn-points">
                <span class="level-display">
                    <span style="display: inline-block; white-space: nowrap;">
                        <svg class="">
                            <circle cx="50%" cy="50%" r="50%" />
                            <text class="level-count" x="50%" y="50%" dy = ".34em" ><%= Model.ActivityLevel %></text>
                        </svg>
                    </span>
                </span>
                <p class="textPointsAndLevel">
                    Mit <b><%= Model.ActivityPoints.ToString("N0") %> Lernpunkten</b> bist du in <span style="white-space: nowrap"><b>Level <%= Model.ActivityLevel %></b>.</span>
                </p>
            </div>
            <div class="row">
                <div class="NextLevelContainer">
                    <div class="ProgressBarContainer">
                         <div id="NextLevelProgressPercentageDone" class="ProgressBarSegment ProgressBarDone" style="width: <%= Model.ActivityPointsPercentageOfNextLevel %>%;">
                            <div class="ProgressBarSegment ProgressBarLegend">
                                <span id="NextLevelProgressSpanPercentageDone"><%= Model.ActivityPointsPercentageOfNextLevel %> %</span>
                            </div>
                        </div>
                        <div class="ProgressBarSegment ProgressBarLeft" style="width: 100%;"></div> 
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-4">
            <h3>Im Netzwerk</h3>
                <p class="greyed" style="font-size: 12px;"><a href="<%= Url.Action("Network", "Users") %>">Zu deinem Netzwerk</a></p>
                <% if (Model.NetworkActivities.Count == 0)
                   { %>
                        Keine Aktivitäten in deinem <a href="<%= Url.Action("Network", "Users") %>">Netzwerk</a>. 
                        Erweitere dein Netzwerk, indem du anderen <a href="<%= Url.Action("Users", "Users") %>">Nutzern folgst</a>.
                <% }
                   else
                   { %>
                    <% foreach (var activity in Model.NetworkActivities)
                       { %>
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-xs-3">
                                <a href="<%= Links.UserDetail(activity.UserCauser) %>">
                                <img class="ItemImage" src="<%= new UserImageSettings(activity.UserCauser.Id).GetUrl_128px_square(activity.UserCauser).Url %>" />
                                </a>
                            </div>
                            <div class="col-xs-9" id="textNetzwerk" >
                                <div class="greyed" style="font-size: 10px; margin: -4px 0;">vor <%= DateTimeUtils.TimeElapsedAsText(activity.At) %></div>
                                <div  style="clear: left;" >
                                    <a href="<%= Links.UserDetail(activity.UserCauser) %>"><%= activity.UserCauser.Name %></a> <%= UserActivityTools.GetActionDescription(activity) %>
                                    <%= UserActivityTools.GetActionObject(activity) %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    <div class="row" style="opacity: 0.4;">
                        <div class="col-xs-12"><a class="featureNotImplemented">mehr...</a></div>
                    </div>
                <% } %>
        </div>
    </div>
<%--    
    <div id="allDateRows"class="row third-row">
        <div class ="col-xs-8">
             <div>
                <h3 >Termine</h3>
                <p class="greyed" style="font-size: 12px;" id="datesOverview"><a href="#">Zur Terminübersicht</a></p>
                <p id="noOpenDates">
                    Du hast momentan keine offenen Termine. Termine helfen dir dabei, dich optimal auf eine Prüfung vorzubereiten.
                </p>
                <p>
                    <a href="<%= Url.Action("Create", "EditDate") %>" class="btn btn-sm">
                        <i class="fa fa-plus-circle"></i>&nbsp;Termin erstellen
                    </a>
                </p>
                <hr style="margin: 5px 0px;"/>
                
                <% var index = 0;
                    foreach (var date in Model.Dates.Take(3))
                    {
                        index++;
                    %>
                    <div class="row" style="margin-bottom: 3px;" data-date-id="<%= Model.DateRowModelList[index -1 ].Date.Id%>">
                        <div class="col-xs-2">
                            <div id="chartKnowledgeDate<%=index %>"></div>
                        </div>
                        <div class="col-xs-3 first-cell">
                               
                            <% if(Model.Dates[index-1].Remaining().TotalSeconds < 0 ){
                                                    
                                    Response.Write("Vorbei seit ");
                                }else { 
                                    Response.Write("Noch ");
                                }  %>
                                             
                            <%= Model.Dates[index-1].RemainingLabel().Value %> 
                            <% Response.Write(Model.Dates[index-1].RemainingLabel().Label); %><br/>
                                   
                            <% if(Model.Dates[index-1].Remaining().TotalSeconds < 0 ){ %>
                                <span style="font-size: 11px">Termin war am <br/></span> 
                            <% }else{ %>
                                <span style="font-size: 11px">bis Termin am <br/></span> 
                            <% } %>
                            <span style="font-size: 11px;">
                                <%= date.DateTime.ToString("dd.MM.yyy HH:mm") %>
                            </span>
                        </div>
                        <div class="col-xs-4">
                            <div>ca. <span class="TPTrainingDateCount"><%= Model.Dates[index-1].TrainingPlan.OpenDates.Count %></span> Lernsitzungen</div>
                            <div>ca. <span class="TPRemainingTrainingTime"><%= Model.Dates[index-1].TrainingPlan.TimeRemaining %></span> Lernzeit</div>
                            <div>
                                <% if(Model.Dates[0].HasOpenDates) {
                                        var timeSpanLabel = new TimeSpanLabel(Model.Dates[index-1].TrainingPlan.TimeToNextDate, showTimeUnit: true);
                                        if (timeSpanLabel.TimeSpanIsNegative) { %>
                               
                                            <a style="display: inline-block;" data-btn="startLearningSession" href="/Termin/Lernen/<%=date.Id %>"><i class="fa fa-bell"> </i>&nbsp;Jetzt lernen!</a><br/>
                                    <% } else { %>
                                        <i class="fa fa-bell"> </i> nächste Lernsitzung <br/>
                                        in <span class="TPTimeToNextTrainingDate"><%= timeSpanLabel.Full %></span> 
                                    <% }
                                        if (!timeSpanLabel.TimeSpanIsNegative)
                                        {
                                    %>
                                        
                                    (<span class="TPQuestionsInNextTrainingDate"><%= Model.Dates[index - 1].TrainingPlan.QuestionCountInNextDate %></span> Fragen)
                                    <% }
                                    } %>
                            </div>
                        </div>
                            <div class="col-xs-3 third-cell">
                                <a data-btn="startLearningSession" href="/Termin/Lernen/<%=date.Id %>" class="btn btn-primary btn-sm" style=" display: inline-block;">
                                    <i class="fa fa-line-chart"></i> 
                                    Jetzt lernen
                                </a>
                                <!-- traning.ts is missing -->
                                <a href="#modalTraining" class="btn btn-default btn-sm" data-dateId="<%=  Model.DateRowModelList[index -1 ].Date.Id %>" id="detailsToEdit">   
                                    <i class="fa fa-pencil" style="font-size: 0.7em" > Details &amp; bearbeiten</i>
                                </a>
                                <a href="<%= Links.GameCreateFromDate(date.Id) %>" class="btn btn-link btn-sm show-tooltip" data-original-title="Spiel mit Fragen aus diesem Termin starten." id="startGame" >
                                    <i class="fa fa-gamepad " style="font-size: 18px;"></i>
                                    Spiel starten
                                </a>
                                <a data-toggle="modal" data-dateId="<%= date.Id %>" href="#modalDelete">
                                    <i class="fa fa-trash-o"> Termin löschen</i> 
                                </a>
                            </div>  
                        </div>  
                        <hr style="margin: 8px 0;"/>  
                    <% } %>
                    <% if (Model.Dates.Count > 3)
                        { %>
                        <a href="<%= Links.Dates() %>">Du hast <%= (Model.Dates.Count - 3) %> <%= StringUtils.PluralSuffix(Model.Dates.Count - 3,"weitere Termine","weiteren Termin") %></a>
                        <hr style="margin: 8px 0px;"/>
                    <% } %>
                 <p>
                    <% if (Model.DatesInNetwork.Count > 0)
                        { %>
                        <a href="<%= Links.Dates() %>"><%= Model.DatesInNetwork.Count %> Termin<%= StringUtils.PluralSuffix(Model.DatesInNetwork.Count,"e") %> in deinem Netzwerk</a>
                        &nbsp;<i class="fa fa-info-circle show-tooltip" title="Termine aus deinem Netzwerk kannst du einfach übernehmen. So kannst du leicht mit Freunden lernen."></i>
                    <% }
                        else
                        {  %>
                        Kein Termin in deinem <a href="<%= Url.Action("Network", "Users") %>">Netzwerk</a>&nbsp;<i class="fa fa-info-circle show-tooltip" title="Termine aus deinem Netzwerk kannst du einfach übernehmen. So kannst du leicht mit Freunden lernen."></i>.
                        Erweitere dein Netzwerk, indem du anderen <a href="<%= Url.Action("Users", "Users") %>">Nutzern folgst</a>.
                    <% } %>          
                </p>
            </div>
        </div>
    </div>--%>
 </div>

<%--<% Html.RenderPartial("Dates/Modals/DeleteDate"); %>
<% Html.RenderPartial("Dates/Modals/TrainingSettings"); %>
<% Html.RenderPartial("Dates/Modals/CopyDate"); %>--%>

<%= Scripts.Render("~/bundles/js/_dashboard") %>
<%--<%= Scripts.Render("~/bundles/js/Dates") %>--%>

  <%--  <div class="row">
        <div class="col-md-6">
            <h3>Deine Lernpunkte</h3>
            <div style="text-align: center;">
                <span class="level-display">
                    <span style="display: inline-block; white-space: nowrap;">
                        <svg class="">
                            <circle cx="50%" cy="50%" r="50%" />
                            <text class="level-count" x="50%" y="50%" dy = ".34em" ><%= Model.ActivityLevel %></text>
                        </svg>
                    </span>
                </span>
                <p class="textPointsAndLevel">
                    Mit <b><%= Model.ActivityPoints.ToString("N0") %> Lernpunkten</b> bist du in <span style="white-space: nowrap"><b>Level <%= Model.ActivityLevel %></b>.</span>
                </p>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="NextLevelContainer">
            <div class="ProgressBarContainer">
                 <div id="NextLevelProgressPercentageDone" class="ProgressBarSegment ProgressBarDone" style="width: <%= Model.ActivityPointsPercentageOfNextLevel %>%;">
                                <div class="ProgressBarSegment ProgressBarLegend">
                                    <span id="NextLevelProgressSpanPercentageDone"><%= Model.ActivityPointsPercentageOfNextLevel %> %</span>
                                </div>
                </div>
                 <div class="ProgressBarSegment ProgressBarLeft" style="width: 100%;"></div> 
            </div>
        </div>
    </div>

    <div class="row">
        <div class ="col-md-2">
            <h4>Deine Termine</h4>
        </div>
    </div>--%>
    <%--<div class="row">
        <div class ="col-md-12">
             <div class="rowBase" id="FutureDatesOverview" style="padding: 10px;">
               <%-- <h3 style="margin-top: 0; margin-bottom: 0;">Termine</h3>
                <p class="greyed" style="font-size: 12px;"><a href="<%= Links.Dates() %>">Zur Terminübersicht</a></p>
                <% if (Model.Dates.Count == 0)
                    { %>
                    <p>
                        Du hast momentan keine offenen Termine. Termine helfen dir dabei, dich optimal auf eine Prüfung vorzubereiten.
                    </p>
                    <p>
                        <a href="<%= Url.Action("Create", "EditDate") %>" class="btn btn-sm">
                            <i class="fa fa-plus-circle"></i>&nbsp;Termin erstellen
                        </a>
                    </p>
                    <hr style="margin: 5px 0px;"/>
                <% }
                    else
                    { %>
                    <%
                        var index = 0;
                        foreach (var date in Model.Dates.Take(3))
                        {
                            index++;
                        %>
                        <div class="row" style="margin-bottom: 3px;">
                            <div class="col-xs-9">
                                <div style="font-weight: bold; margin-bottom: 3px;"><%= date.GetTitle(true) %></div>
                                <span style="font-size: 12px;">Noch <%= (date.DateTime - DateTime.Now).Days %> Tage für <%= date.CountQuestions() %> Fragen aus:</span><br />
                                <% foreach (var set in date.Sets)
                                    { %>
                                    <a href="<%= Links.SetDetail(Url, set) %>">
                                        <span class="label label-set" style="font-size: 70%;"><%= set.Name %></span>
                                    </a>                            
                                <% } %>
                            </div>
                            <div class="col-xs-3" style="opacity: .4;">
                                <div id="chartKnowledgeDate<%=index %>"></div>
                            </div>
                        </div>  
                        <div class="row">
                            <div class="col-xs-12">
                                <a href="<%= Links.GameCreateFromDate(date.Id) %>" class="show-tooltip" data-original-title="Spiel mit Fragen aus diesem Termin starten." style="margin-top: 17px; display: inline-block;">
                                    <i class="fa fa-gamepad" style="font-size: 18px;"></i>
                                    Spiel starten
                                </a>
                                &nbsp;
                                <a data-btn="startLearningSession" href="/Termin/Lernen/<%=date.Id %>" style="margin-top: 17px; display: inline-block;">
                                    <i class="fa fa-line-chart"></i> 
                                    Jetzt lernen
                                </a>
                            </div>                                
                        </div>
                        <hr style="margin: 8px 0;"/>  
                    <% } %>
                    <% if (Model.Dates.Count > 3)
                        { %>
                        <a href="<%= Links.Dates() %>">Du hast <%= (Model.Dates.Count - 3) %> <%= StringUtils.PluralSuffix(Model.Dates.Count - 3,"weitere Termine","weiteren Termin") %></a>
                        <hr style="margin: 8px 0px;"/>
                    <% } %>
                <% } %>
                <p>
                    <% if (Model.DatesInNetwork.Count > 0)
                        { %>
                        <a href="<%= Links.Dates() %>"><%= Model.DatesInNetwork.Count %> Termin<%= StringUtils.PluralSuffix(Model.DatesInNetwork.Count,"e") %> in deinem Netzwerk</a>
                        &nbsp;<i class="fa fa-info-circle show-tooltip" title="Termine aus deinem Netzwerk kannst du einfach übernehmen. So kannst du leicht mit Freunden lernen."></i>
                    <% }
                        else
                        {  %>
                        Kein Termin in deinem <a href="<%= Url.Action("Network", "Users") %>">Netzwerk</a>&nbsp;<i class="fa fa-info-circle show-tooltip" title="Termine aus deinem Netzwerk kannst du einfach übernehmen. So kannst du leicht mit Freunden lernen."></i>.
                        Erweitere dein Netzwerk, indem du anderen <a href="<%= Url.Action("Users", "Users") %>">Nutzern folgst</a>.
                    <% } %>          
                </p>
            </div>
        </div>
    </div>--%>


    <%-- Training --%> 
<%--<div class="row">
    <div class ="col-md-12">
        <div class="rowBase" style="padding: 10px; height: 384px;">
            <h3 style="margin-bottom: 0px; margin-top: 0;">Training</h3>
            <p class="greyed" style="font-size: 12px;">In den letzten 30 Tagen</p>
                
            <div id="chartActivityLastDays" style="height: 245px; margin-left: -3px; margin-right: 0px; margin-bottom: 10px; text-align: left;"></div>
                
            <div class="row" style="font-size: 12px">
                <div class="col-md-12">
                    <% var streak = Model.StreakDays; %>
                    <!-- -->
                    <span style="display: inline-block; width: 40%">Lerntage gesamt: 
                        <b><%= streak.TotalLearningDays %></b></span> <span class="greyed" style="font-weight: bold;">
                        seit <%= Model.User.DateCreated.ToString("dd.MM.yyyy") %>
                    </span><br />
                        
                    <!-- LongestStreak -->
                    <span style="display: inline-block; width: 40%">
                        Längste Folge: <b><%= streak.LongestLength %></b>
                    </span>
                    <% if (streak.LongestLength == 0)
                        { %>
                        <span class="greyed" style="font-weight: bold;">zuletzt nicht gelernt</span>
                    <% }
                        else
                        { %>
                        <span class="greyed" style="font-weight: bold;">
                            <%= streak.LongestStart.ToString("dd.MM.") %> - <%= streak.LongestEnd.ToString("dd.MM.yyyy") %>
                        </span><br />
                    <% } %>
                        
                    <!-- CurrentStreak -->
                    <span style="display: inline-block; width: 40%">
                        Aktuelle Folge: <b><%= streak.LastLength %></b>
                    </span>
                    <span style="width: 40%; margin-top: 5rem;">
                        <h3>Deine Reputation</h3>
                
                        <p>
                            Reputation: <b><%= Model.ReputationTotal %> Punkte</b>
                            <i class="fa fa-question-circle show-tooltip" data-original-title="Reputationspunkte erhältst du, wenn du gute Lerninhalte erstellst und andere damit lernen."></i>
                            <br/>
                            Position: <%= Model.ReputationRank %><br/>
                            Erstellte Fragen: <%= Model.QuestionsCreatedCount %><br/>
                            Erstellte Lernsets: <%= Model.SetsCreatedCount %>
                        </p>

                        <p class="moreInfoLink">
                            <a href="<%= Links.UserDetail(Model.User) %>">Details auf deiner Profilseite</a>
                        </p>
                    </span>
                    <% if (streak.LastLength == 0)
                        { %>
                        <span class="greyed" style="font-weight: bold;">zuletzt nicht gelernt</span>
                    <% }
                        else
                        { %>
                        <%= streak.LastStart.ToString("dd.MM") %> - <%= streak.LastEnd.ToString("dd.MM.yyyy") %>
                    <% } %>
                  
                </div>
            </div>
        </div>
    </div>
</div>--%>

<%--<div class="row">
    <div class="col-md-3">
            <h3>Im Netzwerk</h3>
                    <p class="greyed" style="font-size: 12px;"><a href="<%= Url.Action("Network", "Users") %>">Zu deinem Netzwerk</a></p>

                    <% if (Model.NetworkActivities.Count == 0)
                        { %>
                            Keine Aktivitäten in deinem <a href="<%= Url.Action("Network", "Users") %>">Netzwerk</a>. 
                            Erweitere dein Netzwerk, indem du anderen <a href="<%= Url.Action("Users", "Users") %>">Nutzern folgst</a>.
                    <% }
                        else
                        { %>
                        <% foreach (var activity in Model.NetworkActivities)
                            { %>
                            <div class="row">
                                <div class="col-xs-3">
                                    <a href="<%= Links.UserDetail(activity.UserCauser) %>">
                                    <img class="ItemImage" src="<%= new UserImageSettings(activity.UserCauser.Id).GetUrl_128px_square(activity.UserCauser).Url %>" />
                                    </a>
                                </div>
                                <div class="col-xs-9" style="">
                                    <div class="greyed">vor <%= DateTimeUtils.TimeElapsedAsText(activity.At) %></div>
                                    <div style="clear: left;">
                                        <a href="<%= Links.UserDetail(activity.UserCauser) %>"><%= activity.UserCauser.Name %></a> <%= UserActivityTools.GetActionDescription(activity) %>
                                        <%= UserActivityTools.GetActionObject(activity) %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        <div class="row" style="opacity: 0.4;">
                            <div class="col-xs-12"><a class="featureNotImplemented">mehr...</a></div>
                        </div>
                    <% } %>
   
    </div>
</div>--%>

