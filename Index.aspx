<%@ Page Title="PEDDS | Home" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="peddsweb.Index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContentMaster" runat="server">
    <!-- Intro
            <section class="herotxt">
             <div class="container sectionBox">
              <div class="row">
                <div class="col-md-9">
                    <span>Welcome to the PEDDS Project/Delivery Website.</span>
                    <p>The Project/Delivery Views will allow you to view and select projects and their corresponding deliveries 
                    to view detailed information, delivery files, and download options.</p>
                </div>             
                <div class="col-md-6">
                  <br />
                  <i class="fa fa-cloud-download"></i> version 5.0
                </div>
              </div>
             </div>
            </section>
    <!-- /Intro-->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentMaster" runat="server">
    <!-- Highlights - jumbotron -->
    <div class="jumbotron sectionBox">
    <div class="container">
     <div class="row">
      <div class="col-md-3 col-sm-6 highlight">
        <div class="h-caption">
          <h4><i class="fa fa-info-circle fa-2x circle"></i> PEDDS</h4>
        </div>
        <div class="h-body">
          <p>PEDDS is a project centric system designed specifically to meet the rules of those Boards of Professional Regulation...more</p>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 highlight">
        <div class="h-caption">
          <h4><i class="fa fa-folder-open fa-2x circle"></i><a href="ProjectDelivery.aspx"> PROJECTS</a></h4>
        </div>
        <div class="h-body">
          <p>Allows you to view and select projects and thier corresponding deliveries  to view detailed information, delivery files, and download options.</p>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 highlight">
        <div class="h-caption">
          <h4><i class="fa fa-upload fa-2x circle"></i><a href="RecentProjectUploads.aspx"> UPLOADS</a></h4>
        </div>
        <div class="h-body">
          <p>Displays a list of the 30 most recently uploaded projects and their corresponding deliveries.</p>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 highlight">
        <div class="h-caption">
          <h4><i class="fa fa-search fa-2x circle"></i>SEARCH</h4>
        </div>
        <div class="h-body">
          <p>Allows you to build a query to search for projects and their corrsponding deliveries matching the search criteria designated by the user.</p>
        </div>
      </div>
     </div>
     <!-- /row  --> 
     </div>
    </div>    
    <!-- /Highlights - jumbotron -->
</asp:Content>
