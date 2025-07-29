<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="PlayStationStore.OrderConfirmation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Order Confirmation - PlayStation Store</title>
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
        .confirmation-box {
            background-color: #252525;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .order-details {
            background-color: #252525;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .btn {
            background-color: #0070cc;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 3px;
            text-decoration: none;
            display: inline-block;
            margin-top: 15px;
        }
        .btn:hover {
            background-color: #0058a3;
        }
        .success-icon {
            font-size: 48px;
            color: #4BB543;
            margin-bottom: 15px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #333;
        }
        .detail-label {
            font-weight: bold;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .cart-table th, .cart-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        .cart-table th {
            background-color: #303030;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>PlayStation Store</h1>
        </div>
        <div class="container">
            <div class="confirmation-box">
                <div class="success-icon">✓</div>
                <h2>Thank You for Your Order!</h2>
                <p>Your order has been successfully placed and is being processed.</p>
                <p>Order #<asp:Label ID="lblOrderNumber" runat="server" Text=""></asp:Label></p>
                <p>A confirmation email has been sent to <asp:Label ID="lblEmail" runat="server" Text=""></asp:Label></p>
            </div>
            
            <div class="order-details">
                <h3>Order Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Order Date:</span>
                    <asp:Label ID="lblOrderDate" runat="server" Text=""></asp:Label>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Payment Method:</span>
                    <asp:Label ID="lblPaymentMethod" runat="server" Text=""></asp:Label>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Shipping Address:</span>
                    <asp:Label ID="lblShippingAddress" runat="server" Text=""></asp:Label>
                </div>
                
                <h3>Order Summary</h3>
                <asp:GridView ID="gvOrderItems" runat="server" CssClass="cart-table" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="Game" />
                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                        <asp:BoundField DataField="UnitPrice" HeaderText="Price" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="SubTotal" HeaderText="Subtotal" DataFormatString="{0:C}" />
                    </Columns>
                </asp:GridView>
                
                <div style="margin-top: 15px; text-align: right;">
                    <div style="margin-bottom: 5px;">
                        <asp:Label ID="lblSubtotal" runat="server" Text="Subtotal: $0.00"></asp:Label>
                    </div>
                    <div style="margin-bottom: 5px;">
                        <asp:Label ID="lblTax" runat="server" Text="Tax (8%): $0.00"></asp:Label>
                    </div>
                    <div style="font-weight: bold; font-size: 18px;">
                        <asp:Label ID="lblTotal" runat="server" Text="Total: $0.00"></asp:Label>
                    </div>
                </div>
            </div>
            
            <div style="text-align: center;">
                <asp:Button ID="btnContinueShopping" runat="server" Text="Continue Shopping" CssClass="btn" OnClick="btnContinueShopping_Click" />
                <asp:Button ID="btnViewOrders" runat="server" Text="View My Orders" CssClass="btn" OnClick="btnViewOrders_Click" style="margin-left: 10px;" />
            </div>
        </div>
    </form>
</body>
</html>