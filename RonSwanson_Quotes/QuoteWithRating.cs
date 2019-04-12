using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RonSwanson_Quotes
{
    public class QuoteWithRating
    {
        public int QuoteID { get; set; }
        public string QuoteText { get; set; }
        public int Rating { get; set; }
    }
}