/// <reference path="../../../../Scripts/typescript.defs/jquery.d.ts" />
/// <reference path="../../../../Scripts/typescript.defs/jqueryui.d.ts" />
/// <reference path="../../../../Scripts/typescript.defs/bootstrap.d.ts" />


class SolutionMetaDataMenu {

    _divMenu: JQuery;
    _divMenuItemText: JQuery;
    _divMenuItemNumber: JQuery;
    _divMenuItemDate: JQuery;

    _sliderDate: SliderDate;
    _spinnerNumberAccuracy: SpinnerNumberAccuracy;

    constructor () {

        this._sliderDate = new SliderDate();
        this._spinnerNumberAccuracy = new SpinnerNumberAccuracy();

        $("#btnMenuItemText").click(this.SelectText);
        $("#btnMenuItemText, #divMenuItemText").hover(
            function () { $("#divMenuItemText").show();},
            function () { $("#divMenuItemText").hide();}
        );

        $("#btnMenuItemNumber").click(this.SelectNumber);
        $("#btnMenuItemNumber, #divMenuItemNumber").hover(
            function () { $("#divMenuItemNumber").show();}, 
            function () { $("#divMenuItemNumber").hide();}
        )

        $("#btnMenuItemDate").click(this.SelectDate);
        $("#btnMenuItemDate, #divMenuItemDate").hover(
            function () { $("#divMenuItemDate").show();}, 
            function () { $("#divMenuItemDate").hide();}
        )
	}

    SelectText() 
    { 
        $("#btnMenuItemText").addClass("active")
        $("#btnMenuItemNumber").removeClass("active")
        $("#btnMenuItemDate").removeClass("active")
    }
    
    SelectNumber() 
    { 
        $("#btnMenuItemText").removeClass("active")
        $("#btnMenuItemNumber").addClass("active")
        $("#btnMenuItemDate").removeClass("active")
    }

    SelectDate() 
    { 
        $("#btnMenuItemText").removeClass("active")
        $("#btnMenuItemNumber").removeClass("active")
        $("#btnMenuItemDate").addClass("active")
    }
}

class SliderDate
{ 
    constructor() {
        var _this = this
        $("#sliderDate").slider({
            range: "min",
            max: 5,
            value: 3,
            slide: function (event, ui) { _this.SetUiSlider(ui.value); },
            change: function (event, ui) { _this.SetUiSlider(ui.value); }
        });
    }

    SetUiSlider(sliderValue) { 
        $("#spanSliderValue").text(sliderValue)
    }
}

class SpinnerNumberAccuracy
{ 
    constructor() {     
        $("#numberAccuracy").spinner({
          min: 0,
          max: 100,
          step: 1,
          start: 0
        });
    }
}

var solutionMetaData = new SolutionMetaDataMenu();

$('#help').click(function () {
    $("#modalHelpSolutionType").modal('show');
});
