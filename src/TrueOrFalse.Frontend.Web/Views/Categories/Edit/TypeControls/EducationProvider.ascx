﻿<%@ Control Language="C#" Inherits="ViewUserControl<EditCategoryTypeModel>" %>

<h4 class="CategoryTypeHeader"><%= CategoryType.EducationProvider.GetName() %></h4>
<div class="form-group">
    <label class="RequiredField columnLabel control-label" for="Name">Name</label>
    <div class="columnControlsFull">
        <input class="form-control" name="Name" type="text" value="<%= Model.Name %>">
    </div>
</div>
<div class="form-group">
    <label class="columnLabel control-label" for="Description">
        Beschreibung 
        <i class="fa fa-question-circle show-tooltip" 
            title="<%= EditCategoryTypeModel.DescriptionInfo %>" data-placement="<%= CssJs.TooltipPlacementLabel %>">
        </i>
    </label>
    <div class="columnControlsFull">
        <textarea class="form-control" name="Description" type="text" rows="8"><%= Model.Description %></textarea>
    </div>
</div>

<div class="form-group" style="padding-top: 20px; padding-bottom: 20px;">
    <label class="columnLabel control-label" for="Url">
        Offizielle Webseite des Bildungsanbieters
        <i class="fa fa-question-circle show-tooltip" 
           title="Gib bitte hier die offizielle Webseite des Bildungsanbieters an." data-placement="<%= CssJs.TooltipPlacementLabel %>">
        </i>
    </label>
    <div class="columnControlsFull">
        <input class="form-control" name="Url" type="text" value="<%= Model.Url %>">
    </div>
    <label class="columnLabel control-label" for="UrlLinkText">
        Angezeigter Link-Text (optional)
        <i class="fa fa-question-circle show-tooltip" 
           title="Gib hier einen Text an, der den Link beschreibt, zum Beispiel 'Offizielle Webseite von XY'. Lässt du das Feld leer, wird die Link-Adresse angezeigt." data-placement="<%= CssJs.TooltipPlacementLabel %>">
        </i>
    </label>
    <div class="columnControlsFull">
        <input class="form-control" name="UrlLinkText" type="text" maxlength="50" value="<%= Model.UrlLinkText %>">
    </div>
</div>

<div class="form-group">
    <label class="columnLabel control-label" for="WikipediaUrl">
        Wikipedia-Artikel
        <i class="fa fa-question-circle show-tooltip" 
           title="Falls es bei Wikipedia einen Artikel zu diesem Bildungsanbieter gibt, gib sie bitte hier an." data-placement="<%= CssJs.TooltipPlacementLabel %>">
        </i>
    </label>
    <div class="columnControlsFull">
        <input class="form-control" name="WikipediaUrl" type="text" value="<%= Model.WikipediaUrl %>">
    </div>
</div>
