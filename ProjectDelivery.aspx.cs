using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

using System.Data;
using System.Drawing;
using System.Web.SessionState;
using System.Web.UI.HtmlControls;

using System.Data.SqlClient;
using System.Configuration;
using System.Diagnostics;
using System.Text.RegularExpressions;


namespace peddsweb
{
    public partial class DeliveryView : System.Web.UI.Page
    {
        protected System.Data.SqlClient.SqlConnection _conn;
        protected string _connection_string;
        protected string _sort_expression;
        string SearchString = "";

        public void deliveryview()
        {
            if (ConfigurationManager.AppSettings["peddsdb2_connection"] != null)
            {
                _connection_string = System.Configuration.ConfigurationManager.AppSettings["peddsdb2_connection"];
                System.Diagnostics.Debug.Assert((_connection_string.Length > 0),
                    "ProjectDelivery.aspx could not connect to the PeddsDB 2 database",
                    "ProjectDelivery.aspx retrieved a blank peddsdb2_connection value from web.config.");
                _conn = new SqlConnection(_connection_string);
                _sort_expression = "FIN";
            }
            else
            {
                //Error err = new Error(this.Page, 
                //   "The Pedds DB server cannot connect to the database. This server may be down for administrative purposes; please try again later.",
                //   "deliveryview.aspx",
                //   "ctor()",
                //   "No peddsdb2_connection string was found in the AppSettings element. This server has been mis-configured and cannot attach to the "
                //   + "database without a proper connection string entered into the web.config file.");
            }

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            txtSearch.Attributes.Add("onkeyup", "setTimeout('__doPostBack(\\'" + txtSearch.ClientID.Replace("_", "$") + "\\',\\'\\')', 0);");
            if (!IsPostBack)
            {
                ProjectDeliveryGridView.DataBind();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            SearchString = txtSearch.Text;
        }

        public string HighlightText(string InputTxt)
        {
            string Search_Str = txtSearch.Text.ToString();
            // Setup the regular expression and add the Or operator.
            Regex RegExp = new Regex(Search_Str.Replace(" ", "|").Trim(), RegexOptions.IgnoreCase);
            // Highlight keywords by calling the 
            //delegate each time a keyword is found.
            return RegExp.Replace(InputTxt, new MatchEvaluator(ReplaceKeyWords));
            // Set the RegExp to null.
            RegExp = null;
        }

        public string ReplaceKeyWords(Match m)
        {
            return "<span class=highlight>" + m.Value + "</span>";
        }


        #region Variables
        string gvUniqueID = String.Empty;
        int gvNewPageIndex = 0;
        int gvEditIndex = -1;
        string gvSortExpr = String.Empty;

        private string gvSortDir
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }
        #endregion

        #region Methods
        //This procedure returns the Sort Direction
        private string GetSortDirection()
        {
            switch (gvSortDir)
            {
                case "ASC":
                    gvSortDir = "DESC";
                    break;

                case "DESC":
                    gvSortDir = "ASC";
                    break;
            }
            return gvSortDir;
        }
        #endregion

        #region ProjectDeliveryGridView Event Handlers
        //This event occurs for each row
        protected void ProjectDeliveryGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            GridViewRow row = e.Row;
            string strSort = " ORDER BY checkin_date";

            // Make sure we aren't in header/footer rows
            if (row.DataItem == null)
            {
                return;
            }

            //Find Child GridView control
            GridView gv = new GridView();
            gv = (GridView)row.FindControl("ChildProjectDeliveryGridView");

            //Check if any additional conditions (Paging, Sorting, Editing, etc) to be applied on child GridView
            if (gv.UniqueID == gvUniqueID)
            {
                gv.PageIndex = gvNewPageIndex;
                gv.EditIndex = gvEditIndex;

                //Check if Sorting used
                if (gvSortExpr != string.Empty)
                {
                    GetSortDirection();

                    if (gvSortExpr == "description")
                    {
                        strSort = " ORDER BY cast(" + gvSortExpr + " as varchar(max)) " + gvSortDir;
                    }
                    else
                    {
                        strSort = " ORDER BY " + string.Format("{0} {1}", gvSortExpr, gvSortDir);
                    }
                }

                //Expand the Child grid
                ClientScript.RegisterStartupScript(GetType(), "Expand", "<SCRIPT LANGUAGE='javascript'>expandcollapse('div" + ((DataRowView)e.Row.DataItem)["Peddskey"].ToString() + "','one');</script>");
            }

            //Prepare the query for Child GridView by passing the ID of the parent row
            gv.DataSource = ChildDataSource(((DataRowView)e.Row.DataItem)["PeddsKey"].ToString(), strSort);

            // Bind Data to GridView1 (Deliveries)
            gv.DataBind();

        }

