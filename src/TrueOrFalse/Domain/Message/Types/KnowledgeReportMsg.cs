﻿using System.IO;
using RazorEngine;

public class KnowledgeReportMsg
{
    public const string UtmSource = "knowledgeReportEmail";

    public const string SignOutMessage = "Du erhälst diese E-Mail als Bericht über deinen Wissensstand. " +
                                         "Wenn du diese E-Mails nicht mehr erhalten möchtest, " +
                                         "deaktiviere die E-Mail-Benachrichtigung bei deinen " +
                                         "<a href=\"https://memucho.de/Nutzer/Einstellungen\">Konto-Einstellungen</a>.";

    public static void SendHtmlMail(User user)
    {
        var parsedTemplate = Razor.Parse(
            File.ReadAllText(PathTo.EmailTemplate_KnowledgeReport()), 
            new KnowledgeReportMsgModel(user)
        );

        HtmlMessage.Send(new MailMessage2(
            Settings.EmailFrom,
            user.EmailAddress,
            "Dein Wissensstand bei memucho",
            parsedTemplate),
            signOutMessage: SignOutMessage,
            utmSource: UtmSource);
    }
}