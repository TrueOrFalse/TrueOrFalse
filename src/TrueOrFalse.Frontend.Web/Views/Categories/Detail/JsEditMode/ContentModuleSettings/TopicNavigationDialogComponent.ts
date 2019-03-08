﻿class TopicNavigationSettings {
    TemplateName: string = "";
    Title: string = "";
    Text: string = "";
    Load: string = "";
    Order: string = "";
}

Vue.component('topicnavigation-modal-component', {
    props: ['origMarkdown'],

    template: '#topicnavigation-settings-dialog-template',

    topicNavigationSettings: TopicNavigationSettings,

    data() {
        return {
            newMarkdown: '',
            parentId: '',
            title: '',
            text: '',
            load: '',
            order: '',
            sets: [],
            loadSets: [],
            orderSets: [],
            prevOrder: '',
            settingsHasChanged: false,
            newSetId: '',
            showSetInput: false,
            setOptions: {
                animation: 100,
                fallbackOnBody: true,
                filter: '.placeholder',
                preventOnFilter: false,
                onMove: this.onMove,
            },
        }
    },

    created() {
        var self = this;
        self.topicNavigationSettings = new TopicNavigationSettings();
    },

    mounted: function () {
        $('#topicnavigationSettingsDialog').on('show.bs.modal',
            event => {
                this.newMarkdown = $('#topicnavigationSettingsDialog').data('parent').markdown;
                this.parentId = $('#topicnavigationSettingsDialog').data('parent').id;
                this.initializeData();

            });

        $('#topicnavigationSettingsDialog').on('hidden.bs.modal',
            event => {
            if (!this.settingsHasChanged)
                eventBus.$emit('close-content-module-settings-modal', false);
            this.clearData();
        });
    },

    computed: {
        showSetList: function () {
            if (this.load == 'All' && this.order == 'ManualSort') {
                this.sets = this.orderSets;
                return true;
            } else if (this.load != 'All') {
                this.sets = this.loadSets;
                return true;
            }
        },
    },

    watch: {
        newMarkdown: function () {
            this.settingsHasChanged = true;
        },
        order: function(newVal, oldVal) {
            this.prevOrder = oldVal;
        },
        load: function(val) {
            if (val == 'Custom' && this.order == 'ManualSort')
                this.order = this.prevOrder;
        },
    },

    methods: {
        clearData() {
            this.newMarkdown = '';
            this.parentId = '';
            this.sets = [];
            this.settingsHasChanged = false;
            this.title = '';
            this.text = '';
            this.load = '';
            this.order = '';
            this.newSetId = '';
            this.showSetInput = false;
        },

        initializeData() {
            this.topicNavigationSettings = Utils.ConvertEncodedHtmlToJson(this.newMarkdown);

            if (this.topicNavigationSettings.Title)
                this.title = this.topicNavigationSettings.Title;
            if (this.topicNavigationSettings.Text)
                this.text = this.topicNavigationSettings.Text;
            if (this.topicNavigationSettings.Load) {
                if (this.topicNavigationSettings.Load != 'All') {
                    this.loadSets = this.topicNavigationSettings.Load.split(',');
                    this.load = 'Custom';
                } else {
                    this.load = this.topicNavigationSettings.Load;
                };
            }

            if (this.topicNavigationSettings.Order) {
                if (this.topicNavigationSettings.Order != 'Name' &&
                    this.topicNavigationSettings.Order != 'QuestionAmount') {
                    this.order = 'ManualSort';
                    this.orderSets = this.topicNavigationSettings.Order.split(',');
                } else {
                    this.order = this.topicNavigationSettings.Order;
                };
            }
        },

        addSet(val) {
            this.sets.push(val);
            this.newSetId = '';
        },

        hideSetInput() {
            this.newSetId = '';
            this.showSetInput = false;
        },

        removeSet(index) {
            this.sets.splice(index, 1);
        },

        applyNewMarkdown() {
            
            this.topicNavigationSettings.Title = this.title;
            this.topicNavigationSettings.Text = this.text;
            this.topicNavigationSettings.Load = this.load;

            const setIdParts = $(".setCards").map((idx, elem) => $(elem).attr("setId")).get();
            if (setIdParts.length >= 1) {
                if (this.load != 'All') {
                    this.topicNavigationSettings.Load = setIdParts.join(',');
                } else if (this.order == 'ManualSort') {
                    this.topicNavigationSettings.Order = setIdParts.join(',');
                }
            }

            this.newMarkdown = Utils.ConvertJsonToMarkdown(this.topicNavigationSettings);
            console.log(this.topicNavigationSettings);
            console.log(this.newMarkdown);
            Utils.UpdateMarkdown(this.newMarkdown, this.parentId);
            $('#topicnavigationSettingsDialog').modal('hide');
        },

        closeModal() {
            $('#topicnavigationSettingsDialog').modal('hide');
        },
    },
});

