﻿class SearchInTabs{

    _elemContainer: JQuery;
    _categories: Array<number> = [];
    _knowledgeFilter: KnowledgeFilter;

    _fnOnLoadPage: () => void = () => {};

    constructor(fnOnLoadPage?: () => void) {
        this._elemContainer = $("#JS-SearchResult");

        if(fnOnLoadPage != null)
            this._fnOnLoadPage = fnOnLoadPage;

        $('#btnSearch').click((e) => {
            e.preventDefault();
            this.SubmitSearch();
        });

        $("#txtSearch").typeWatch({
            callback: value => { this.SubmitSearch(); },
            wait: 500,
            highlight: true,
            captureLength: 0
        });

        $("#txtSearch").keypress(e => {
            if (e.keyCode === 13) {
                e.preventDefault();
            }
        });
    }

    SubmitSearch() {
        var me = this;
        this._elemContainer.html(
            "<div style='text-align:center; padding-top: 30px;'>" +
            "<i class='fa fa-spinner fa-spin'></i>" +
            "</div>");

        $.ajax({
            url: $('#txtSearch').attr("formUrl") + "Api",
            data: {
                searchTerm: $('#txtSearch').val(),
                categories: this._categories, 
                knowledgeFilter: JSON.stringify(this._knowledgeFilter) 
            },
            traditional: true,
            type: 'json',
            success: (data: SearchInTabsResult) => {
                this._elemContainer.html(data.Html);

                var tabAmount = data.TotalInResult.toString() + " von " + data.TotalInSystem.toString();
                if (data.TotalInResult === data.TotalInSystem) {
                    tabAmount = data.TotalInSystem.toString();
                }

                if (data.TotalInResult === 0)
                    $("#rowNoResults").show();
                else 
                    $("#rowNoResults").hide();

                Utils.SetElementValue("#resultCount2", data.TotalInResult.toString());
                Utils.SetElementValue("#resultCount", <any>(data.TotalInResult.toString() + " Treffer"));
                Utils.SetElementValue2($(".JS-Tabs")
                    .find(".JS-" + data.Tab)
                    .find("span.JS-Amount"), <any>tabAmount);

                $('.show-tooltip').tooltip();
                Images.Init();

                me._fnOnLoadPage();
            }
        });
    }
}

class KnowledgeFilter {
    Knowledge_Solid: boolean;
    Knowledge_ShouldConsolidate: boolean;
    Knowledge_ShouldLearn: boolean;
    Knowledge_None: boolean;
}