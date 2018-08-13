﻿$(window).scroll(function (event) {
    var position = $(this).scrollTop();
    var header = document.getElementById("Breadcrumb");
    var positionSticky = window.getComputedStyle(header).getPropertyValue("position");

    if (position > 80) {

        $('#BreadcrumbLogoSmall').show();
        $('#StickyHeaderContainer').css('display', 'flex');
        $('#Breadcrumb').css('top', '0px');
        $('#Breadcrumb').css('position', 'sticky');
        $('#Breadcrumb').addClass('ShowBreadcrumb');
        $('#RightMainMenu').css('position', 'fixed');
        ResizeBreadcrumb();

        if (positionSticky != "sticky") {
                    header.classList.add("sticky");
        }
       

    } else {
        $('#BreadcrumbLogoSmall').hide();
        $('#StickyHeaderContainer').hide();
        $('#Breadcrumb').css('top', '80px');
        $('#Breadcrumb').css('position', 'unset');
        $('#Breadcrumb').removeClass('ShowBreadcrumb');
        $('#RightMainMenu').css('position', 'absolute');
        ResizeBreadcrumb();
    }

    ReorientateMenu();

});

function ReorientateMenu() {
 var position = $(this).scrollTop();

    if (position > 80) {

        $('#RightMainMenu').css('margin-right', $('#BreadCrumbContainer').css('margin-right'));
        $('#DropdownMenu').css('margin-right', $('#BreadCrumbContainer').css('margin-right'));
    } else {
        $('#RightMainMenu').css('margin-right', '');
        $('#DropdownMenu').css('margin-right', '');
    }
}