        //This event occurs after RowUpdating to catch any constraints while updating
        protected void ProjectDeliveryGridView_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            //Check if there is any exception while deleting
            if (e.Exception != null)
            {
                ClientScript.RegisterStartupScript(GetType(), "Message",
                    "<SCRIPT LANGUAGE='javascript'>alert('" + e.Exception.Message.ToString().Replace("'", "") + "');</script>");
                e.ExceptionHandled = true;
            }
        }

        #endregion

        #region ChildProjectDeliveryGridView Event Handlers
        protected void ChildProjectDeliveryGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gvTemp = (GridView)sender;
            gvUniqueID = gvTemp.UniqueID;
            gvNewPageIndex = e.NewPageIndex;
            ProjectDeliveryGridView.DataBind();
        }

        protected void ChildProjectDeliveryGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //Check if this is our Blank Row being databound, if so make the row invisible
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (((DataRowView)e.Row.DataItem)["checkin_date"].ToString() == String.Empty)
                {
                    e.Row.Visible = false;
                }

                if (((DataRowView)e.Row.DataItem)["usage"].ToString() == "null")
                {
                    DataRowView drv = (DataRowView)e.Row.DataItem;
                    Label lblfield = (Label)e.Row.FindControl("lblfield");
                    lblfield.Text = "Project";
                }
            }
        }

        protected void ChildProjectDeliveryGridView_Sorting(object sender, GridViewSortEventArgs e)
        {
            GridView gvTemp = (GridView)sender;
            gvUniqueID = gvTemp.UniqueID;
            gvSortExpr = e.SortExpression;
            ProjectDeliveryGridView.DataBind();
        }
        #endregion

        #region ChildGridView DataSource
        // This procedure prepares the query to bind the child GridView
        private SqlDataSource ChildDataSource(string PeddsKey, string strSort)
        {
            string query = "";
            SqlDataSource dsTemp = new SqlDataSource();
            dsTemp.ConnectionString = ConfigurationManager.ConnectionStrings["peddsdbConnectionString"].ConnectionString;

            query = "select d.* " +
                "from all_deliveries as d, projectxdelivery as pxd " +
                "where d.sha = pxd.delivery_sha " +
                "and pxd.project_peddskey = '" + PeddsKey + "'"
                + strSort;

            dsTemp.SelectCommand = query;

            return dsTemp;
        }
        #endregion


        //protected void GridView1_PreRender(object sender, EventArgs e)
        //{
        //    //GridView1.DataSource = GetData();  //GetData is your method that you will use to obtain the data you're populating the GridView with

        //    //GridView1.DataBind();

        //    //if (GridView1.Rows.Count > 0)
        //    //{
        //    //    //Replace the <td> with <th> and adds the scope attribute
        //    //    GridView1.UseAccessibleHeader = true;

        //    //    //Adds the <thead> and <tbody> elements required for DataTables to work
        //    //    GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;

        //    //    //Adds the <tfoot> element required for DataTables to work
        //    //    GridView1.FooterRow.TableSection = TableRowSection.TableFooter;
        //    //}
        //}

        //private SqlDataSource GetData()
        //{
        //    string query = "";
        //    SqlDataSource dsTemp = new SqlDataSource();
        //    dsTemp.ConnectionString = ConfigurationManager.ConnectionStrings["peddsdbConnectionString"].ConnectionString;

        //    query = "select * " +
        //        "from Project ";

        //    dsTemp.SelectCommand = query;

        //    return dsTemp;
        //}

        //[WebMethod] 
        //public static GetProjectDelivery[] BindDatatable()
        //{
        //    DataTable dt = new DataTable();
        //    List<GetProjectDelivery> gpdList = new List<GetProjectDelivery>();
            
        //    SqlDataSource ds= new SqlDataSource();
        //    ds.ConnectionString = ConfigurationManager.ConnectionStrings["peddsdbConnectionString"].ConnectionString;
            
        //    using(SqlConnection sc = new SqlConnection(ds.ConnectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand("SELECT cast((p.fin_wpitem + '-' + p.fin_segment + '-' + p.fin_phasegroup + p.fin_phasetype + '-' + p.fin_sequence) as char(14)) as 'FIN', [Checkin_Date], [Description], [PEDDSKey] FROM [Project] as p ORDER BY FIN", sc))
        //        {
        //            sc.Open();
        //            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        //            adpt.Fill(dt);

        //            foreach (DataRow dtrow in dt.Rows)
        //            {
        //                GetProjectDelivery gpdDetails = new GetProjectDelivery();
        //                gpdDetails.FPID = dtrow["FIN"].ToString();
        //                gpdDetails.checkInDate = dtrow["Checkin_Date"].ToString();
        //                gpdDetails.projectDescription = dtrow["Description"].ToString();
        //                gpdList.Add(gpdDetails);
        //            }
        //        }
        //    }
        //    return gpdList.ToArray();
        //}

        //[Serializable]
        //public class GetProjectDelivery
        //{
        //    public string FPID { get; set; }
        //    public string checkInDate { get; set; }
        //    public string projectDescription { get; set; }

        //}

    }
}