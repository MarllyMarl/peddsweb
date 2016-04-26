<%@ Page Title="PEDDS | Most Recent Uploads" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="RecentProjectUploads.aspx.cs" Inherits="peddsweb.Project30View" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContentMaster" runat="server">
    <!-- Content Page Header - Content Page Only -->
    <header id="head" class="secondary">
      <div class="container">
        <div class="navbar-header"> 
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse"><span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
            <a class="navbar-brand" href="Index.aspx"><img src="/images/fdotLogo.png" alt="FDOT Logo"></a>
            <a class="navbar-brand" href="Index.aspx"><img src="/images/peddsLogo.jpg" alt="PEDDS Logo"></a>
        </div>
       </div>
    </header>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentMaster" runat="server">
   <hgroup class="title">
    <h4>Displays the 30 most recent projects and their deliveries currently checked-into the Pedds DB System.</h4>
   </hgroup>
   
   <!-- Breadcrumbs navigation -->
   <div class="col-lg-10">
        <ul class="breadcrumb pull-left">
            <li class="current">District: <% Response.Write(System.Configuration.ConfigurationManager.AppSettings["district_name"].ToString());%></li>
            <li><a href="Index.aspx"> Home</a></li>
            <li class="active">Uploads</li>
        </ul>
   </div>
   <br /><br /><br /><br />

   <!-- Recent Project Delivery DataTable -->
   <div class="row">
      <table id="recentProjectDelivery-dataTable" class="display compact cell-border">
        <thead>
		  <tr>
		   <th>FPID</th> 
           <th>Check-In-Date</th>
           <th>Project Description</th>
		  </tr>
		</thead>
      </table>
    </div>

   <!-- Script to fetch Recent Project Delivery data from DB 
        Advantages of using AJAX on the client side:
        + Reduce the traffic travels between the client and the server
        + Response time is faster so increases performance and speed
        + You can use JSON (JavaScript Object Notation) which is alternative to XML.
   -->
   <script type="text/javascript">
       $(document).ready(function () {
           // Ensures that no ajax queries are cached on the page
           $.ajaxSetup({
               cache: false
           });

           // The client side function to push the returned data to a JS array
           function renderTable(result) {
               var dtData = [];
               $.each(result, function () {
                   dtData.push([
                         this.FPID,
                         this.checkInDate,
                         this.projectDescription
                   ]);
               });

               $('#recentProjectDelivery-dataTable').DataTable({  // DataTable setup
                   'aaData': dtData,
                   'bPaginate': true,
                   'bInfo': true,
                   'bFilter': true,
                   'order': [[1, "desc"]],
                   'lengthMenu': [[10, 25, 30, -1], [10, 25, 30, "All"]]
               });
           } // END renderTable

           $.ajax({ // Ajax call to get records from the DB
               type: "GET",
               url: "GetDBData.asmx/GetRecentProjectDeliveryRecords",
               contentType: "application/json; charset=utf-8",
               dataType: "json",
               success: function (response) {
                   renderTable(response.d);
               },
               failure: function (errMsg) {
                   $('#errorMessage').text(errMsg);  //errorMessage is id of the div
               }
           }); // END Ajax call

       }); // END document.ready
   </script>

   <!-- Hides the Master Page Header + Navbar -->
   <script type="text/javascript" class="">
        $(document).ready(function () {
            $('#head').hide();
            $('.navbar').hide();
        });
    </script>
</asp:Content>
