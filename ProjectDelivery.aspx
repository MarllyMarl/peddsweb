<%@ Page Title="PEDDS | Project Deliveries" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="ProjectDelivery.aspx.cs" Inherits="peddsweb.DeliveryView" %>
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
     <h4>Displays all the Projects and their corresponding deliveries currently checked-into the Pedds DB System.</h4>
   </hgroup>
   <!-- Breadcrumbs navigation -->
   <div class="col-lg-10">
        <ul class="breadcrumb pull-left">
            <li class="current">District: <% Response.Write(System.Configuration.ConfigurationManager.AppSettings["district_name"].ToString());%></li>
            <li><a href="Index.aspx"> Home</a></li>
            <li class="active">Projects</li>
        </ul>
   </div>
   <br /><br /><br /><br />
   
   <!-- Project Delivery DataTable EXAMPLE USING AJAX -->
   <div class="row">
      <table id="projectDelivery-dataTable" class="display compact cell-border">
        <thead>
		  <tr>
		   <th>FPID</th> 
           <th>Check-In-Date</th>
           <th>Project Description</th>
		  </tr>
		</thead>
      </table>
   </div>

   <!-- Script to fetch Project Delivery data from DB 
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

                var table =  $('#projectDelivery-dataTable').DataTable({  // DataTable setup
                    'aaData': dtData,
                    'bPaginate': true,
                    'bInfo': true,
                    'bFilter': true
                });
            } // END renderTable

            $.ajax({ // Ajax call to get records from the DB
                type: "GET",
                url: "GetDBData.asmx/GetProjectDeliveryRecords",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    renderTable(response.d);
                },
                failure: function (errMsg) {
                    $('#errorMessage').text(errMsg);  //errorMessage is id
                }

            }); // END Ajax call


           // Add event listener for opening and closing details
            $('#projectDelivery-dataTable tbody').on('click', 'td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = table.row(tr);

                if (row.child.isShown()) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                } else {
                    // Open this row
                    format(row.child);
                    tr.addClass('shown');
                }
            });


            //function format(callback) {
            //    $.ajax({
            //        url: '/echo/js/?js=[{ \"name\": \"test1\", \"value\": \"val1\" }, {\"name\": \"test2\", \"value\": \"val2\"}]',
            //        dataType: "json",
            //        complete: function (response) {
            //            var data = JSON.parse(response.responseText);
            //            console.log(data);
            //            var thead = '', tbody = '';
            //            for (var key in data[0]) {
            //                thead += '<th>' + key + '</th>';
            //            }
            //            $.each(data, function (i, d) {
            //                tbody += '<tr><td>' + d.FPID + '</td><td>' + d.checkInDate + '</td></tr>';
            //            });
            //            console.log('<table>' + thead + tbody + '</table>');
            //            callback($('<table>' + thead + tbody + '</table>')).show();
            //        },
            //        error: function () {
            //            $('#output').html('Bummer: there was an error!');
            //        }
            //    });
            //}


        }); // END document.ready
   </script>

 


   <div class="row">
        <b>Search</b>: <asp:TextBox ID="txtSearch" Width="300px" runat="server" OnTextChanged="txtSearch_TextChanged" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
           <asp:GridView ID="ProjectDeliveryGridView" runat="server" DataSourceID="ProjectDeliveryDataSource" AutoGenerateColumns="false" DataKeyNames="PeddsKey"
            AllowPaging="true" OnRowDataBound ="ProjectDeliveryGridView_RowDataBound" OnRowUpdated = "ProjectDeliveryGridView_RowUpdated" 
            CssClass="mGrid" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" HeaderStyle-BackColor="BlanchedAlmond">
            <Columns>
            <asp:TemplateField>
                  <ItemTemplate>
                      <a href="javascript:expandcollapse('div<%# Eval("PeddsKey") %>', 'one');">
                         <img id='imgdiv<%# Eval("PeddsKey") %>' 
                         alt="Click to show/hide Project deliveries <%# Eval("PeddsKey") %>" src="Images/details_open.png"/> &nbsp;
                      </a>
                  </ItemTemplate> 
              </asp:TemplateField>

             <asp:TemplateField HeaderText="FPID" SortExpression="FIN" Visible="true">           
                <ItemTemplate><asp:Label ID="lblFINNumber" Text='<%# HighlightText(Eval("FIN").ToString()) %>' runat="server"></asp:Label></ItemTemplate>                                         
             </asp:TemplateField>

             <asp:TemplateField HeaderText="Check-In-Date" SortExpression="Checkin_Date">
                <ItemTemplate><%# Eval("Checkin_Date")%></ItemTemplate>                                     
            </asp:TemplateField>

             <asp:TemplateField HeaderText="Project Description" SortExpression="Description">
                <ItemTemplate><%# HighlightText(Eval("Description").ToString())%></ItemTemplate>                            
            </asp:TemplateField>
             <%-- Nested GridView Setup --%>
             <asp:TemplateField HeaderStyle-CssClass="hidden-column" ItemStyle-CssClass="hidden-column" FooterStyle-CssClass="hidden-column">
	            <ItemTemplate>
	               <tr>
                     <td>
                         <div id='div<%# Eval("PeddsKey") %>' style="display:none;position:relative;left:15px;OVERFLOW: visible;WIDTH:97%">
                         <%-- Nested GridView --%> 
                         <asp:GridView ID="ChildProjectDeliveryGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="SHA"
                          OnPageIndexChanging="ChildProjectDeliveryGridView_PageIndexChanging" OnRowDataBound = "ChildProjectDeliveryGridView_RowDataBound">
                           <Columns>
                               <asp:HyperLinkField DataNavigateUrlFields="sha" DataNavigateUrlFormatString="./deliverydetails.aspx?delivery_key={0}"
                                DataTextField="checkin_date" HeaderText="Delivery Date" SortExpression="checkin_date" >
                               </asp:HyperLinkField>

                               <asp:TemplateField HeaderText="Delivery Type" SortExpression="usage" HeaderStyle-HorizontalAlign="Center">
                                  <ItemTemplate>
                                   <asp:Label ID="lblfield" runat="server"><%# Eval("usage")%></asp:Label>
                                  </ItemTemplate>
                               </asp:TemplateField>

                               <asp:TemplateField HeaderText="Description" SortExpression="description">
                                  <ItemTemplate><%#("description")%></ItemTemplate>
                               </asp:TemplateField>
                           </Columns> 
                         </asp:GridView>
                       </div>  
                     </td>
                   </tr> 
                </ItemTemplate>
            </asp:TemplateField>
           </Columns>
          </asp:GridView>
         </ContentTemplate>
         <Triggers>
             <asp:AsyncPostBackTrigger ControlID="txtSearch" EventName="TextChanged" />
          </Triggers>   
      </asp:UpdatePanel>
   </div>
   
   <!-- Repeater | GridView DataSource -->
   <asp:SqlDataSource ID="ProjectDeliveryDataSource" runat="server" ConnectionString ="<%$ ConnectionStrings:peddsdbConnectionString %>" 
       SelectCommand="SELECT cast((p.fin_wpitem + '-' + p.fin_segment + '-' + p.fin_phasegroup + p.fin_phasetype + '-' + p.fin_sequence) as char(14)) as 'FIN', [Checkin_Date], [Description], [PEDDSKey] FROM [Project] as p ORDER BY FIN" 
       FilterExpression="fin like '%{0}%' OR description like '%{1}%'">
       <FilterParameters>
          <asp:ControlParameter Name="fin" ControlID="txtSearch" PropertyName="Text" />
          <asp:ControlParameter Name="description" ControlID="txtSearch" PropertyName="Text" />
       </FilterParameters>
   </asp:SqlDataSource>
 
    <!-- Hides the Master Page Header + Navbar -->
    <script type="text/javascript">
        $(document).ready(function () {
            $('#head').hide();
            $('.navbar').hide();
        });
    </script>

    <!-- Hide/Unhide Script -->
    <script type="text/javascript">
        function expandcollapse(obj, row) {
            var div = document.getElementById(obj);
            var img = document.getElementById('img' + obj);

            if (div.style.display == "none") {
                div.style.display = "block";
                if (row == 'alt') {
                    img.src = "Images/details_close.png";
                }
                else {
                    img.src = "Images/details_close.png";
                }
                img.alt = "Close to view other Project Deliveries";
            }
            else {
                div.style.display = "none";
                if (row == 'alt') {
                    img.src = "Images/details_open.png";
                }
                else {
                    img.src = "Images/details_open.png";
                }
                img.alt = "Expand to show Project Deliveries";
            }
        }
    </script>



    <%-- <div class="row">
      <div class="">
          <asp:GridView ID="GridView1" runat="server" CssClass="gvdatatable" AutoGenerateColumns="false" DataSourceID="ProjectDeliveryDataSource">
              <Columns>
                  <asp:TemplateField>
                    <ItemTemplate>
                        <a href="javascript:expandcollapse('div<%# Eval("PeddsKey") %>', 'one');">
                            <img id='imgdiv<%# Eval("PeddsKey") %>' 
                            alt="Click to show/hide Project deliveries <%# Eval("PeddsKey") %>" src="Images/details_open.png"/> &nbsp;
                        </a>
                    </ItemTemplate>
                  </asp:TemplateField>
              </Columns>

              <Columns>
                  <asp:TemplateField HeaderText="FPID">
                    <ItemTemplate><%# Eval("FIN") %></ItemTemplate>
                  </asp:TemplateField>
              </Columns>
              
              <Columns>
                  <asp:TemplateField HeaderText="Check-In Date">
                    <ItemTemplate><%# Eval("Checkin_Date")%></ItemTemplate>
                  </asp:TemplateField>
              </Columns>
              
              <Columns>
                  <asp:TemplateField HeaderText="Description">
                    <ItemTemplate><%# Eval("Description")%></ItemTemplate>
                  </asp:TemplateField>
              </Columns>

          </asp:GridView>
      </div>
     </div> --%>

    <!-- Search Filter JS 
    <script type="text/javascript">
        function filterGridView(phrase, _id) {
            var words = phrase.value.toLowerCase().split(" ");
            var table = document.getElementById(_id);
            var ele;
            for (var r = 1; r < table.rows.length; r++) {
                ele = table.rows[r].innerHTML.replace(/<[^>]+>/g, "");
                var displayStyle = 'none';
                for (var i = 0; i < words.length; i++) {
                    if (ele.toLowerCase().indexOf(words[i]) >= 0)
                        displayStyle = '';
                    else {
                        displayStyle = 'none';
                        break;
                    }
                }
                table.rows[r].style.display = displayStyle;
            }
        }
    </script>-->

    <!-- TEST DataTable 
    <script type="text/javascript">
        $(document).ready(function () {
            $('.gvdatatable').DataTable({});
        });
    </script>-->

    <%--<script type="text/javascript">
        $(document).ready(function () {
           
        $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "DeliveryView.aspx/BindDatatable",
        data: "{}",
        dataType: "json",
        success: function(data) {
        for (var i = 0; i < data.d.length; i++) {
            $("#projectDeliveryView-dataTable").append("<tr><td>" + data.d[i].FPID + "</td><td>" + data.d[i].checkInDate + "</td><td>" + data.d[i].projectDescription + "</td></tr>");
          }
        },
           error: function(result) {
           alert("Error");
           }
         });
     });
   </script>--%>

    <%--<script type="text/javascript">
        $(document).ready(function() {
            $("#projectDeliveryView-dataTable").dataTable({
                "processing": true,
                "serverSide": true,
                "deferRender": true,

                "sAjaxSource": "WebService.asmx/ServerSideTest",
                "fnServerData": function (sSource, aoData, fnCallback) {
                    $.ajax({
                        "type": "POST",
                        "dataType": 'json',
                        "contentType": "application/json; charset=utf-8",
                        "url": sSource,
                        "data": "{'sEcho': '" + aoData[0].value + "'}",
                        "success": function (msg) {
                            fnCallback(msg.d);
                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });
                }
            });

        });
    </script>--%>

    <%-- <script type="text/javascript">
        $(document).ready(function () {
            // Ensures that no ajax queries are cached on the page
            $.ajaxSetup({
                cache: false
            });

            function showDetails() {
                alert("showing some details");
            }

            var table = $('#projectDeliveryView-dataTable').DataTable({
                "filter": true,
                "pagingType": "simple_numbers",
                "orderClasses": false,
                "order": [[0, "asc"]],
                "info": true,
                "bProcessing": true,
                "bServerSide": true,
                "bJQueryUI": true,
                "sAjaxSource": "WebService.asmx/GetData",
                "fnServerData": function (sSource, aoData, fnCallback) {
                    aoData.push({ "name": "roleId", "value": "admin" });
                    $.ajax({
                        "dataType": 'json',
                        "contentType": "application/json; charset=utf-8",
                        "type": "GET",
                        "url": sSource,
                        "data": aoData,
                        "success": function (msg) {
                            var json = jQuery.parseJSON(msg.d);
                            fnCallback(json);
                            $("#projectDeliveryView-dataTable").show();
                        },
                        error: function (xhr, textStatus, error) {
                            if (typeof console == "object") {
                                console.log(xhr.status + "," + xhr.responseText + "," + textStatus + "," + error);
                            }
                        }
                    });
                },
                fnDrawCallback: function () {
                    $('.image-details').bind("click", showDetails);
                }
            });
        });
    </script>--%>

</asp:Content>
