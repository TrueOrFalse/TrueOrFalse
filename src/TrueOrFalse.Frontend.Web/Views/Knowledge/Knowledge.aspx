﻿<%@ Page Title="Mein Wissensstand" Language="C#" MasterPageFile="~/Views/Shared/Site.MenuLeft.Master" Inherits="ViewPage<KnowledgeModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<asp:Content runat="server" ID="header" ContentPlaceHolderID="Head">
    
    <script>
        $(function () {
            $("#totalKnowledgeSpark").sparkline([75, 22, 40], {
                type: 'pie',
                sliceColors: ['#3e7700', '#B13A48', '#EFEFEF']
            });

            $("#totalKnowledgeOverTimeSpark").sparkline([5, 6, 7, 9, 9, 5, 3, 2, 2, 4, 6, 7, 5, 6, 7, 9, 9, 5, 3, 2, 2, 4, 6, 7, 5, 6, 7, 9, 9, 5, 3, 2, 2, 4, 6, 7, 5, 6, 7, 9, 9, 5], {
                type: 'line',
                witdh: '250'
            });

            $("#answeredThisWeekSparkle").sparkline([14, 4], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#answeredThisMonthSparkle").sparkline([4, 8], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#answeredLastWeekSparkle").sparkline([4, 6], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#answeredLastMonthSparkle").sparkline([5, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            
            $("#examSparkle1").sparkline([1, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#examSparkle2").sparkline([15, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#examSparkle3").sparkline([71, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#examSparkle4").sparkline([1, 17], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            $("#examSparkle5").sparkline([10, 0], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            

            $("#inCategoeryOverTime-1").sparkline([1, 4, 4, 2, 1, 8, 7, 9], { type: 'line', sliceColors: ['#3e7700', '#B13A48'] });
            $("#question-1").sparkline([5, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
            
            $("#inCategory-1").sparkline([5, 5], { type: 'pie', sliceColors: ['#3e7700', '#B13A48'] });
        });
    </script>
    
    <style>
        #totalKnowledgeOverTime{font-size: 18px; line-height:27px ;color: rgb(170, 170, 170);padding-top: 5px;display: inline-block;}
        #totalKnowledgeOverTimeSpark{ display: inline-block;}
        div.answerHistoryRow div{ display: inline-block; height: 22px;}
        div.answerHistoryRow .answerAmount{ color:blue; font-weight: bolder;}
        
        div.column  { width: 260px; float: left;}

        div.percentage{display: inline-block; width: 40px; background-color:beige; height: 22px;vertical-align: top;}
        div.percentage span{ font-size: 22px; color: green; position: relative; top: 2px; left: 4px;}
    </style>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 style="color: black; margin-bottom: 5px; margin-top: 0px;"><span class="underlined Knowledge">Hallo <span class=".dark-blue"><%= Model.UserName %></span>, dein Wunschwissen</span>:</h2>
        
    <p style="margin-bottom: 10px;">Hier erhältst du eine Übersicht über dein Wunschwissen und deinen Wissensstand.</p>

    <% if(!Model.IsLoggedIn){ %>

        <div class="bs-callout bs-callout-info">
            <h4>Anmelden oder registrieren</h4>
            <p>Um Wunschwissen zu verwenden, musst du dich <a href="/Anmelden">anmelden</a> oder dich <a href="/Registrieren">registrieren</a>.</p>
        </div>

    <% }else{  %>
        <div class="column">
            <h3>Wunschwissen</h3>
            <div class="answerHistoryRow">
                <div>
                    <a href="<%= Links.QuestionsWish(Url) %>">
                        Fragen: <span><%= Model.QuestionsCount %> <span id="totalKnowledgeSpark"></span></span>
                    </a>
                </div>    
            </div>
            <div class="answerHistoryRow">
                <div>
                    Frageseätze: <span><%= Model.QuestionsSetCount %> <span id="Span1"> (mit x Fragen)</span></span><br/>    
                </div>
                
            </div>
            <span id="totalKnowledgeOverTime">Entwicklung über Zeit:<br /> 
            <span id="totalKnowledgeOverTimeSpark"></span></span>
        </div>
        
        <div class="column">
            <h3>Wissenstand</h3>
            <div style="padding-bottom: 10px;">Dein Wissenstand entspricht ca. 83% Deines Wunschwissens.</div>
            <div>Gewusst: 70% (217 Fragen) </div>
            <div>Nicht gewusst 12% (xx Fragen)  </div>
            <div>Unbekannt 18% (xx Fragen)</div>
        </div>

        <div class="column">
            <h3>Training</h3>
            <div class="answerHistoryRow" style="margin-bottom: 5px;">
                <div style="color:black;">Antworten ges.: 4312 </div> (seit: 4.3.2012)
            </div>
                
            <div class="answerHistoryRow">    
                <div>Diese Woche <span class="answerAmount"><%= Model.TotalAnswerThisWeek %></span> 
                    <span id="answeredThisWeekSparkle"></span>
                    <div class="percentage"><span >74%</span></div>
                </div> 
            </div>
            <div class="answerHistoryRow">
                <div>Diesen Monat <span class="answerAmount"><%= Model.TotalAnswerThisMonth %></span> <span id="answeredThisMonthSparkle"></span>
                    <div class="percentage"><span>19%</span></div>
                </div>
            </div>
            <div class="answerHistoryRow">
                <div>Diese Jahr <span class="answerAmount"><%= Model.TotalAnswerPreviousWeek %></span> <span id="answeredLastWeekSparkle"></span></div> 
            </div>
            <div class="answerHistoryRow">
                <div>Letzten Monat <span class="answerAmount"><%= Model.TotalAnswerLastMonth %></span> <span id="answeredLastMonthSparkle"></span></div> 
            </div>
        </div>
        <div style="clear:both;"></div>
        
        <div style="padding-top:20px; height: 200px; ">
        
            <div class="column">
                <h3>Fragen (175)</h3>
                <table>
                    <tr>
                        <td>Wann wurde xy geboren </td> 
                        <td>14x <span id="question-1"></span> </td>
                    </tr>
                </table>
            </div>
        
            <div class="column">
                <h3>Fragesätze</h3>
                <div>
                    <span>Noch keine Fragesätze</span>
                </div>
            </div>
 
            <div class="column">
                <h3>Kategorien (34)</h3>
                <table>
                    <tr>
                        <td>Musik</td> 
                        <td>72</td> 
                        <td><span id="inCategory-1"></span></td>
                        <td><span id="inCategoeryOverTime-1"></span></td>
                    </tr>
                </table>
            </div>
        </div>
    <% } %>
</asp:Content>