using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Diagnostics;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace peddsweb
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]

        public string GetData()
        {
            var echo = int.Parse(HttpContext.Current.Request.Params["sEcho"]);
            var displayLength = int.Parse(HttpContext.Current.Request.Params["iDisplayLength"]);
            var displayStart = int.Parse(HttpContext.Current.Request.Params["iDisplayStart"]);
            var sortOrder = HttpContext.Current.Request.Params["sSortDir_0"].ToString(CultureInfo.CurrentCulture);
            var roleId = HttpContext.Current.Request.Params["roleId"].ToString(CultureInfo.CurrentCulture);
            var smartSearch = HttpContext.Current.Request.Params["sSearch"];

            var records = GetRecordsFromDatabase().ToList();
            if (!records.Any())
            {
                return string.Empty;
            }

            // Column Sort Order
            var orderedResults = sortOrder == "asc"
                                 ? records.OrderBy(o => o.FPID)
                                 : records.OrderByDescending(o => o.FPID);
            var itemsToSkip = displayStart == 0
                              ? 0
                              : displayStart + 1;
            var pagedResults = orderedResults.Skip(itemsToSkip).Take(displayLength).ToList();
            var hasMoreRecords = false;

            
            // Search Filter
            var searchsb = new StringBuilder(); 
            var filteredWhere = string.Empty;
            var wrappedSearch = "'%" + smartSearch + "%'";

            if (smartSearch.Length > 0)
            {
                searchsb.Append(" WHERE FPID LIKE ");
                searchsb.Append(wrappedSearch);
                searchsb.Append(" OR Check-In-Date LIKE ");
                searchsb.Append(wrappedSearch);
                searchsb.Append(" OR Project Description LIKE ");
                searchsb.Append(wrappedSearch);

                filteredWhere = searchsb.ToString();
            }

//            string query = @"SELECT cast((p.fin_wpitem + '-' + p.fin_segment + '-' + p.fin_phasegroup + p.fin_phasetype + '-' + p.fin_sequence) as char(14)) 
//                          as 'FIN', [Checkin_Date], [Description], [PEDDSKey] FROM [Project] as p ORDER BY FIN";
//            query = String.Format(query, filteredWhere);

            searchsb.Clear(); 


            var sb = new StringBuilder();
            sb.Append(@"{" + "\"sEcho\": " + echo + ",");
            sb.Append("\"recordsTotal\": " + records.Count + ",");
            sb.Append("\"recordsFiltered\": " + records.Count + ",");
            sb.Append("\"iTotalRecords\": " + records.Count + ",");
            sb.Append("\"iTotalDisplayRecords\": " + records.Count + ",");
            sb.Append("\"aaData\": [");
            foreach (var result in pagedResults)
            {
                if (hasMoreRecords)
                {
                    sb.Append(",");
                }

                sb.Append("[");
                sb.Append("\"" + result.FPID + "\",");
                sb.Append("\"" + result.checkInDate + "\",");
                sb.Append("\"" + result.projectDescription + "\",");
                sb.Append("\"<img class='image-details' src='Images/details_open.png' runat='server' height='16' width='16' alt='View Details'/>\"");
                sb.Append("]");
                hasMoreRecords = true;
            }
            sb.Append("]}");
            return sb.ToString();
        }

        private static IEnumerable<GetProjectDelivery> GetRecordsFromDatabase()
        {
            // At this point we get the data from the Database to populate the DataTable
            DataTable dt = new DataTable();
            List<GetProjectDelivery> gpdList = new List<GetProjectDelivery>();

            SqlDataSource ds = new SqlDataSource();
            ds.ConnectionString = ConfigurationManager.ConnectionStrings["peddsdbConnectionString"].ConnectionString;

            using (SqlConnection sc = new SqlConnection(ds.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT cast((p.fin_wpitem + '-' + p.fin_segment + '-' + p.fin_phasegroup + p.fin_phasetype + '-' + p.fin_sequence) as char(14)) as 'FIN', [Checkin_Date], [Description], [PEDDSKey] FROM [Project] as p ORDER BY FIN", sc))
                {
                    sc.Open();
                    SqlDataAdapter adpt = new SqlDataAdapter(cmd);
                    adpt.Fill(dt);

                    foreach (DataRow dtrow in dt.Rows)
                    {
                        GetProjectDelivery gpdDetails = new GetProjectDelivery();
                        gpdDetails.FPID = dtrow["FIN"].ToString();
                        gpdDetails.checkInDate = dtrow["Checkin_Date"].ToString();
                        gpdDetails.projectDescription = dtrow["Description"].ToString();
                        gpdList.Add(gpdDetails);
                    }
                }
            }
            return gpdList.ToArray();
        }

        public class GetProjectDelivery
        {
          public string FPID { get; set; }
          public string checkInDate { get; set; }
          public string projectDescription { get; set; }
        }

    }
}
