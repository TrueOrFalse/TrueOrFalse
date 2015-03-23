﻿<%@ Page Title="MEMuchO in Beta" Language="C#" MasterPageFile="~/Views/Shared/Site.Beta.Master" AutoEventWireup="true" 
    Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link href="/Views/Beta/Beta.css" rel="stylesheet" />
    <%= Scripts.Render("~/bundles/beta") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1 style="color: white; margin-top: 15%">
                Private Beta
            </h1>
            <hr class="star-light">
    
            <div class="alert alert-danger" role="alert" id="msgInvalidBetaCode" style="display:none">
                Kein gültiger Beta-Code.
                Weiter unten kannst du dich registrieren.
            </div>

            <form class="form-inline" style="font-size: 25px; line-height: 20px; color: white;">
                <div class="form-group">
                    <div></div>
                    <p class="form-control-static">Zugang:</p>
                </div>
                <div class="form-group">
                    <div>
                        <input type="password" class="form-control " id="txtBetaCode" placeholder="Beta-Code" style="max-width: 150px; font-size: 18px;">
                    </div>    
                </div>
                <a class="btn btn-success shake" href="#" style="font-size: 18px;" id="btnEnter">
                    <i class="fa fa-sign-in"></i> Eintreten
                </a>
            </form> 
        </div>
    </div>
    
    <div class="row">
        <div class="well col-md-6 col-md-offset-3" style="margin-top: 35px; background-color: whitesmoke; ">
        <h3><a>Was wird MEMuchO?</a></h3>
        <p>
            MEMuchO wird eine vernetzte Lern- und Wissensplattform. <br/>
            MEMuchO hilft dir...
        </p>
        <ul style="list-style-type: none">
            <li>
                <b>...schneller zu lernen.</b>
                <p>
                    MEMuchO analysiert dein Lernverhalten und wiederholt schwierige 
                    Fragen zum optimalen Zeitpunkt. So brauchst du weniger Zeit zum Lernen.
                </p>
            </li>
            <li>
                <b>...dein Allgemein- und Spezialwissen zu erweitern.</b>
                <p>
                    Du möchtest gerne mehr über Politik oder über die verschiedenen 
                    Spurbreiten von Modelleisenbahnen erfahren? Finde die passenden 
                    Fragesätze und stelle dir dein Wunschwissen zusammen!
                </p>
            </li>
            <li>
                <b>...zu einem bestimmten Termin zu lernen.</b>
                <p>
                    Eine Klassenarbeit, eine Prüfung oder ein wichtiges Gespräch steht an? 
                    Lege einen Termin an und bestimme, was du bis dahin wissen musst. 
                    Mit MEMuchO weißt du immer, was du schon sicher kannst und wo du noch 
                    weiter üben musst.
                </p>
            </li>
            <li>
                <b>...zu überblicken, was du weißt und was du wissen möchtest.</b>
                <p>
                    Du möchtest dir gerne 50, 500, 5000 (oder mehr) Fakten merken? 
                    Kein Problem, mit MEMuchO behältst du den Überblick. 
                </p>
            </li>
            <li>
                <b>...dein Wissen mit anderen zu teilen und gemeinsam zu lernen.</b>
                <p>
                    MEMuchO ist ein offenes Netzwerk, wo du dein Wissen teilen, auf das 
                    Wissen anderer zurückgreifen und mit Freunden gemeinsam lernen kannst. 
                    Denn Wissen wird mehr, wenn man es teilt! 
                </p>
            </li>
        </ul>
    </div>
    </div>
    
    <div class="row" style="color: white; margin-bottom: 100px;">
        <div class="col-md-6 col-md-offset-3">
            <h1>
                Betatester
            </h1>
            
            <hr class="star-light">
            
            <p>
                Wenn du Betatester werden möchtest, schicke uns eine Anfrage.
            </p>
            
            <form class="form-inline" style="color: white;">
                <div class="form-group">
                    <div class="col-sm-6">
                        <input type="email" class="form-control" id="betaCode" placeholder="deine@email.de" style="font-size: 18px;">
                    </div>    
                </div>
                <a class="btn btn-info" href="#" style="font-size: 18px;">
                    <i class="fa fa-envelope-o"></i> Zugang anfragen
                </a>
            </form> 
        </div>
    </div>

</asp:Content>