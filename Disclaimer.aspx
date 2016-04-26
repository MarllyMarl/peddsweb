<%@ Page Title="Default" Language="C#" MasterPageFile="~/PeddsHome.Master" AutoEventWireup="true" CodeBehind="Disclaimer.aspx.cs" Inherits="peddsweb.Default" %>

<asp:Content ID="Content1" runat="server" contentplaceholderid="MainContentMaster">
    <div id="defaultIntro">
     <div id="intro">
        <div>
           <asp:Button id="Button1" runat="server" BorderStyle="None" CssClass="disclaimerButton"></asp:Button>
           <asp:Button ID="Button2" runat="server" BorderStyle="None" CssClass="disclaimerButton"></asp:Button>
        </div>
     </div>  		     					
   </div><!--defaultIntro-->
   <!-- Hides the Master Page Header + Navbar -->
    <script type="text/javascript" class="">
        $(document).ready(function () {
            $('#head').hide();
            $('.navbar').hide();
        });
    </script>
</asp:Content>




