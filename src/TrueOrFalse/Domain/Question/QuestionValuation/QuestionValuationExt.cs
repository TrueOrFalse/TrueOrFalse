﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TrueOrFalse
{
    public static class QuestionValuationExt
    {
        public static QuestionValuation ByQuestionId(this IEnumerable<QuestionValuation> questionValuations, int questionId)
        {
            return questionValuations.FirstOrDefault(x =>  x.QuestionId == questionId);
        }

        public static IList<int> QuestionIds(this IEnumerable<QuestionValuation> setValuations)
        {
            return setValuations.Select(x => x.QuestionId).ToList();
        }
    }
}
