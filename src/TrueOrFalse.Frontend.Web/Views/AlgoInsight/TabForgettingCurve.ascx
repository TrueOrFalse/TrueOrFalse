﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<TabForgettingCurveModel>" %>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript" src="/Views/AlgoInsight/TabForgettingCurve_.js"></script>

<div class="row" >
    <div class="col-md-12" style="margin-top:3px; margin-bottom:7px;">
        <h3>Vergleich Vergessenskurven</h3>
    </div>   
</div>

<div class="row">
    <div class="col-md-3">
        <div class="row" style="margin-bottom: 12px">
            <div class="col-md-4">            
                Intervall:
            </div>
            <div class="col-md-8" style="padding-left: 0px;">
                <select>
                    <option>Minuten</option>
                    <option>Stunden</option>
                    <option>Tage</option>
                    <option>Wochen</option>
                    <option>Logarithmisch</option>
                </select>
            </div>
        </div>
        
        <% for(var i = 0; i < 4; i++)
            {
                var colors = new[]
                {
                   "rgb(51, 102, 204)" /* blue */,
                   "rgb(220, 57, 18)" /* red */,
                   "rgb(255, 153, 0)" /* yellow */,
                   "rgb(16, 150, 24)" /* green */
               };

        %>
            <div class="row" style="border-bottom: 2px solid <%= colors[i] %>;">
                <div class="col-md-12" style="">
                    <b>Kurve <%= i %></b>
                    400P R0.71
                    
                    <input type="checkbox" class="pull-right" checked="checked" style="padding-right: 3px; position: relative; top: 0px;"  />
                </div>
            </div>
            <div class="row" style="padding: 3px; margin-top: 5px;">
                <div class="col-md-4" style="text-align: right">Feature:</div>
                <div class="col-md-8" style="padding-left: 0px;">
                    <select style="width: 100%">
                        <option>Wiederholungen 1</option>
                        <option>Wiederholungen 2</option>
                        <option>Wiederholungen 3</option>
                    </select>
                </div>
            </div>
            <div class="row" style="padding: 3px; margin-bottom: 10px;">
                <div class="col-md-4" style="text-align: right">Typ:</div>
                <div class="col-md-8" style="padding-left: 0px;">
                    <select style="width: 100%;">
                        <option>Mittelschwer</option>
                        <option>Schwer</option>
                        <option>Leicht</option>
                        <option>Nobrainer</option>
                    </select>
                </div>
            </div>
        <% } %>
    </div>
    <div class="col-md-9" style="vertical-align: top; text-align: left;">
        <div id="chartExplore" style="width: 100%; height: 350px; vertical-align: top"></div> 
    </div>

    <div class="row" >
        <div class="col-md-12" style="margin-top:3px; margin-bottom:7px;">
            <h3>Ausgewählte Vergessenskurven</h3>
            
            <p>
                Eine Auswahl besonders aussagekräftiger 
            </p>

        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <h4>Schwere vs. leichte Fragen (Klassifzierung)</h4>
            <div id="chartSuggested1" style="width: 100%; height: 250px"></div>
        </div>
        <div class="col-md-6">
            <h4>Nach Tageszeit gelernt</h4>
            <div id="chartSuggested2" style="width: 100%; height: 250px"></div>        
        </div>
    </div>

</div>

