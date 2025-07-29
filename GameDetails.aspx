<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameDetails.aspx.cs" Inherits="PlayStationStore.GameDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Game Details - PlayStation Store</title>
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
        .game-details {
            background-color: #252525;
            padding: 20px;
            border-radius: 5px;
        }
        .game-title {
            font-size: 24px;
            margin-bottom: 15px;
        }
        .game-info {
            margin-bottom: 20px;
            line-height: 1.6;
        }
        .game-price {
            font-size: 20px;
            color: #0070cc;
            margin: 20px 0;
        }
        .btn {
            background-color: #0070cc;
            color: white;
            padding: 8px 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        .navigation {
            margin-bottom: 20px;
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
            <div class="navigation">
                <asp:LinkButton ID="lnkBack" runat="server" OnClick="lnkBack_Click">« Back to Games</asp:LinkButton>
            </div>
            
            <div class="game-details">
                <h2 class="game-title"><asp:Label ID="lblTitle" runat="server"></asp:Label></h2>
                
                <div class="game-info">
                    <p><strong>Developer:</strong> <asp:Label ID="lblDeveloper" runat="server"></asp:Label></p>
                    <p><strong>Publisher:</strong> <asp:Label ID="lblPublisher" runat="server"></asp:Label></p>
                    <p><strong>Release Date:</strong> <asp:Label ID="lblReleaseDate" runat="server"></asp:Label></p>
                    <p><strong>Description:</strong></p>
                    <p><asp:Label ID="lblDescription" runat="server"></asp:Label></p>
                </div>
                
                <div class="game-price">
                    Price: <asp:Label ID="lblPrice" runat="server"></asp:Label>
                </div>
                
                <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" CssClass="btn" OnClick="btnAddToCart_Click" />
            </div>
        </div>
    </form>
</body>
</html>