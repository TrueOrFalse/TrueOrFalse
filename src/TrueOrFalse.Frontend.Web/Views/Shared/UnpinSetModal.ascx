﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div id="UnpinSetModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <span style="display: block; margin-top: 15px; margin-bottom: 15px;">Das Lernset <span id="SetName"></span> wurde aus deinem Wunschwissen entfernt.<br/></span>
                        <b>Die enthaltenen Fragen werden ebenfalls aus deinem Wunschwissen gelöscht.</b>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <a href="#" class="SecAction" data-dismiss="modal">Nein, die Fragen sollen im Wunschwissen bleiben.</a>
                <a href="#" id="JS-RemoveQuestions" class="btn btn-primary" data-set-id="" data-dismiss="modal" style="width: 80px; max-width: 100%;">Ok</a>
            </div>
        </div>
    </div>
</div>