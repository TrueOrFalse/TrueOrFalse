﻿/// <reference path="../../../../Scripts/typescript.defs/jquery.d.ts" />

var validationSettings_BecomeMemberForm = {
    onkeyup: function(element, event) {
        if ($(element).hasClass('InputPrice')) {
            return false;
        } else {
            return true;
        }
    },
    submitHandler: function (form) {
        var chosenPriceString = $('#BecomeMemberForm')
            .find('input[name="PriceLevel"][type="radio"]:checked')
            .closest('.radio')
            .find('.InputPrice')
            .val();
        $('#ChosenPrice').val((Math.round(100 * parseFloat(chosenPriceString.replace(',', '.'))) / 100).toFixed(2)); 
        fnSetCurrentSelectedPrice();
        form.submit();
    },
    rules: {
        BillingName: {
            required: true
        }
    }
}

var fnAddNumberValidationMethod = function (inputField : JQuery, message : string = "") {

    fnAddGermanDecimalRule(
        function (value, element) { }, //OnSuccessCallback
        function (value, element) {//OnErrorCallback
            $(element).closest('.radio').find('.YearlyPrice').html(' --');
        }
    );

    var radioSection = inputField.closest('.radio');
    var suggestedPrice = inputField.val();
    var minValString = radioSection.find('.MinPrice').html();
    var minVal = Math.round(100 * parseFloat(minValString.replace(',', '.'))) / 100;
    var minValRuleName = inputField.attr('name');

    jQuery.validator.addMethod(
        minValRuleName,
        function (value, element) {

            if ($.trim(value) === "") {
                $(element).val(suggestedPrice);
                value = suggestedPrice;
            }

            var valueNumber = Math.round(100 * parseFloat(value.replace(',', '.'))) / 100;
            $(element).val(valueNumber.toFixed(2).replace('.', ','));
            $(element).closest('.radio').find('.YearlyPrice').html((12 * valueNumber).toFixed(2).replace('.', ','));

            fnSetCurrentSelectedPrice();

            if (minVal && valueNumber && radioSection.find('input[type="radio"]').is(':checked') && valueNumber < minVal) {
                return false;
            }
            else {
                return true;
            }
        },
        "Bitte gib einen Mindestbetrag von " + minValString + " € ein."
        );

    inputField.rules('add', 'GermanDecimal');

    inputField.rules('add', minValRuleName);
}

var fnSetCurrentSelectedPrice = function() {
    $('#hddSelectedPrice')
        .val($('[name="PriceLevel"]:checked')
        .closest($('.radio'))
        .find($('.InputPrice'))
        .val());
}

$(function () {

    var validator = fnValidateForm("#BecomeMemberForm", validationSettings_BecomeMemberForm, false);

    $(".InputPrice").validate({
        onkeyup: false,
    });

    $('input.InputPrice').each(function () {
        fnAddNumberValidationMethod($(this));

        $(this).focus(function () {
            $(this).removeClass('NotInFocus');
            $('input.InputPrice').not($(this)).addClass('NotInFocus');
            $('#PriceSelection input[type="radio"]').not($(this).closest('.radio').find('input[type="radio"]')).removeAttr('checked');
            $('#PriceSelection input[type="radio"]').removeAttr('checked');
            $(this).closest('.radio').find('input[type="radio"]').prop('checked', true);
            $(this).closest('.radio').find('input[type="radio"]').trigger('change');
        });
    });

    $('.PriceLevelInfo')
        .on('show.bs.collapse', function () {
            $(this).closest('.radio').find('.MoreLink i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
        })
        .on('hide.bs.collapse', function () {
            $(this).closest('.radio').find('.MoreLink i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
        });
    $('[name=PriceLevel]').change(function () {
        fnSetCurrentSelectedPrice();
        $('[name=PriceLevel]').not($(this)).closest('.radio').find('.PriceLevelInfo.in').collapse('hide');
        $(this).closest('.radio').find('.PriceLevelInfo:not(.in)').collapse('show');

        $(this).closest('.radio').find('.MoreLink i').removeClass('fa-chevron-down fa-chevron-up');

        $('input.InputPrice').not($(this).closest('.radio').find('.InputPrice')).addClass('NotInFocus');
        $(this).closest('.radio').find('.InputPrice').removeClass('NotInFocus');
    });

    fnSetCurrentSelectedPrice();
});