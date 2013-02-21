﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<div id="modalImageUpload" class="modal">
    <div class="modal-header">
        <button class="close" data-dismiss="modal">×</button>
        <h3>Kategoriebild hochladen</h3>
    </div>

    <div class="modal-body">
        <div class="alert">
            <strong>Achtung:</strong> Bildrechte sind ein sensibles Thema. 
            Bitte lade nur Bilder hoch die gemeinfrei sind oder Bilder die Du stelbst erstellt hast. 
        </div>
       
        <div>
            <label class="radio inline" style="width: 200px;">
                <input type="radio" checked="checked" name="imgSource" id="rdoImageWikimedia"/>Bilder von Wikimedia verwenden.
            </label>
        
            <label class="radio inline" style="width: 130px;">
                <input type="radio" name="imgSource" id="rdoImageUpload" />Eigene Bilder
            </label>
        </div>
        <div style="clear: both;"></div>
        
        <%-- Wikimedia --%>
        <div id="divWikimedia" class="hide">
            <div style="margin-top:10px;">
                In Wikipedia sind viele Millionen Bilder zu finden, die frei genutzt werden können. 
                Auf <a href="http://commons.wikimedia.org/wiki/Hauptseite?uselang=de">Wiki-Commons</a> kann gezielt nach Inhalten gesucht werden. 
                Wenn Du auf Wikipedia auf ein Bild klickst, gelangst Du auf die Bild-Detailseite. Gib die URL der Detailseite hier an: 
            </div>
        
            <div style="margin-top: 10px;">
                <label style="position: relative; top: 5px;">Wikipedia URL:</label>
                <input class="span2" id="prependedInput" type="text" placeholder="http://" style="width: 250px;">      
            </div>            
        </div>
        
        <div id="divUpload">
            <div style="margin-top:10px;">
                <div id="fileUpload" class="btn btn-success" data-endpoint="">
                    <i class="icon-upload icon-white"></i> Bild upload (klicke oder verwende drag und drop)
                </div>
            </div>
        
            <div id="previewImage" class="hide" style="margin-top:8px;"></div>
            <div id="divUploadProgress" class="hide" style="margin-top:8px;"></div>

            <div id="divLegalInfo" class="hide">
                
                <div style="margin-top:10px;">
                    <b>Urheberrechtsinformation:</b><br/>
                    Wir benötigen Urheberrechtsinformationen für dieses Bild, damit wir sicherstellen können, 
                    dass Inhalte auf Richtig-oder-Falsch legal frei weiterverwendet werden können. 
                    Richtig-oder-Falsch folgt dem Wikipedia Prinzip [mehr erfahren].
                </div>
        
                <div style="width: 100%">
                    <label class="radio inline" style="width: 200px;">
                        <input type="radio" name="imgLiceneType" id="rdoLicenceByUloader"/>Diese Bild ist meine eigene Arbeit.
                    </label> 
                    <div style="clear: both;"></div>
                    <div id="divLicenceUploader" style="padding-left: 20px;" class="hide">
                        Ich, <input type="text" id="txtLicenceOwner" name="txtLicenceOwner" style="height: 10px; margin-bottom: 0px; position: relative; top: -2px;"/> , der Rechteinhaber dieses Werks gewähre unwiderruflich jedem das Recht, 
                        es gemäß der „Creative Commons“-Lizenz „Namensnennung, Weitergabe 
                        unter gleichen Bedingungen 3.0“ <a href="http://creativecommons.org/licenses/by-sa/3.0/deed.de">(Text der Lizenz)</a> zu nutzen.
                    </div>
                </div>
        
                <div style="width: 100%">
                    <label class="radio inline" style="width: 330px;">
                        <input type="radio" name="imgLiceneType" id="rdoLicenceForeign" />Dieses Bild ist nicht meine eigene Arbeit. 
                    </label>
                    <div style="clear: both;"></div>
                    <div id="divLicenceForeign" style="padding-left: 20px;" class="hide">
                        Wir bitten Dich das Bild auf <a href="http://commons.wikimedia.org">Wikimedia</a> hochzuladen und so einzubinden. 
                    </div>
                </div>                
            </div>
        </div>
    </div>

    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">Abbrechen.</a>
        <a href="#" class="btn btn-primary" data-dismiss="modal" id="aSaveImage">Bild speichern</a>
    </div>
</div>