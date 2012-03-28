﻿function escape_regexp(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
}

$.expr[':'].textEquals = function (a, i, m) {
    return $(a).text().match(new RegExp("^" + escape_regexp(m[3]) + "$", "i")) != null;
};

$(function () {

    var addingUserId;

    $("#txtAddUserFilter").autocomplete({
        minLength: 0,
        source: '/Api/User/ByName',
        focus: function (event, ui) {
            $("#txtAddUserFilter").val(ui.item.name);
            addingUserId = ui.item.id;
            return false;
        },
        select: function (event, ui) {
            $("#txtAddUserFilter").val(ui.item.name);
            addingUserId = ui.item.id;
            return false;
        }
    }).data("autocomplete")._renderItem = function (ul, item) {
        return $("<li></li>")
				.data("item.autocomplete", item)
				.append("<a><span class='usr-name'>" + item.name + "</span><br><i>" + item.numberOfQuestions + " Fragen</i></a>")
				.appendTo(ul);
    };

    function addUser() {
        var userName = $("#txtAddUserFilter").val();
        var usrId = addingUserId;
        $("#txtAddUserFilter").before(
            "<div class='added-usr' id='usr-" + usrId + "' style='display: none;'>" + userName +
                "<input type='hidden' value='" + usrId + "' name='usr-" + usrId + "'/>" +
                    "<a href='#' id='delete-usr-" + usrId + "'><img alt='' src='/Images/Buttons/cross.png' /></a>" +
                        "</div> ");
        $("#txtAddUserFilter").val('');
        $("#delete-usr-" + usrId).click(function () {
            $("#usr-" + usrId).stop(true).animate({ opacity: 0 }, 250, function () {
                $(this).hide("blind", { direction: "horizontal" }, function () {
                    $(this).remove();
                });
            });
        });
        $("#usr-" + addingUserId).show("blind", { direction: "horizontal" });
    }

    $("#addUserFilter").click(addUser);
});