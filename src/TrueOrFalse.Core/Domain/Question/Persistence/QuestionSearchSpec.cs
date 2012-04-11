﻿using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using Seedworks.Lib.Persistence;
using TrueOrFalse.Core.Web.Context;

namespace TrueOrFalse.Core
{
    public class QuestionSearchSpec : SearchSpecificationBase<QuestionFilter, QuestionOrderBy>
    {
        public bool FilterByMe { get; private set; }
        public bool FilterByAll { get; private set; }
        public ReadOnlyCollection<int> FilterByUsers { get; private set; } 

        public void SetFilterByMe(bool? value)
        {
            if (!value.HasValue || value.Value == FilterByMe) return;
            FilterByMe = value.Value;
            UpdateFilter();
        }
        
        public void SetFilterByAll(bool? value)
        {
            if (!value.HasValue || value.Value == FilterByAll) return;
            FilterByAll = value.Value;
            UpdateFilter();
        }
        
        public void SetFilterByUsers(IEnumerable<int> userIds)
        {
            var newUserIds = userIds.ToList().AsReadOnly();
            if (FilterByUsers != null && newUserIds.SequenceEqual(FilterByUsers)) return;

            FilterByUsers = newUserIds;
            UpdateFilter();
        }

        private void UpdateFilter()
        {
            Filter.Clear();
         
            if (FilterByAll && !FilterByMe)
            {
                var condition = new ConditionInteger(Filter, "Creator.Id");
                condition.IsNotEqualTo(ServiceLocator.Resolve<SessionUser>().User.Id);
            }
            else if (FilterByAll && FilterByMe)
            {
                // show all, not filtered
            }
            else
            {
                var condition = new ConditionDisjunction<int>(Filter, "Creator.Id");
                condition.Add(FilterByUsers.ToArray());
                if (FilterByMe)
                {
                    condition.Add(ServiceLocator.Resolve<SessionUser>().User.Id);   
                }
            }
        }

    }

    public class QuestionFilter : ConditionContainer
    {

    }

    public class QuestionOrderBy : SpecOrderByBase { }
}
