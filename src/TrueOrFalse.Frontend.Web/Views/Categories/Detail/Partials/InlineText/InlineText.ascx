﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<InlineTextModel>" %>

<%: Html.Partial("~/Views/Categories/Detail/Partials/ContentModuleWrapperStart.ascx") %>

<text-component content="<%: HttpUtility.HtmlDecode(Model.Content)  %>" inline-template>
    <div class="inline-text-editor">
        <editor-menu-bar :editor="editor" v-slot="{ commands, isActive, focused }">
          <div
        class="menubar is-hidden"
        :class="{ 'is-focused': focused }"
      >

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.bold() }"
          @click="commands.bold"
        >
            <i class="fas fa-bold"></i>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.italic() }"
          @click="commands.italic"
        >
            <i class="fas fa-italic"></i>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.strike() }"
          @click="commands.strike"
        >
            <i class="fas fa-strikethrough"></i>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.underline() }"
          @click="commands.underline"
        >
            <i class="fas fa-underline"></i>
        </button>

          <button
          class="menubar__button"
          :class="{ 'is-active': isActive.paragraph() }"
          @click="commands.paragraph"
        >
              <i class="fas fa-paragraph"></i>
        </button>

          <button
          class="menubar__button"
          :class="{ 'is-active': isActive.heading({ level: 2 }) }"
          @click="commands.heading({ level: 2 })"
        >
              <b>
                  H2

              </b>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.heading({ level: 3 }) }"
          @click="commands.heading({ level: 3 })"
        >
            <b>
                H3
            </b>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.bullet_list() }"
          @click="commands.bullet_list"
        >
            <i class="fas fa-list-ul"></i>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.ordered_list() }"
          @click="commands.ordered_list"
        >
            <i class="fas fa-list-ol"></i>
        </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.blockquote() }"
          @click="commands.blockquote"
        >
            <i class="fas fa-quote-right"></i>
        </button>
          
          <button
              class="menubar__button"
              :class="{ 'is-active': isActive.code() }"
              @click="commands.code"
          >
              <i class="far fa-file-code"></i>
          </button>

        <button
          class="menubar__button"
          :class="{ 'is-active': isActive.code_block() }"
          @click="commands.code_block"
        >
            <i class="fas fa-file-code"></i>
        </button>
          
          <button
              class="menubar__button"
              @click="commands.horizontal_rule"
          >
              <b>
                  —
              </b>
          </button>
          
          <button
              class="menubar__button"
              @click="commands.undo"
          >
              <i class="fas fa-undo-alt"></i>
          </button>

          <button
              class="menubar__button"
              @click="commands.redo"
          >
              <i class="fas fa-redo-alt"></i>
          </button>

      </div>
        </editor-menu-bar>

        <editor-content :editor="editor">
            <%: Html.Raw(Model.Content)  %>
        </editor-content>
    </div>

</text-component>

<%: Html.Partial("~/Views/Categories/Detail/Partials/ContentModuleWrapperEnd.ascx") %>