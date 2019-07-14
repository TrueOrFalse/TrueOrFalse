﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<SingleCategoryFullWidthModel>" %>
<%@ Import Namespace="TrueOrFalse.Frontend.Web.Code" %>

<div class="singleCatFullWidth">
    <div class="row">
        <div class="col-xs-9">
            <div class="row flex">
                <div class="col-xs-2">
                    <div class="ImageContainer">
                        <%= Model.ImageFrontendData.RenderHtmlImageBasis(128, true, ImageType.Category) %>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div>
                        <div class="categoryQuestionCount">
                            <span class="Pin" data-category-id="<%= Model.CategoryId %>" style="">
                                <a href="#" class="noTextdecoration">
                                    <%= Html.Partial("AddToWishknowledge", new AddToWishknowledge(Model.IsInWishknowledge)) %>
                                </a>
                            </span>&nbsp;
                    <%= Model.Category.Type == CategoryType.Standard ? "Thema" : Model.CategoryType %> mit <%= Model.AggregatedSetCount %> Lernset<%= StringUtils.PluralSuffix(Model.AggregatedSetCount, "s") %> und <%= Model.AggregatedQuestionCount %> Frage<%= StringUtils.PluralSuffix(Model.AggregatedQuestionCount, "n") %>
                        </div>

                        <% if (Model.AggregatedSetCount != 0)
                            { %>
                        <div class="KnowledgeBarWrapper">
                            <% Html.RenderPartial("~/Views/Categories/Detail/CategoryKnowledgeBar.ascx", new CategoryKnowledgeBarModel(Model.Category)); %>
                            <div class="KnowledgeBarLegend">Dein Wissensstand</div>
                        </div>
                        <% } %>
                    </div>

                    <div class="categoryTitle">
                        <h3><%: Model.Name %></h3>
                    </div>


                    <div class="categoryDescription">
                        <%= Model.Description %>
                    </div>

                    <div class="buttons">
                        <a href="<%= Links.CategoryDetail(Model.Category) %>" class="btn btn-primary">
                            <i class="fa fa-lg fa-search-plus">&nbsp;</i> Zur Themenseite
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>