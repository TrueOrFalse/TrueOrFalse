﻿class SetVideo {

    private fnOnChangeAnswerBody: () => void;

    private _questionCount : number;

    constructor(fnOnChangeAnswerBody : () => void) {

        this.fnOnChangeAnswerBody = fnOnChangeAnswerBody;

        this._questionCount = +$("#videoPages").attr("data-question-count");

        var self = this;

        $("a[data-video-question-id]").click(function (e) {
            self.LoadQuestionView(e, $(this));
        });

        $("#videoPreviousQuestion").click(function (e)  {
            e.preventDefault();

            if ($(this).hasClass("disabled"))
                return;

            var currentIndex = self.GetCurrentIndex();

            var menuItem = self.GetMenuItemByIndex(currentIndex - 1);;
            self.LoadQuestionView(e, menuItem);

        });

        $("#videoNextQuestion").click(function(e) {
            e.preventDefault();

            if ($(this).hasClass("disabled"))
                return;

            var currentIndex = self.GetCurrentIndex();

            var menuItem = self.GetMenuItemByIndex(currentIndex + 1);;
            self.LoadQuestionView(e, menuItem);
            
        });

        this.InitAnswerBody();
    }

    EnableDisablePagerArrows(currentIndex : number) {
        if (currentIndex === 1)
            $("#videoPreviousQuestion").addClass("disabled");
        else
            $("#videoPreviousQuestion").removeClass("disabled");

        if (currentIndex == this._questionCount)
            $("#videoNextQuestion").addClass("disabled");
        else
            $("#videoNextQuestion").removeClass("disabled");
    }

    LoadQuestionView(e: JQueryEventObject, menuItem: JQuery) {
        e.preventDefault();

        $("#video-pager")
            .find("[data-video-question-id]")
            .removeClass("current");

        menuItem
            .addClass("current")
            .children("i")
            .first()
            .removeClass("fa-circle-thin")
            .addClass("fa-circle");

        var questionId = menuItem.attr("data-video-question-id");

        var hideAddToWishknowledge = $("#hddHideAddToKnowledge").val();
        var urlSuffix = "";
        if (hideAddToWishknowledge == "True") {
            urlSuffix = "&hideAddToKnowledge=true";
        }

        $.get("/SetVideo/RenderAnswerBody/?questionId=" + questionId + urlSuffix,
            htmlResult => {
                AnswerQuestion.LogTimeForQuestionView();
                this.ChangeAnswerBody(htmlResult);
            });

        this.EnableDisablePagerArrows(+menuItem.attr("data-index"));
    }

    static ClickItem(questionId : number) {
        $("#video-pager a[data-video-question-id=" + questionId + "]").trigger("click");
    }

    ChangeAnswerBody(html: string) {
        $("#divBodyAnswer")
            .empty()
            .animate({ opacity: 0.00 }, 0)
            .append(html)
            .animate({ opacity: 1.00 }, 400);

        $(".show-tooltip").tooltip();
        this.InitAnswerBody();
    }

    InitAnswerBody() {

        var answerEntry = new AnswerEntry();
        answerEntry.Init();

        answerEntry.OnCorrectAnswer(() => { this.HandleCorrectAnswer(); });
        answerEntry.OnWrongAnswer(() => { this.HandleWrongAnswer(); });

        $('#hddTimeRecords').attr('data-time-on-load', $.now());

        Images.Init();

        this.fnOnChangeAnswerBody();
    }

    HandleCorrectAnswer() {
        this.GetCurrentMenuItem()
            .removeClass("wrongAnswer")
            .addClass("correctAnswer");
    }

    HandleWrongAnswer() {
        this.GetCurrentMenuItem()
            .removeClass("correctAnswer")
            .addClass("wrongAnswer");
    }

    GetCurrentMenuItem(): JQuery {
        return $("#video-pager").find("a.current").first();
    }

    GetCurrentIndex(): number {
        return +this.GetCurrentMenuItem().attr("data-index");
    }

    GetMenuItemByIndex(index : number) : JQuery {
        return $("#video-pager").find("a[data-index=" + index +"]").first();
    }
}