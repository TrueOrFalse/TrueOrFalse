﻿using System.Collections.Generic;

public class ProbabilityCalcResult
{
    /// <summary>CorrectnessProbability</summary>
	public int Probability;
    public int AnswerCount;
    public KnowledgeStatus KnowledgeStatus;

    public static ProbabilityCalcResult GetResult(
        IList<AnswerHistory> answerHistoryItems, 
        int correctnessProbability)
    {
	    var result = new ProbabilityCalcResult
	    {
	        Probability = correctnessProbability,
            AnswerCount = answerHistoryItems.Count
	    };

        if (answerHistoryItems.Count <= 4)
            result.KnowledgeStatus = KnowledgeStatus.Unknown;
        else
            result.KnowledgeStatus =
                correctnessProbability >= 89 ?
                    KnowledgeStatus.Secure :
                    KnowledgeStatus.Weak;

	    return result;
    }
}