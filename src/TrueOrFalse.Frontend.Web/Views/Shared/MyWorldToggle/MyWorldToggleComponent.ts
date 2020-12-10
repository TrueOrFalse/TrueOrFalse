﻿Vue.component('my-world-toggle-component',
    {
        data() {
            return {
                showMyWorld: false,
            }
        },
        mounted() {
            this.loadCookie();
        },
        watch: {
            showMyWorld(val) {
                this.$root.showMyWorld = val;
            }
        },
        methods: {
            loadCookie() {
                $.get("/Category/GetMyWorldCookie/", (showMyWorld) => {
                    this.showMyWorld = showMyWorld == "True";
                    this.$root.showMyWorld = this.showMyWorld;
                });
            },
            toggleMyWorld() {
                this.showMyWorld = !this.showMyWorld;
                var s = this.showMyWorld;
                $.post(`/Category/SetMyWorldCookie/?showMyWorld=${s}`).done(() => {
                    location.reload();
                });
            },
            sendShowMyWorld() {
                $.post("/User/SetUserWorldInUserCache",
                    { showMyWorld: this.showMyWorld });
            }
        }
    });
