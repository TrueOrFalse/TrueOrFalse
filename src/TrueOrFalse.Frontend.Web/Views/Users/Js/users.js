﻿/// <reference path="../../../Scripts/typescript.defs/jquery.d.ts" />
function SubmitSearchUsers() {
    window.location.href = "/Nutzer/Suche/" + $('#txtSearch').val();
}

$(function () {
    $('#btnSearch').click(function () {
        SubmitSearchUsers();
    });

    $("#txtSearch").keypress(function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code === 13) {
            SubmitSearchUsers();
            e.preventDefault();
        }
    });
});
//# sourceMappingURL=users.js.map
