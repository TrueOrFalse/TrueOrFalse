﻿class CardsSettings {
    TemplateName: string = "";
    Title: string = "";
    CardOrientation: string = "";
    SetListIds: string = "";
}

Vue.component('cards-modal-component', {

    template: '#cards-settings-dialog-template',

    cardsSettings: CardsSettings,

    data() {
        return {
            newMarkdown: '',
            title: '',
            selectedCardOrientation: 'Landscape',
            sets: [],
            newSetId: 0,
            parentId: '',
            vertical: false,
            settingsHasChanged: false,
            showSetInput: false,
            cardOptions: {
                animation: 100,
                fallbackOnBody: true,
                filter: '.placeholder',
                preventOnFilter: false,
                onMove: this.onMove,
            },
        };
    },

    created() {
        var self = this;
        self.cardsSettings = new CardsSettings();
    },

    watch: {
        selectedCardOrientation: function(val) {
            if (val == 'Portrait')
                this.vertical = true;
            else this.vertical = false;
        },

        newMarkdown: function() {
            this.settingsHasChanged = true;
        },
    },
    
    mounted: function() {
        $('#cardsSettingsDialog').on('show.bs.modal',
            event => {
                
                this.newMarkdown = $('#cardsSettingsDialog').data('parent').markdown;
                this.parentId = $('#cardsSettingsDialog').data('parent').id;
                this.initializeData();
            });

        $('#cardsSettingsDialog').on('hidden.bs.modal',
            event => {
                if (!this.settingsHasChanged)
                    eventBus.$emit('close-content-module-settings-modal', false);
                this.clearData();
            });
    },

    methods: {
        clearData() {
            this.newMarkdown = '';
            this.parentId = '';
            this.sets = [];
            this.settingsHasChanged = false;
            this.title = '';
            this.selectedCardOrientation = 'Landscape';
            this.newSetId = '';
            this.showSetInput = false;
        },

        initializeData() {
            this.cardsSettings = Utils.ConvertEncodedHtmlToJson(this.newMarkdown);

            if (this.cardsSettings.Title)
                this.title = this.cardsSettings.Title;
            if (this.cardsSettings.CardOrientation)
                this.selectedCardOrientation = this.cardsSettings.CardOrientation;
            if (this.cardsSettings.SetListIds.length)
                this.sets = this.cardsSettings.SetListIds.split(',');
        },

        hideSetInput() {
            this.newSetId = '';
            this.showSetInput = false;
        },
    
        addCard(val) {
            this.sets.push(val);
            this.newSetId = '';
        },
        removeSet(index) {
            this.sets.splice(index, 1);
        },

        applyNewMarkdown() {
            const setIdParts = $(".cardsDialogData").map((idx, elem) => $(elem).attr("setId")).get();
            if (setIdParts.length >= 1)
                this.cardsSettings.SetListIds = setIdParts.join(',');
            this.cardsSettings.Title = this.title;
            this.cardsSettings.CardOrientation = this.selectedCardOrientation;
            this.newMarkdown = Utils.ConvertJsonToMarkdown(this.cardsSettings);
            Utils.ApplyMarkdown(this.newMarkdown, this.parentId);
            $('#cardsSettingsDialog').modal('hide');
        },

        closeModal() {
            $('#cardsSettingsDialog').modal('hide');
        },

        onMove(event) {
            return event.related.id !== 'addCardPlaceholder';;
        },
    },
});

