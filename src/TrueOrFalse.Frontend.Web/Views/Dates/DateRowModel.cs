﻿public class DateRowModel : BaseModel
{
    public Date Date;

    public int KnowledgeUnknown;
    public int KnowledgeWeak;
    public int KnowledgeSecure;

    public int AmountQuestions;

    public DateRowModel(Date date)
    {
        Date = date;

        var allQuestions = date.AllQuestions();
        AmountQuestions = allQuestions.Count;

        var summary = R<KnowledgeSummaryLoader>().Run(UserId, allQuestions.GetIds());

        KnowledgeSecure = summary.Secure;
        KnowledgeUnknown = summary.Unknown;
        KnowledgeWeak = summary.Weak;
    }
}
