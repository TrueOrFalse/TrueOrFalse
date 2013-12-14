/// <reference path="../../../Scripts/typescript.defs/jquery.d.ts" />
/// <reference path="../../../Scripts/typescript.defs/bootstrap.d.ts" />

var setIdToDelete;
$(function () {
    $('a[href*=#modalDelete]').click(function () {
        setIdToDelete = $(this).attr("data-setId");
        populateDeleteCategory(setIdToDelete);
    });

    $('#btnCloseDelete').click(function () {
        $('#modalDelete').modal('hide');
    });

    $('#confirmDelete').click(function () {
        deleteCategory(setIdToDelete);
        $('#modalDelete').modal('hide');
    });
});

function populateDeleteCategory(setId) {
    $.ajax({
        type: 'POST',
        url: "/Questions/DeleteDetails/" + setId,
        cache: false,
        success: function (result) {
            $("#spanQuestionTitle").html(result.questionTitle.toString());
        },
        error: function () {
            alert("Ein Fehler ist aufgetreten");
        }
    });
}

function deleteCategory(setId) {
    $.ajax({
        type: 'POST',
        url: "/Questions/Delete/" + setId,
        cache: false,
        success: function () { window.location.reload(); },
        error: function (result) {
            console.log(result);
            alert("Ein Fehler ist aufgetreten");
        }
    });
}