﻿var Comments = (function () {
    function Comments() {
        var _this = this;
        var self = this;
        $("#btnSaveComment").click(function (e) {
            return _this.SaveComment(e);
        });
        $(".btnAnswerComment").click(function (e) {
            self.ShowAddAnswer(e, this);
        });
    }
    Comments.prototype.SaveComment = function (e) {
        e.preventDefault();

        var params = {
            questionId: window.questionId,
            text: $("#txtNewComment").val()
        };

        var txtNewComment = $("#txtNewComment");
        $("#saveCommentSpinner").show();
        txtNewComment.hide();

        $.post("/AnswerComments/SaveComment", params, function (data) {
            $("#comments").append(data);

            txtNewComment.attr("placeholder", "Dein Kommentar wurde gespeichert.");
            txtNewComment.val("");
            $("#saveCommentSpinner").hide();
            txtNewComment.show();
        });
    };

    Comments.prototype.ShowAddAnswer = function (e, buttonElem) {
        e.preventDefault();

        var self = this;
        buttonElem = $(buttonElem);

        $.post("/AnswerComments/GetAnswerHtml", function (data) {
            var html = $(data);
            var btnSaveAnswer = $(html.find(".saveAnswer")[0]);
            var parentContainer = $($(buttonElem).parents(".panel")[0]);

            var answerRow = $(buttonElem.parents(".panel-body")[0]);
            answerRow.remove();

            btnSaveAnswer.click(function (e) {
                self.SaveAnswer(e, parentContainer, html, buttonElem.data("comment-id"), answerRow);
            });
            parentContainer.append(html);
        });
    };

    Comments.prototype.SaveAnswer = function (e, parentContainer, divAnswerEdit, commentId, answerRow) {
        e.preventDefault();
        var self = this;

        var params = {
            commentId: commentId,
            text: $(divAnswerEdit.find("textarea")[0]).val()
        };

        divAnswerEdit.remove();

        var progress = $("<div class='panel-body' style='position: relative;'>" + "<div class='col-lg-offset-2 col-lg-10' style='height: 50px;'>" + "<i class='fa fa-spinner fa-spin'></i>" + "</div>" + "</div>");

        parentContainer.append(progress);

        $.post("/AnswerComments/SaveAnswer", params, function (data) {
            progress.hide();
            parentContainer.append(data);
            parentContainer.append(answerRow);
            answerRow.find(".btnAnswerComment").click(function (e2) {
                self.ShowAddAnswer(e2, this);
            });
        });
    };
    return Comments;
})();

$(function () {
    new Comments();
});
//# sourceMappingURL=Comments.js.map
