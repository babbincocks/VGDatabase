<%@ Page Title="" Language="C#" MasterPageFile="~/View.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VGDatabase.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="mainBody">
        <p>Content content content content.</p>

        <asp:Panel ID="sideSearch"  runat="server" CssClass="sideSearch">
            <div>
                <label id="light">Search</label>
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                <br />
                <asp:Button ID="btnSearch" runat="server" Text="Search" OnClientClick="return validSearch();" OnClick="btnSearch_Click"></asp:Button>
                <br />
            </div>
            
        </asp:Panel>
    </div>

    <script>
        function validSearch() {
    let term = document.getElementById('<%= txtSearch.ClientID %>').value;
            
    return term;
}
    </script>
</asp:Content>
