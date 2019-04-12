using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RonSwanson_Quotes
{
    public partial class Quotes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void getQuotesButton_Click(object sender, EventArgs e)
        {
            var api = new QuotesApi();
            var quote = api.GetSwansonQuote(quoteSizeRadioButtonList.SelectedValue);
            PopulateQuote(quote);
        }

        private void PopulateQuote(string quote)
        {
            using (RonSwanson_Quotes.RonSwansonQuotes_dbEntities dc = new RonSwanson_Quotes.RonSwansonQuotes_dbEntities())
            {
                var v = (from a in dc.QuotesTables
                         join b in dc.RatingsTables on a.QuoteId equals b.QuoteId into bb
                         from b in bb.DefaultIfEmpty()
                         group new { a, b } by new { a.QuoteId, a.QuoteText } into AA
                         select new
                         {
                             AA.Key.QuoteId,
                             AA.Key.QuoteText,
                             Score = AA.Sum(a => a.b.Rating) == null ? 0 : AA.Sum(a => a.b.Rating),
                             Count = AA.Count()
                         });
                List<QuoteWithRating> AWS = new List<QuoteWithRating>();
                foreach (var i in v)
                {
                    if(i.QuoteText.Equals(quote))
                    {
                        AWS.Add(new QuoteWithRating
                        {
                            QuoteID = i.QuoteId,
                            QuoteText = i.QuoteText,
                            Rating = i.Score / i.Count
                        });
                        GridView1.DataSource = AWS;
                        GridView1.DataBind();
                    }
                }
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static int SaveRating(int quoteId, byte rating)
        {
            int result = 0;
            using (RonSwanson_Quotes.RonSwansonQuotes_dbEntities dc = new RonSwanson_Quotes.RonSwansonQuotes_dbEntities())
            {
                dc.RatingsTables.Add(new RatingsTable
                {
                    QuoteId = quoteId,
                    RatingId = 0,
                    Rating = rating,
                    Date = DateTime.Now
                });
                dc.SaveChanges();

                var newRating = (from a in dc.RatingsTables
                                where a.QuoteId.Equals(quoteId)
                                group a by a.QuoteId into aa
                                select new
                                {
                                    QuoteRating = aa.Sum(a => a.Rating) / aa.Count()
                                }).FirstOrDefault();
                result = newRating.QuoteRating;
            }
            return result;
        }
    }
}