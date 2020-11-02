﻿
<add-question-component inline-template>
    <div>
        <div id="AddQuestionHeader">
            <div>Frage hinzufügen <span>(Karteikarte)</span></div>
            <div>erweiterte Optionen</div>
        </div>
        <div id="AddQuestionBody">
            <div id="AddQuestionFormContainer">
                <div>
                    <editor-menu-bar :editor="questionEditor" v-slot="{ commands, isActive, focused }">
                        <div class="menubar is-hidden" :class="{ 'is-focused': focused }">
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.bold() }" @click="commands.bold">
                            <i class="fas fa-bold"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.italic() }" @click="commands.italic" >
                            <i class="fas fa-italic"></i>
                        </button>
                        
                        <button class="menubar__button":class="{ 'is-active': isActive.strike() }"@click="commands.strike">
                            <i class="fas fa-strikethrough"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.underline() }" @click="commands.underline">
                            <i class="fas fa-underline"></i>
                        </button>
                          
                        <button class="menubar__button" :class="{ 'is-active': isActive.paragraph() }" @click="commands.paragraph">
                            <i class="fas fa-paragraph"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.bullet_list() }" @click="commands.bullet_list">
                          <i class="fas fa-list-ul"></i>
                        </button>
                        
                         <button class="menubar__button" :class="{ 'is-active': isActive.ordered_list() }" @click="commands.ordered_list" >
                          <i class="fas fa-list-ol"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.blockquote() }" @click="commands.blockquote" >
                          <i class="fas fa-quote-right"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.code() }" @click="commands.code" >
                            <i class="far fa-file-code"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.code_block() }" @click="commands.code_block" >
                          <i class="fas fa-file-code"></i>
                        </button>

                        <button class="menubar__button" @click="commands.undo" >
                            <i class="fas fa-undo-alt"></i>
                        </button>
                        
                        <button class="menubar__button" @click="commands.redo" >
                            <i class="fas fa-redo-alt"></i>
                        </button>
                        
                    </div>
                    </editor-menu-bar>
                    
                    <editor-content :editor="questionEditor" />
                </div>
                <div>
                    <editor-menu-bar :editor="answerEditor" v-slot="{ commands, isActive, focused }">
                        <div class="menubar is-hidden" :class="{ 'is-focused': focused }">
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.bold() }" @click="commands.bold">
                            <i class="fas fa-bold"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.italic() }" @click="commands.italic" >
                            <i class="fas fa-italic"></i>
                        </button>
                        
                        <button class="menubar__button":class="{ 'is-active': isActive.strike() }"@click="commands.strike">
                            <i class="fas fa-strikethrough"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.underline() }" @click="commands.underline">
                            <i class="fas fa-underline"></i>
                        </button>
                          
                        <button class="menubar__button" :class="{ 'is-active': isActive.paragraph() }" @click="commands.paragraph">
                            <i class="fas fa-paragraph"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.bullet_list() }" @click="commands.bullet_list">
                          <i class="fas fa-list-ul"></i>
                        </button>
                        
                         <button class="menubar__button" :class="{ 'is-active': isActive.ordered_list() }" @click="commands.ordered_list" >
                          <i class="fas fa-list-ol"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.blockquote() }" @click="commands.blockquote" >
                          <i class="fas fa-quote-right"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.code() }" @click="commands.code" >
                            <i class="far fa-file-code"></i>
                        </button>
                        
                        <button class="menubar__button" :class="{ 'is-active': isActive.code_block() }" @click="commands.code_block" >
                          <i class="fas fa-file-code"></i>
                        </button>

                        <button class="menubar__button" @click="commands.undo" >
                            <i class="fas fa-undo-alt"></i>
                        </button>
                        
                        <button class="menubar__button" @click="commands.redo" >
                            <i class="fas fa-redo-alt"></i>
                        </button>
                        
                    </div>
                    </editor-menu-bar>
                    <editor-content :editor="answerEditor" />
                </div>
                <div>
                </div>
            </div>
            <div id="AddQuestionPrivacyContainer">
                Sichtbarkeit <i class="fas fa-question-circle"></i>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="publicQuestion" id="publicQuestionRadio" value="0">
                    <label class="form-check-label" for="publicQuestion">
                        Öffentliche Frage
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="privateQuestion" id="privateQuestionRadio" value="1" checked  v-model="visibility">
                    <label class="form-check-label" for="privateQuestion">
                        Private Frage <i class="fas fa-eye-slash"></i>
                    </label>
                </div>
            </div>
        </div>
    </div>

</add-question-component>
