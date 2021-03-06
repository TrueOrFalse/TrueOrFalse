﻿$(() => {
    new Cms();
    new CmsCategoryNetworkNavigation();
});

declare var resultVar: any;

class Cms {

    constructor() {
        var self = this;
        $("#btnShowLooseCategories").on("click",
            e => {
                e.preventDefault();
                self.RenderLooseCategories();
            });

        $("#btnShowCategoriesWithNonAggregatedChildren").on("click",
            e => {
                e.preventDefault();
                self.RenderCategoriesWithNonAggregatedChildren();
            });

        $("#btnShowCategoriesInSeveralRootCategories").on("click",
            e => {
                e.preventDefault();
                self.RenderCategoriesInSeveralRootCategories();
            });
    }

    RenderLooseCategories() {
        $.ajax({
            type: 'POST',
            url: "/Maintenance/CmsRenderLooseCategories",
            cache: false,
            success: function (result) {
                $("#showLooseCategoriesResult").html(result);
            },
            error: function (result) {
                window.console.log(result);
                $("#showLooseCategoriesResult").html("<div class='alert alert-danger'>Ein Fehler ist aufgetreten.<br>" + result + "</div>");
            }
        });

    }

    RenderCategoriesWithNonAggregatedChildren() {
        $.ajax({
            type: 'POST',
            url: "/Maintenance/CmsRenderCategoriesWithNonAggregatedChildren",
            cache: false,
            success: function (result) {
                $("#showCategoriesWithNonAggregatedChildrenResult").html(result);
            },
            error: function (result) {
                window.console.log(result);
                resultVar = result;
                window.console.log(resultVar.responseText);
                $("#showCategoriesWithNonAggregatedChildrenResult").html("<div class='alert alert-danger'>Ein Fehler ist aufgetreten.<br>" + result + "</div>");
            }
        });
    }

    RenderCategoriesInSeveralRootCategories() {
        $.ajax({
            type: 'POST',
            url: "/Maintenance/CmsRenderCategoriesInSeveralRootCategories",
            cache: false,
            success: function (result) {
                $("#showCategoriesInSeveralRootCategoriesResult").html(result);
            },
            error: function (result) {
                window.console.log(result);
                resultVar = result;
                window.console.log(resultVar.responseText);
                $("#showCategoriesInSeveralRootCategoriesResult").html("<div class='alert alert-danger'>Ein Fehler ist aufgetreten.<br>" + result + "</div>");
            }
        });
    }
}