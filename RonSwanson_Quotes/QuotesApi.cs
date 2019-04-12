using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RonSwanson_Quotes
{
    public class QuotesApi
    {
        public RestClient _client { get; set; }

        public QuotesApi()
        {
            _client = new RestClient(new Uri("https://ron-swanson-quotes.herokuapp.com"));
        }

        public string GetSwansonQuote(string size)
        {
            var quote = "";
            var request = new RestRequest("/v2/quotes/58", Method.GET);

            var response = _client.Execute(request);
            var content = response.Content.ToString().Replace("[", string.Empty).Replace("]", string.Empty);
            var list = content.Split(new string[] { "\",\"" }, StringSplitOptions.None);

            switch (size)
            {
                case "Small":
                    quote = list.Where(q => q.Split(' ').Length <= 4).FirstOrDefault();
                    break;
                case "Medium":
                    quote = list.Where(q => q.Split(' ').Length >= 5 &&  q.Split(' ').Length <= 12).FirstOrDefault();
                    break;
                case "Large":
                    quote = list.Where(q => q.Split(' ').Length >= 13).FirstOrDefault();
                    break;
                default:
                    quote = list.FirstOrDefault();
                    break;
            }

            quote = quote.Replace("\"", string.Empty);

            return "\"" + quote + "\"";
        }
    }
}