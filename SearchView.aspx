<%@ Page Title="PEDDS | Search" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="SearchView.aspx.cs" Inherits="peddsweb.SearchView" %>
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
       <h4>Search the PEDDS database for a particular Projects and thier corrsponding Deliveries.</h4>
    </hgroup>
     <br />
    <p>SEARCH: TYPE YOUR SEARCH CRITERIA HERE</p>

<!-- Hides the Master Page Header + Navbar -->
<script type="text/javascript" class="">
    $(document).ready(function () {
        $('#head').hide();
        $('.navbar').hide();
    });
</script>
</asp:Content>
