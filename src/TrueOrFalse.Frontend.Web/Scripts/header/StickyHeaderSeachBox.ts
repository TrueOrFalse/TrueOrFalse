﻿var isOpen = false;
var isSmallHeaderSearchBoxOpen = false;

function SearchButtonClick() {

    var SearchButton = document.getElementById('StickyHeaderSearchButton');
    var inputBox = document.getElementById('StickyHeaderSearchBox');
    var searchBox = document.getElementById('StickyHeaderSearchBoxDiv');

    var SmallHeaderSearchButton = document.getElementById('SmallHeaderSearchButton');
    var SmallHeaderInputBox = document.getElementById('SmallHeaderSearchBox');
    var SmallHeaderSearchBox = document.getElementById('SmallHeaderSearchBoxDiv');


    if (isOpen == false) {
        searchBox.style.width = '262.41px';
        inputBox.style.padding = '6px 12px';
        isOpen = true;
    } else {
        searchBox.style.width = '48px';
        inputBox.style.padding = '0px';
        isOpen = false;
    }

    if (isSmallHeaderSearchBoxOpen == false) {
         SmallHeaderSearchBox.style.width = '262.41px';
         SmallHeaderInputBox.style.padding = '6px 12px';
        isSmallHeaderSearchBoxOpen = true;
    } else {
         SmallHeaderSearchBox.style.width = '48px';
        SmallHeaderInputBox.style.padding = '0px';
        isSmallHeaderSearchBoxOpen = false;
    }

    $(document).mouseup((e) => {
        if ($("#StickyHeaderSearchBox, #StickyHeaderSearchBoxDiv").has(e.target).length === 0 &&
            $("#StickyHeaderSearchButton").has(e.target).length === 0) {
            if (isOpen == true) {
                searchBox.style.width = '48px';
                inputBox.style.padding = '0px';
                isOpen = false;
            }
        }
        if ($("#SmallHeaderSearchBox, #SmallHeaderSearchBoxDiv").has(e.target).length === 0 &&
            $("#SmallHeaderSearchButton").has(e.target).length === 0) {

            if (isOpen == true) {
                if (isSmallHeaderSearchBoxOpen == true) {
                    SmallHeaderSearchBox.style.width = '48px';
                    SmallHeaderInputBox.style.padding = '0px';
                    isSmallHeaderSearchBoxOpen = false;
                }
            }
        }
    });

}

