<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PlayStationStore.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PlayStation Store</title>
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #1a1a1a;
            color: #ffffff;
        }
        .header {
            background-color: #003791;
            padding: 10px 20px;
            color: white;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .game-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .game-item {
            border: 1px solid #333;
            padding: 15px;
            background-color: #252525;
        }
        .game-title {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .game-price {
            color: #0070cc;
            font-size: 16px;
            margin: 10px 0;
        }
        .btn {
            background-color: #0070cc;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>PlayStation Store</h1>
            <asp:LinkButton ID="lnkCart" runat="server" OnClick="lnkCart_Click">View Cart</asp:LinkButton>
        </div>
        <div class="container">
            <h2>Featured Games</h2>
            <asp:Repeater ID="rptGames" runat="server" OnItemCommand="rptGames_ItemCommand">
                <HeaderTemplate>
                    <div class="game-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="game-item">
                        <div class="game-title"><%# Eval("Title") %></div>
                        <div><%# Eval("Description") %></div>
                        <div class="game-price">$<%# Eval("Price", "{0:0.00}") %></div>
                        <asp:Button ID="btnDetails" runat="server" Text="View Details" 
                            CommandName="ViewDetails" CommandArgument='<%# Eval("GameID") %>' CssClass="btn" />
                        <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" 
                            CommandName="AddToCart" CommandArgument='<%# Eval("GameID") %>' CssClass="btn" />
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>