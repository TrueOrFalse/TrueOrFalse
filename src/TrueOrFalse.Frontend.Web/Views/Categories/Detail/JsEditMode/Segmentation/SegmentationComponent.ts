﻿interface Segment {
    CategoryId: Number,
    Title: String,
    ChildCategoryIds: Array<Number>,
};


var segmentationComponent = Vue.component('segmentation-component', {
    props: {
        categoryId: [String, Number],
        editMode: Boolean,
    },

    data() {
        return {
            baseCategoryList: [],
            customCategoryList: [] as Segment[],
            componentKey: 0,
            selectedCategoryId: null,
            isCustomSegment: false,
            hasCustomSegment: false,
            selectedCategories: [],
            id: 'SegmentationComponent',
            hover: false,
            showHover: false,
            addCategoryId: "AddToCurrentCategoryCard",
            dropdownId: "MainSegment-Dropdown",
            controlWishknowledge: false,
        };
    },

    created() {
    },

    mounted() {
        var self = this;
        this.hasCustomSegment = $('#CustomSegmentSection').html().length > 0;
        eventBus.$on('remove-segment', (id) => {
            self.addCategoryToBaseList(id);
        });
        eventBus.$on('remove-category-cards',
            ids => {
                ids.map(id => {
                    self.$refs['card' + id].visible = false;
                });
            });
    },

    watch: {
        hover(val) {
            if (val && this.editMode)
                this.showHover = true;
            else
                this.showHover = false;
        }
    },

    updated() {
    },

    methods: {
        loadSegment(id) {
            if (NotLoggedIn.Yes()) {
                NotLoggedIn.ShowErrorMsg("CreateSegment");
                return;
            }
            var self = this;
            var currentElement = $("#CustomSegmentSection");
            var data = { CategoryId: id }

            $.ajax({
                type: 'Post',
                contentType: "application/json",
                url: '/Segmentation/GetSegmentHtml',
                data: JSON.stringify(data),
                success: function(data) {
                    if (data) {
                        eventBus.$emit('content-change');
                        self.hasCustomSegment = true;
                        var inserted = currentElement.append(data.html);
                        var instance = new segmentComponent({
                            el: inserted.get(0)
                        });
                        self.$refs['card' + id].visible = false;
                        eventBus.$emit('save-segments');
                    } else {
                    };
                },
            });
        },
        addCategoryToBaseList(id) {
            $.ajax({
                type: 'Post',
                contentType: "application/json",
                url: '/Segmentation/GetCategoryCard',
                data: JSON.stringify({ categoryId: id }),
                success: function (data) {
                    if (data) {
                        eventBus.$emit('content-change');
                        var inserted = $(data.html).insertBefore('#AddToCurrentCategoryBtn');
                        var instance = new categoryCardComponent({
                            el: inserted.get(0)
                        });
                        eventBus.$emit('save-segments');
                    } else {

                    };
                },
            });
        },
        selectCategory(id) {
            if (this.selectedCategories.includes(id))
                return;
            else this.selectedCategories.push(id);
        },
        unselectCategory(id) {
            if (this.selectedCategories.includes(id)) {
                var index = this.selectedCategories.indexOf(id);
                this.selectedCategories.splice(index, 1);
            }
        },
        addCategory() {
            if (NotLoggedIn.Yes()) {
                NotLoggedIn.ShowErrorMsg("CreateCategory");
                return;
            }
            var self = this;
            var parent = {
                id: self.categoryId,
                addCategoryBtnId: $("#AddToCurrentCategoryBtn"),
                moveCategories: false,
            }
            $('#AddCategoryModal').data('parent', parent).modal('show');
        },
        removeChildren() {
            if (NotLoggedIn.Yes()) {
                NotLoggedIn.ShowErrorMsg("RemoveChildren");
                return;
            }
            var self = this;
            var data = {
                parentCategoryId: self.categoryId,
                childCategoryIds: self.selectedCategories,
            };
            $.ajax({
                type: 'Post',
                contentType: "application/json",
                url: '/EditCategory/RemoveChildren',
                data: JSON.stringify(data),
                success: function (data) {
                    eventBus.$emit('content-change');
                    self.selectedCategories.map(categoryId => {
                        self.$refs['card' + categoryId].visible = false;
                    });
                },
            });
        },
        moveToNewCategory() {
            if (NotLoggedIn.Yes()) {
                NotLoggedIn.ShowErrorMsg("MoveToNewCategory");
                return;
            }
            var self = this;
            var parent = {
                id: self.categoryId,
                addCategoryBtnId: $("#AddToCurrentCategoryBtn"),
                moveCategories: true,
                selectedCategories: self.selectedCategories,
            }
            $('#AddCategoryModal').data('parent', parent).modal('show');
        },
    },
});