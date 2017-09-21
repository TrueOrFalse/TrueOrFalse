﻿class Tabbing {

    constructor() {

        $('#TabsBar .Tab').each(function () {

            var tab = $(this);
            var tabname = tab.attr('id');
            tab.click(function(e) {
                e.preventDefault();
                if (tab.hasClass('active')) return;
                if (!Tabbing.ContentIsPresent(tabname)) {
                    Tabbing.RenderTabContent(tabname);
                }

                Tabbing.ShowTab(tabname);
            });
        });
    }

    private static RenderTabContent(tabName: string): void {
        var url = "/Category/Tab/?tabName=" + tabName + "&categoryId=" + $("#hhdCategoryId").val();

        $.get(url, (html) => {

            $('#' + tabName + 'Content')
                .empty()
                .append(html);

            $("#TabContent .show-tooltip").tooltip();
        });
    }

    private static ContentIsPresent(tabName: string): boolean {

        return !($.trim($('#' + tabName + 'Content').html())=='');
    }

    private static ShowTab(tabName: string): void {

        $('.TabContent').hide();
        $('.Tab').removeClass('active');
        $('#' + tabName).addClass('active');
        $('#' + tabName + "Content").animate({ opacity: 0.00 }, 0).show().animate({ opacity: 1.00 }, 400);
    }

}

$(() => {
    new Pin(PinType.Category, KnowledgeBar.ReloadCategory);
    new Pin(PinType.Set, KnowledgeBar.ReloadCategory);
    new Tabbing();
});