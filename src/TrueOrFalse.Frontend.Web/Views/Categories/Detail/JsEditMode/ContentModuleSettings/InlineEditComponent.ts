﻿var {
    tiptap,
    tiptapUtils,
    tiptapCommands,
    tiptapExtensions,
} = tiptapBuild;
var {
    apache,
    //cLike,
    xml,
    bash,
    //c,
    coffeescript,
    csharp,
    css,
    markdown,
    diff,
    ruby,
    go,
    http,
    ini,
    java,
    javascript,
    json,
    kotlin,
    less,
    lua,
    makefile,
    perl,
    nginx,
    objectivec,
    php,
    phpTemplate,
    plaintext,
    properties,
    python,
    pythonREPL,
    rust,
    scss,
    shell,
    sql,
    swift,
    yaml,
    typescript,
} = hljsBuild;
Vue.component('editor-menu-bar', tiptap.EditorMenuBar);
Vue.component('editor-content', tiptap.EditorContent);
Vue.component('editor-floating-menu', tiptap.EditorFloatingMenu);

Vue.component('text-component',
    {
        props: ['content'],
        data() {
            return {
                json: null,
                html: null,
                htmlContent: null,
                editMode: false,
                options: {
                    extensions: [
                        new tiptapExtensions.Blockquote(),
                        new tiptapExtensions.BulletList(),
                        new tiptapExtensions.CodeBlock(),
                        new tiptapExtensions.HardBreak(),
                        new tiptapExtensions.Heading({ levels: [2, 3] }),
                        new tiptapExtensions.HorizontalRule(),
                        new tiptapExtensions.ListItem(),
                        new tiptapExtensions.OrderedList(),
                        new tiptapExtensions.TodoItem(),
                        new tiptapExtensions.TodoList(),
                        new tiptapExtensions.Link(),
                        new tiptapExtensions.Image(),
                        new tiptapExtensions.Bold(),
                        new tiptapExtensions.Code(),
                        new tiptapExtensions.Italic(),
                        new tiptapExtensions.Strike(),
                        new tiptapExtensions.Underline(),
                        new tiptapExtensions.History(),
                        new tiptapExtensions.CodeBlockHighlight({
                            languages: {
                                apache,
                                //cLike,
                                xml,
                                bash,
                                //c,
                                coffeescript,
                                csharp,
                                css,
                                markdown,
                                diff,
                                ruby,
                                go,
                                http,
                                ini,
                                java,
                                javascript,
                                json,
                                kotlin,
                                less,
                                lua,
                                makefile,
                                perl,
                                nginx,
                                objectivec,
                                php,
                                phpTemplate,
                                plaintext,
                                properties,
                                python,
                                pythonREPL,
                                rust,
                                scss,
                                shell,
                                sql,
                                swift,
                                yaml,
                                typescript,
                            },
                        }),
                        new tiptapExtensions.Placeholder({
                            emptyEditorClass: 'is-editor-empty',
                            emptyNodeClass: 'is-empty',
                            emptyNodeText: 'Klicke hier um zu tippen ...',
                            showOnlyWhenEditable: true,
                            showOnlyCurrent: true,
                        })
                    ],
                    content: this.content,
                    onUpdate: ({ getJSON, getHTML }) => {
                        this.json = getJSON();
                        this.html = getHTML();
                    },
                    editorProps: {
                        handleDOMEvents: {
                            drop: (view, e) => { e.preventDefault(); },
                        }
                    },
                    // hide the drop position indicator
                    dropCursor: { width: 0, color: 'transparent' },
                },
                editor: new tiptap.Editor({
                    extensions: [
                        new tiptapExtensions.Blockquote(),
                        new tiptapExtensions.BulletList(),
                        new tiptapExtensions.CodeBlock(),
                        new tiptapExtensions.HardBreak(),
                        new tiptapExtensions.Heading({ levels: [2, 3] }),
                        new tiptapExtensions.HorizontalRule(),
                        new tiptapExtensions.ListItem(),
                        new tiptapExtensions.OrderedList(),
                        new tiptapExtensions.TodoItem(),
                        new tiptapExtensions.TodoList(),
                        new tiptapExtensions.Link(),
                        new tiptapExtensions.Image(),
                        new tiptapExtensions.Bold(),
                        new tiptapExtensions.Code(),
                        new tiptapExtensions.Italic(),
                        new tiptapExtensions.Strike(),
                        new tiptapExtensions.Underline(),
                        new tiptapExtensions.History(),
                        new tiptapExtensions.CodeBlockHighlight({
                            languages: {
                                apache,
                                //cLike,
                                xml,
                                bash,
                                //c,
                                coffeescript,
                                csharp,
                                css,
                                markdown,
                                diff,
                                ruby,
                                go,
                                http,
                                ini,
                                java,
                                javascript,
                                json,
                                kotlin,
                                less,
                                lua,
                                makefile,
                                perl,
                                nginx,
                                objectivec,
                                php,
                                phpTemplate,
                                plaintext,
                                properties,
                                python,
                                pythonREPL,
                                rust,
                                scss,
                                shell,
                                sql,
                                swift,
                                yaml,
                                typescript,
                            },
                        }),
                        new tiptapExtensions.Placeholder({
                            emptyEditorClass: 'is-editor-empty',
                            emptyNodeClass: 'is-empty',
                            emptyNodeText: 'Klicke hier um zu tippen ...',
                            showOnlyWhenEditable: true,
                            showOnlyCurrent: true,
                        })
                    ],
                    content: this.content,
                    onUpdate: ({ getJSON, getHTML }) => {
                        this.json = getJSON();
                        this.html = getHTML();
                    },
                    editorProps: {
                        handleDOMEvents: {
                            drop: (view, e) => { e.preventDefault(); },
                        }
                    },
                    // hide the drop position indicator
                    dropCursor: { width: 0, color: 'transparent' },
                }),
            }
        },
        created() {
            this.setContent(this.content);
        },
        mounted() {
            eventBus.$on('cancel-edit-mode',
                () => {
                    this.editor.destroy();
                    this.editor =
                        new tiptap.Editor({
                            extensions: [
                                new tiptapExtensions.Blockquote(),
                                new tiptapExtensions.BulletList(),
                                new tiptapExtensions.CodeBlock(),
                                new tiptapExtensions.HardBreak(),
                                new tiptapExtensions.Heading({ levels: [2, 3] }),
                                new tiptapExtensions.HorizontalRule(),
                                new tiptapExtensions.ListItem(),
                                new tiptapExtensions.OrderedList(),
                                new tiptapExtensions.TodoItem(),
                                new tiptapExtensions.TodoList(),
                                new tiptapExtensions.Link(),
                                new tiptapExtensions.Image(),
                                new tiptapExtensions.Bold(),
                                new tiptapExtensions.Code(),
                                new tiptapExtensions.Italic(),
                                new tiptapExtensions.Strike(),
                                new tiptapExtensions.Underline(),
                                new tiptapExtensions.History(),
                                new tiptapExtensions.CodeBlockHighlight({
                                    languages: {
                                        apache,
                                        //cLike,
                                        xml,
                                        bash,
                                        //c,
                                        coffeescript,
                                        csharp,
                                        css,
                                        markdown,
                                        diff,
                                        ruby,
                                        go,
                                        http,
                                        ini,
                                        java,
                                        javascript,
                                        json,
                                        kotlin,
                                        less,
                                        lua,
                                        makefile,
                                        perl,
                                        nginx,
                                        objectivec,
                                        php,
                                        phpTemplate,
                                        plaintext,
                                        properties,
                                        python,
                                        pythonREPL,
                                        rust,
                                        scss,
                                        shell,
                                        sql,
                                        swift,
                                        yaml,
                                        typescript,
                                    },
                                }),
                                new tiptapExtensions.Placeholder({
                                    emptyEditorClass: 'is-editor-empty',
                                    emptyNodeClass: 'is-empty',
                                    emptyNodeText: 'Klicke hier um zu tippen ...',
                                    showOnlyWhenEditable: true,
                                    showOnlyCurrent: true,
                                })
                            ],
                            content: this.content,
                            onUpdate: ({ getJSON, getHTML }) => {
                                this.json = getJSON();
                                this.html = getHTML();
                            },
                            editorProps: {
                                handleDOMEvents: {
                                    drop: (view, e) => { e.preventDefault(); },
                                }
                            },
                            // hide the drop position indicator
                            dropCursor: { width: 0, color: 'transparent' },
                        });
                });
        },
        watch: {
            editMode() {
                this.editor.setOptions({
                    editable: this.editMode,
                });
            },
            html() {
                this.setContent(this.html);
                eventBus.$emit('content-change');
            }
        },
        methods: {

            setContent(html) {
                var json = {
                    "TemplateName": "InlineText",
                    "Content": html
                }
                this.$parent.content = json;
                this.htmlContent = html;

            }
        }
    });

