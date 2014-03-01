$(function() {
    $("[popover-all-sets-for]").click(function (e) {

        e.preventDefault();

        var elem = $(this);

        if (elem.attr("loaded") == "true")
            return;
        
        $.post("/Api/Sets/ForQuestion", {
            "questionId": elem.attr("popover-all-sets-for")
        }, function (data) {

            elem.attr("loaded", "true");

            var content = "";
            for (var i = 5; i < data.length; i++) {
                content += "<a href='"+ data[i].Url +"'><span class='label label-set' style='display:block;'>" + data[i].Name +  "</span></a>&nbsp;";
            }

            content = "<div style=''>" + content + "</div>";

            elem.popover({
                title: 'weitere Frages&#228tze',
                html : true,
                content: content,
                trigger: 'click'
            });

            elem.popover('show');
        });
    });

    /*JULE NOGO AREA*/
    $("#logo").hover(
        function () { $(this).animate({ 'background-size': '140%' }, 250); },
        function () { $(this).animate({ 'background-size': '120%' }, 250); }
    );
    /*JULE NOGO END*/

    $(".sparklineTotals").each(function () {
        $(this).sparkline([parseInt($(this).attr("data-answersTrue")), parseInt($(this).attr("data-answersFalse"))], {
            type: 'pie',
            sliceColors: ['#3e7700', '#B13A48']
        });
    });

    $(".sparklineTotalsUser").each(function () {
        $(this).sparkline([parseInt($(this).attr("data-answersTrue")), parseInt($(this).attr("data-answersFalse"))], {
            type: 'pie',
            sliceColors: ['#3e7700', '#B13A48']
        });
    });

    new Menu();

});

class Menu {

    _isOpen: boolean;
    _animationInProgress: boolean;

    constructor() {
        this._isOpen = false;
        this._animationInProgress = false;

        $("#MenuButton").click(() => {
            if (this._animationInProgress)
                return;

            if (!this._isOpen) {
                this.openMenu();
            } else {
                this.closeMenu();
            }
        });

        //close on click outside the menu
        $(document).mouseup((e) => {
            if ($("#menu-new").has(e.target).length === 0 &&
                $("#MenuButton").has(e.target).length === 0) {
                this.closeMenu();
            }
        });

        //close on ESC
        $(document).keyup((e: any) => {
            if (e.keyCode == 27) {
                this.closeMenu();
            }
        });

    }

    openMenu() {
        this._animationInProgress = true;
        $("#menu-new").animate({ 'left': '0' }, 1000, "swing", () => {
            this._animationInProgress = false;
        });
        this._isOpen = true;
    }

    closeMenu() {
        this._animationInProgress = true;
        $("#menu-new").animate({ 'left': '-100%' }, 1000, "swing",() => {
                this._animationInProgress = false;
            });
        this._isOpen = false;
    }

}