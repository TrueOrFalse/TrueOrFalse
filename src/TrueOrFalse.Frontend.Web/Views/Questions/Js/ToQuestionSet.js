﻿var ToQuestionSetModal = (function () {
    function ToQuestionSetModal() {
        $('#btnSelectionToSet').click(function () {
            _page.ToQuestionSetModal.Show();
        });
    }
    ToQuestionSetModal.prototype.Show = function () {
        this.Populate();
        $('#modalToQuestionSet').modal('show');
    };
    ToQuestionSetModal.prototype.Populate = function () {
        $('#tqsTitle').html(_page.RowSelector.Rows.length + " Fragen zu Fragesatz hinzufügen");
        var setResult = GetQuestionSetsForUser.Run();
        this.Sets = setResult.Sets;
        $("#tqsSuccess").hide();
        $("#tqsSuccessFooter").hide();
        if(setResult.TotalSets == 0) {
            $("#tqsBody").hide();
            $("#tqsNoSetsBody").show(200);
            $("#tqsNoSetsFooter").show(200);
        } else {
            $("#tqsNoSetsBody").hide();
            $("#tqsNoSetsFooter").hide();
            $("#tqsBody").show(200);
            $("#tqsTextSelectSet").show();
            var template = $("#tsqRowTemplate");
            $("[data-questionSetId]").remove();
            for(var i = 0; i < setResult.Sets.length; i++) {
                var newRow = template.clone().removeAttr("id").removeClass("hide");
                newRow.attr("data-questionSetId", setResult.Sets[i].Id);
                newRow.html(newRow.html().replace("{Name}", setResult.Sets[i].Name));
                newRow.click(function () {
                    _page.ToQuestionSetModal.AddToSet($(this));
                });
                $("#tsqRowContainer").append(newRow);
            }
        }
    };
    ToQuestionSetModal.prototype.AddToSet = function (questionSetRow) {
        var id = parseInt(questionSetRow.attr("data-questionSetId"));
        var questionSet = _.filter(this.Sets, function (pSet) {
            return pSet.Id == id;
        });
        var text = _page.RowSelector.Rows.length + " Fragen zu '" + questionSet[0].Name + "' hinzufügen";
        SendQuestionsToAdd.Run();
        $("#tqsSuccess").show();
        $("#tqsSuccessFooter").show();
        $("#tqsBody").hide();
    };
    return ToQuestionSetModal;
})();
var QuestionSet = (function () {
    function QuestionSet(Id, Name) {
        this.Id = Id;
        this.Name = Name;
    }
    return QuestionSet;
})();
var GetQuestionSetsForUserResult = (function () {
    function GetQuestionSetsForUserResult() {
        this.TotalSets = 0;
        this.CurrentPage = 1;
        this.Sets = new Array();
    }
    return GetQuestionSetsForUserResult;
})();
var GetQuestionSetsForUser = (function () {
    function GetQuestionSetsForUser() { }
    GetQuestionSetsForUser.Run = function Run() {
        var result = new GetQuestionSetsForUserResult();
        $.ajax({
            type: 'POST',
            async: false,
            cache: false,
            url: "/Questions/GetQuestionSets/",
            error: function (error) {
                console.log(error);
            },
            success: function (r) {
                for(var i = 0; i < r.Sets.length; i++) {
                    result.TotalSets = r.Total;
                    result.CurrentPage = r.Total;
                    result.Sets.push(new QuestionSet(r.Sets[i].Id, r.Sets[i].Name));
                }
            }
        });
        return result;
    }
    return GetQuestionSetsForUser;
})();
var SendQuestionsToAddResult = (function () {
    function SendQuestionsToAddResult() {
        this.TotalSets = 0;
        this.CurrentPage = 1;
        this.Sets = new Array();
    }
    return SendQuestionsToAddResult;
})();
var SendQuestionsToAdd = (function () {
    function SendQuestionsToAdd() { }
    SendQuestionsToAdd.Run = function Run() {
        $.ajax({
            type: 'POST',
            async: false,
            cache: false,
            url: "/Questions/AddToQuestionSet/",
            data: "{ name: 'John', time: '2pm' }",
            error: function (error) {
                console.log(error);
            },
            success: function (r) {
            }
        });
        return new SendQuestionsToAddResult();
    }
    return SendQuestionsToAdd;
})();
