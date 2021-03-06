using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

public class QuestionSolutionMultipleChoice_SingleSolution : QuestionSolution
{
    public List<string> Choices;

    public void FillFromPostData(NameValueCollection postData)
    {
        Choices =
            (
               from x in postData.AllKeys 
               where x.StartsWith("choice-")
               select postData.Get(x)
             )
             .ToList();
    }

    public override bool IsCorrect(string answer)
    {
        return Choices.First().Trim() == answer.Trim();
    }

    public override string CorrectAnswer()
    {
        if (!Choices.Any())
            return "";

        return Choices.First();
    }
}