//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Vanct.Dal.Entities
{
    using System;
    using System.Collections.Generic;
    
    public partial class ReportDaily
    {
        public ReportDaily()
        {
            this.ReportDailylines = new HashSet<ReportDailyline>();
        }
    
        public int Id { get; set; }
        public int RUserId { get; set; }
        public string Username { get; set; }
        public string WorkTime { get; set; }
        public double Total { get; set; }
        public System.DateTime Date { get; set; }
    
        public virtual RUser RUser { get; set; }
        public virtual ICollection<ReportDailyline> ReportDailylines { get; set; }
    }
}
