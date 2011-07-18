﻿<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="ViewPage<CreateQuestionModel>" %>

<%@ Import Namespace="TrueOrFalse.Core" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Models" %>

<asp:Content runat="server" ID="head" ContentPlaceHolderID="Head">
    <script type="text/ecmascript" language="javascript">
        $(document).ready(function () {
            $("a.submit").click(function (event) {
                $(this).closest('form').submit();
                event.preventDefault();
            });
        })
    </script>
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

    <style type="text/css">
        fieldset.entry label
        {
            width: 130px;
            display:block;
            float:left;
            text-align:right;
            padding-right:10px;
            padding-top:4px;
        }
        
        fieldset.entry textarea
        {
            width: 320px;    
            height: 80px;
        }
        
    </style>

	<h2>Frage erstellen</h2>
	<% using (Html.BeginForm()){ %>

        <% Html.Message(Model.Message); %>
	
	    <h2><%= Html.Encode(ViewData["Msg"]) %></h2>

	    <fieldset class="entry">
		    <legend>Neue Frage erstellen</legend>

            <%= Html.LabelFor(m => m.Visibility) %>
            <div style="padding-bottom:3px;">
                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.All )%> Alle &nbsp;&nbsp;
                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.Owner)  %> Nur ich &nbsp;&nbsp;
                <%= Html.RadioButtonFor(m => m.Visibility, QuestionVisibility.OwnerAndFriends)  %> Ich und meine Freunde
            </div><br style="font-size:1px; line-height:1px; height:1px;"/>
		    <%= Html.LabelFor(m => m.Question)%>
		    <%= Html.TextAreaFor(m => m.Question, new { @style = "height:30px;" })%><br />

            <script>
                $(function () {
                    $("#tabs").tabs();
                });
	        </script>
           
               <%= Html.Label("tabs")%>
               <div id="tabs" style="width:326px; float:left;">               
                    <ul>
                        <li><a href="#tabs-1">Sport</a></li>
                        <li><a href="#tabs-2">Ereignis</a></li>
                        <li><a href="#tabs-3">+</a></li>
                    </ul>
                 <div id="tabs-1"><p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. 
                                     Curabitur nec arcu.</p>
                 </div>
                 <div id="tabs-2"><p>Morbi tincidunt, dui sit amet facilisis feugiat, odio metus gravida ante, ut pharetra massa metus id nunc. 
                                     Duis scelerisque molestie turpis.</p>
                 </div>
                 <div id="tabs-3"><p>Mauris eleifend est et turpis. Duis id erat.</p>
                 </div>
              </div>
            
            <br />
            <%= Html.LabelFor(m => m.AnswerType ) %>
		    <%= Html.DropDownListFor(m => Model.AnswerType, Model.AnswerTypeData)%> <br />
            <%= Html.LabelFor(m => m.Answer ) %>
		    <%= Html.TextAreaFor( m=>m.Answer  ) %><br />
		    <%= Html.LabelFor(m => m.Description ) %>
		    <%= Html.TextAreaFor( m=>m.Description ) %><br />		   
		    <%= Html.LabelFor(m => m.EducationLink ) %>
		    <%= Html.DropDownListFor(m => Model.EducationLink, Model.EducationLinkData)%> <br />
		    <%= Html.LabelFor(m => m.Character) %>
		    <%= Html.DropDownListFor(m => Model.Character, Model.CharacterData)%> <br />

            <br />
            <label>&nbsp;</label>

            <%= Buttons.Submit("Speichern", inline:true)%>
            <%= Buttons.Submit("Speichern & Neu", inline: true)%>
	    </fieldset>
	<% } %>
</asp:Content>
