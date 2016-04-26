<%@ Page Title="PEDDS | Contact" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="peddsweb.Contact" %>

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
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContentMaster">
    <hgroup class="title">
        <h2>Contact us for support.</h2>
    </hgroup>

    <section class="contact">
        <header>
            <h3>Phone:</h3>
        </header>
        <p>
            <span class="label">Main:</span>
            <span>425.555.0100</span>
        </p>
        <p>
            <span class="label">After Hours:</span>
            <span>425.555.0199</span>
        </p>
    </section>

    <section class="contact">
        <header>
            <h3>Email:</h3>
        </header>
        <p>
            <span class="label">Support:</span>
            <span><a href="mailto:Support@example.com">Support@example.com</a></span>
        </p>
        <p>
            <span class="label">Marketing:</span>
            <span><a href="mailto:Marketing@example.com">Marketing@example.com</a></span>
        </p>
        <p>
            <span class="label">General:</span>
            <span><a href="mailto:General@example.com">General@example.com</a></span>
        </p>
    </section>

    <section class="contact">
        <header>
            <h3>Address:</h3>
        </header>
        <p>
            One Microsoft Way<br />
            Redmond, WA 98052-6399
        </p>
    </section>
    <!-- Hides the Master Page Header + Navbar -->
    <script type="text/javascript" class="">
        $(document).ready(function () {
            $('#head').hide();
            $('.navbar').hide();
        });
    </script>
</asp:Content>