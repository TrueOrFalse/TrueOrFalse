﻿var addCategoryComponent = Vue.component('add-category-component', {
    data() {
        return {
            name: "",
            private: false,
            errorMsg: "",
            parentId: null,
            existingCategoryName: "",
            existingCategoryUrl: "",
            showErrorMsg: false,
            disabled: false,
            addCategoryBtnId: null,
            disableAddCategory: true,
            selectedCategories: [],
            moveCategories: false,
        };
    },
    watch: {
        name(val) {
            if (val.length <= 0)
                this.disableAddCategory = true;
            else
                this.disableAddCategory = false;
        }
    },
    created() {
    },
    mounted() {
        $('#AddCategoryModal').on('show.bs.modal',
            event => {
                this.parentId = $('#AddCategoryModal').data('parent').id;
                this.addCategoryBtnId = $('#AddCategoryModal').data('parent').addCategoryBtnId;
                this.moveCategories = $('#AddCategoryModal').data('parent').moveCategories;
                if (this.moveCategories)
                    this.selectedCategories = $('#AddCategoryModal').data('parent').selectedCategories;
                if ($('#AddCategoryModal').data('parent').redirect != null &&
                    $('#AddCategoryModal').data('parent').redirect)
                    this.redirect = true;
            });

        $('#AddCategoryModal').on('hidden.bs.modal',
            event => {
                this.clearData();
            });
    },
    methods: {
        clearData() {
            this.name = "";
            this.private = false;
            this.errorMsg = "";
            this.showErrorMsg = false;
            this.parentId = null;
            this.existingCategoryName = "";
            this.existingCategoryUrl = "";
            this.selectedCategories = [];
            this.moveCategories = false;
            this.redirect = false;
        },
        closeModal() {
            $('#AddCategoryModal').modal('hide');
        },

        //validateName() {
        //    var self = this;
        //    $.ajax({
        //        type: 'Post',
        //        contentType: "application/json",
        //        url: '/EditCategory/ValidateName',
        //        data: JSON.stringify({ name: self.name }),
        //        success: function (data) {
        //            if (data.categoryNameAllowed) {
        //            } else {
        //                self.errorMsg = data.errorMsg;
        //                self.existingCategoryName = data.name;
        //                self.existingCategoryUrl = data.url;
        //                self.showErrorMsg = true;
        //            };
        //        },
        //    });
        //},
        addCategory() {
            var self = this;
            var url;
            var categoryData;
            if (this.moveCategories) {
                categoryData = {
                    name: self.name,
                    parentCategoryId: self.parentId,
                    childCategoryIds: self.selectedCategories,
                }
                url = '/EditCategory/QuickCreateWithCategories';

            } else {
                categoryData = {
                    name: self.name,
                    parentCategoryId: self.parentId
                }
                url = '/EditCategory/QuickCreate';
            }

            $.ajax({
                type: 'Post',
                contentType: "application/json",
                url: '/EditCategory/ValidateName',
                data: JSON.stringify({ name: self.name }),
                success: function (data) {
                    if (data.categoryNameAllowed) {
                        $.ajax({
                            type: 'Post',
                            contentType: "application/json",
                            url: url,
                            data: JSON.stringify(categoryData),
                            success: function (data) {
                                if (data.success) {
                                    if (self.redirect)
                                        window.open(data.url, '_self');
                                    if (self.addCategoryBtnId != null)
                                        self.loadCategoryCard(data.id);
                                    if (self.moveCategories)
                                        eventBus.$emit('remove-category-cards', self.selectedCategories);
                                    else
                                        $('#AddCategoryModal').modal('hide');
                                } else {
                                };
                            },
                        });
                    } else {
                        self.errorMsg = data.errorMsg;
                        self.existingCategoryName = data.name;
                        self.existingCategoryUrl = data.url;
                        self.showErrorMsg = true;
                    };
                },
            });
        },
        loadCategoryCard(id) {
            var self = this;

            $.ajax({
                type: 'Post',
                contentType: "application/json",
                url: '/Segmentation/GetCategoryCard',
                data: JSON.stringify({ categoryId: id }),
                success: function (data) {
                    if (data) {
                        var inserted = $(data.html).insertBefore(self.addCategoryBtnId);
                        var instance = new categoryCardComponent({
                            el: inserted.get(0),
                            props: {
                                editMode: true,
                            },
                        });
                        $('#AddCategoryModal').modal('hide');
                    } else {

                    };
                },
            });
        },
    }
});


var AddCategoryApp = new Vue({
    el: '#AddCategoryApp',
});