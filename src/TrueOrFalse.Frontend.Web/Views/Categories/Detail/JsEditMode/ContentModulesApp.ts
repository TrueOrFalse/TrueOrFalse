﻿declare var Vue: any;
declare var VueTextareaAutosize: any;
declare var VueSelect: any;
declare var Sticky: any;
declare var Sortable: any;
declare var tiptapBuild: any;
declare var hljsBuild: any;

Vue.component('v-select', VueSelect.VueSelect);

declare var eventBus: any;
if (eventBus == null)
    var eventBus = new Vue();

Vue.directive('sortable',
    {
        inserted(el, binding) {
            new Sortable(el, binding.value, 
                {
                    onUpdate: function() {
                        eventBus.$emit('sortable-update');
                    }
                });
        },
    });

new Vue({
    el: '#ContentModuleApp',
    data() {
        return {
            options: {
                handle: '.Handle',
                animation: 100,
                fallbackOnBody: true,
                filter: '.placeholder',
                preventOnFilter: false,
                onMove: this.onMove,
                onUpdate: () => {
                    this.updateModuleOrder();
                    this.changedContent = true;
                },
                axis: 'y'
            },
            saveSuccess: false,
            saveMessage: '',
            editMode: true,
            showTopAlert: false,
            previewModule: null,
            changedContent: false,
            footerIsVisible: '',
            awaitInlineTextId: false,
            moduleOrder: [],
            modules: [],
            sortedModules: [],
            fabIsOpen: false,
            segments: [],
            categoryId: null,
        };
    },

    created() {
        var self = this;
        self.categoryId = parseInt($("#hhdCategoryId").val());
        eventBus.$on('get-module',
            (module) => {
                var index = this.modules.findIndex((m) => m.id == module.id);
                if (index >= 0)
                    this.modules[index] = module;
                else
                    this.modules.push(module);
            });
        eventBus.$on("set-edit-mode",
            (state) => {
                this.editMode = state;
                if (this.changedContent && !this.editMode) {
                    //Utils.ShowSpinner();
                    //location.reload();
                    eventBus.$emit('cancel-edit-mode');
                }
            });
        eventBus.$on('update-content-module',
            (event) => {
                if (event.preview == true) {
                    const previewHtml = event.newHtml;
                    const moduleToReplace = event.toReplace;
                    var inserted = $(previewHtml).insertAfter(moduleToReplace);
                    new contentModuleComponent({
                        el: inserted.get(0)
                    });
                    eventBus.$emit('close-content-module-settings-modal', event.preview);
                    eventBus.$emit('set-edit-mode', true);
                };
            });
        eventBus.$on('new-content-module',
            (result) => {
                if (result) {
                    if (result.position == 'before') {}
                        var inserted = $(result.newHtml).insertBefore(result.id);
                    if (result.position == 'after')
                        var inserted = $(result.newHtml).insertAfter(result.id);
                    var instance = new contentModuleComponent({
                        el: inserted.get(0)
                    });
                    eventBus.$emit('set-edit-mode', true);
                    eventBus.$emit('set-new-content-module', this.editMode);
                    this.updateModuleOrder();
                    this.sortModules();
                };
            });

        window.addEventListener('scroll', this.footerCheck);
        window.addEventListener('resize', this.footerCheck);
        eventBus.$on('content-change',
            () => {
                if (this.editMode) {
                    this.changedContent = true;
                    //_.debounce(() => {
                    //        self.saveContent();
                    //    },
                    //    300);
                }
            });

        eventBus.$on('request-save', () => this.saveContent());
        eventBus.$on('new-segment', (segment) => {
            this.segments.push(segment);
        });
    },
    destroyed() {
        window.removeEventListener('scroll', this.handleScroll);
        window.removeEventListener('resize', this.footerCheck);
    },

    mounted() {
        this.changedContent = false;
        if ((this.$el.clientHeight + 450) < window.innerHeight)
            this.footerIsVisible = true;
        eventBus.$emit('content-is-ready');
        eventBus.$on('remove-segment',
            (categoryId) => {
                var index = this.segments.map(s => s.CategoryId).indexOf(categoryId);
                this.segments.splice(index, 1);
            });
        eventBus.$on('save-segments', () => this.saveSegments());
        this.sortModules();
    },

    updated() {
        this.footerCheck();
    },

    watch: {
        editMode(val) {
            if (val) {
                this.updateModuleOrder();
                this.sortModules();
                $('#EditCategoryBreadcrumbChip').addClass('show');
            } else
                $('#EditCategoryBreadcrumbChip').removeClass('show');
        },
    },


    methods: {

        updateModuleOrder() {
            this.moduleOrder = $(".inlinetext, .topicnavigation").map((idx, elem) => $(elem).attr("uid")).get();
        },

        footerCheck() {
            const elFooter = document.getElementById('CategoryFooter');

            if (elFooter) {
                var rect = elFooter.getBoundingClientRect();
                var viewHeight = Math.max(document.documentElement.clientHeight, window.innerHeight);
                if (rect.top - viewHeight >= 0 || rect.bottom < 0)
                    this.footerIsVisible = false;
                else
                    this.footerIsVisible = true;
            };
        },

        cancelEditMode() {
            if (!this.editMode)
                return;

            this.editMode = false;
            eventBus.$emit('cancel-edit-mode');
            //if (this.changedContent)
            //    location.reload();
        },

        sortModules() {
            var items = this.modules;
            var sorting = this.moduleOrder;
            var result = [];

            sorting.forEach(function(key) {
                var found = false;
                items = items.filter(function(item) {
                    if (!found && item.id == key) {
                        result.push(item.contentData);
                        found = true;
                        return false;
                    } else
                        return true;
                });
            });

            this.sortedModules = result;
            if ((result.length == 0 || result[result.length - 1].TemplateName != 'InlineText') && (items.length == 0 || items[items.length - 1].contentData.TemplateName != 'InlineText'))
                eventBus.$emit('add-inline-text-module');
            return;
        },

        removeAlert() {
            this.saveMessage = '';
            this.saveSuccess = false;
            this.showTopAlert = false;
        },

        onMove(event) {
            return event.related.id !== 'ContentModulePlaceholder';;
        },

        async saveContent() {
            var self = this;
            if (NotLoggedIn.Yes()) {
                return;
            }
            if (!this.editMode)
                return;

            this.updateModuleOrder();
            await this.sortModules();

            this.saveSegments();

            var filteredModules = this.sortedModules.filter(o => (o.TemplateName != 'InlineText' || o.Content));
            var data = {
                categoryId: self.categoryId,
                content: filteredModules,
            }
            $.ajax({
                type: 'post',
                contentType: "application/json",
                url: '/Category/SaveCategoryContent',
                data: JSON.stringify(data),
                success: function (success) {
                    if (success == true) {
                        this.saveSuccess = true;
                        this.saveMessage = "Das Thema wurde gespeichert.";
                        //if (window.location.href.endsWith('?openEditMode=True'))
                        //    location.href = window.location.href.slice(0, -18);
                        //else location.reload();
                    } else {
                        this.saveSuccess = false;
                        this.saveMessage = "Das Speichern schlug fehl.";
                    };
                },
            });
        },

        saveSegments() {
            if (NotLoggedIn.Yes()) {
                return;
            }
            var self = this;
            var segmentation = [];

            $("#CustomSegmentSection > .segment").each((index, el) => {

                var segment;

                if ($(el).data('child-category-ids').length > 0)
                    segment = {
                        CategoryId: $(el).data('category-id'),
                        ChildCategoryIds: $(el).data('child-category-ids')
                    }
                else
                    segment = {
                        CategoryId: $(el).data('category-id'),
                    }

                segmentation.push(segment);
            });

            var data = {
                categoryId: self.categoryId,
                segmentation: segmentation
            }
            $.ajax({
                type: 'post',
                contentType: "application/json",
                url: '/Category/SaveSegments',
                data: JSON.stringify(data),
                success: function (success) {
                    if (success == true) {
                        this.saveSuccess = true;
                        this.saveMessage = "Das Thema wurde gespeichert.";
                    } else {
                        this.saveSuccess = false;
                        this.saveMessage = "Das Speichern schlug fehl.";
                    };
                },
            });
        }
    },
});