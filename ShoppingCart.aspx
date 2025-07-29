<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShoppingCart.aspx.cs" Inherits="PlayStationStore.ShoppingCart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shopping Cart - PlayStation Store</title>
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
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .cart-table th, .cart-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        .cart-table th {
            background-color: #252525;
        }
        .btn {
            background-color: #0070cc;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            margin-right: 5px;
        }
        .total-section {
            margin-top: 20px;
            text-align: right;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>PlayStation Store</h1>
            <asp:LinkButton ID="lnkContinueShopping" runat="server" OnClick="lnkContinueShopping_Click">Continue Shopping</asp:LinkButton>
        </div>
        <div class="container">
            <h2>Your Shopping Cart</h2>
            
            <asp:GridView ID="gvCart" runat="server" CssClass="cart-table" AutoGenerateColumns="false"
                EmptyDataText="Your cart is empty" OnRowCommand="gvCart_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Title" HeaderText="Game" />
                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Quantity") %>' Width="40px"></asp:TextBox>
                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn" 
                                CommandName="UpdateQuantity" CommandArgument='<%# Eval("GameID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn" 
                                CommandName="RemoveItem" CommandArgument='<%# Eval("GameID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
            <div class="total-section">
                <asp:Label ID="lblTotal" runat="server" Text="Total: $0.00"></asp:Label>
            </div>
            
            <div style="margin-top: 20px">
                <asp:Button ID="btnClearCart" runat="server" Text="Clear Cart" CssClass="btn" OnClick="btnClearCart_Click" />
                <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn" OnClick="btnCheckout_Click" />
            </div>
        </div>
    </form>
</body>
</html>