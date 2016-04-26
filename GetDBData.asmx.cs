using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
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
    /// Summary description for GetDBData
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class GetDBData : System.Web.Services.WebService
    {
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
        public IEnumerable<GetProjectDelivery> GetProjectDeliveryRecords()
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

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
        public IEnumerable<GetProjectDelivery> GetRecentProjectDeliveryRecords()
        {
            // At this point we get the data from the Database to populate the DataTable
            DataTable dt = new DataTable();
            List<GetProjectDelivery> gpdList = new List<GetProjectDelivery>();

            SqlDataSource ds = new SqlDataSource();
            ds.ConnectionString = ConfigurationManager.ConnectionStrings["peddsdbConnectionString"].ConnectionString;

            using (SqlConnection sc = new SqlConnection(ds.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT top 30 cast((p.fin_wpitem + '-' + p.fin_segment + '-' + p.fin_phasegroup + p.fin_phasetype + '-' + p.fin_sequence) as char(14)) as 'FIN', [Checkin_Date], [Description], [PEDDSKey] FROM [Project] as p ORDER BY  [Checkin_Date] DESC", sc))
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
