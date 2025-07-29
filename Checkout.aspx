<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="PlayStationStore.Checkout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Checkout - PlayStation Store</title>
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
        .order-summary {
            background-color: #252525;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .checkout-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .section {
            background-color: #252525;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #444;
            background-color: #333;
            color: white;
            border-radius: 3px;
        }
        .btn {
            background-color: #0070cc;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 3px;
        }
        .btn:hover {
            background-color: #0058a3;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }
        .cart-table th, .cart-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        .cart-table th {
            background-color: #303030;
        }
        .error-message {
            color: #ff6b6b;
            margin-top: 5px;
            font-size: 14px;
        }
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .payment-option {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableCDN="false" />
        
        <div class="header">
            <h1>PlayStation Store</h1>
            <asp:LinkButton ID="lnkBackToCart" runat="server" OnClick="lnkBackToCart_Click">Back to Cart</asp:LinkButton>
        </div>
        <div class="container">
            <h2>Checkout</h2>
            
            <div class="order-summary">
                <h3>Order Summary</h3>
                <asp:GridView ID="gvOrderSummary" runat="server" CssClass="cart-table" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="Game" />
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" />
                    </Columns>
                </asp:GridView>
                
                <div style="margin-top: 15px; text-align: right;">
                    <asp:Label ID="lblSubtotal" runat="server" Text="Subtotal: $0.00"></asp:Label><br />
                    <asp:Label ID="lblTax" runat="server" Text="Tax (8%): $0.00"></asp:Label><br />
                    <asp:Label ID="lblTotal" runat="server" Text="Total: $0.00" style="font-weight: bold; font-size: 18px;"></asp:Label>
                </div>
            </div>
            
            <div class="checkout-form">
                <div>
                    <div class="section">
                        <h3>Billing Information</h3>
                        <div class="form-group">
                            <asp:Label ID="lblName" runat="server" Text="Full Name:" AssociatedControlID="txtName"></asp:Label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                                ErrorMessage="Name is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblEmail" runat="server" Text="Email:" AssociatedControlID="txtEmail"></asp:Label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your email" TextMode="Email"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                ErrorMessage="Email is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                ErrorMessage="Invalid email format" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RegularExpressionValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblAddress" runat="server" Text="Address:" AssociatedControlID="txtAddress"></asp:Label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter your address"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" 
                                ErrorMessage="Address is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblCity" runat="server" Text="City:" AssociatedControlID="txtCity"></asp:Label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="Enter your city"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" 
                                ErrorMessage="City is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblState" runat="server" Text="State/Province:" AssociatedControlID="ddlState"></asp:Label>
                            <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select State" Value=""></asp:ListItem>
                                <asp:ListItem Text="Alabama" Value="AL"></asp:ListItem>
                                <asp:ListItem Text="Alaska" Value="AK"></asp:ListItem>
                                <asp:ListItem Text="Arizona" Value="AZ"></asp:ListItem>
                                <asp:ListItem Text="California" Value="CA"></asp:ListItem>
                                <asp:ListItem Text="New York" Value="NY"></asp:ListItem>
                                <asp:ListItem Text="Texas" Value="TX"></asp:ListItem>
                                <asp:ListItem Text="Florida" Value="FL"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="ddlState" 
                                ErrorMessage="State is required" CssClass="error-message" Display="Dynamic" InitialValue="" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblZip" runat="server" Text="ZIP/Postal Code:" AssociatedControlID="txtZip"></asp:Label>
                            <asp:TextBox ID="txtZip" runat="server" CssClass="form-control" placeholder="Enter ZIP code"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip" 
                                ErrorMessage="ZIP code is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                
                <div>
                    <div class="section">
                        <h3>Payment Information</h3>
                        <div class="form-group">
                            <asp:Label ID="lblPaymentMethod" runat="server" Text="Payment Method:"></asp:Label>
                            <div class="payment-options">
                                <div class="payment-option">
                                    <asp:RadioButton ID="rdoCredit" runat="server" GroupName="PaymentMethod" Checked="true" AutoPostBack="true" OnCheckedChanged="rdoPaymentMethod_CheckedChanged" />
                                    <label for="<%= rdoCredit.ClientID %>">Credit Card</label>
                                </div>
                                <div class="payment-option">
                                    <asp:RadioButton ID="rdoPayPal" runat="server" GroupName="PaymentMethod" AutoPostBack="true" OnCheckedChanged="rdoPaymentMethod_CheckedChanged" />
                                    <label for="<%= rdoPayPal.ClientID %>">PayPal</label>
                                </div>
                                <div class="payment-option">
                                    <asp:RadioButton ID="rdoStore" runat="server" GroupName="PaymentMethod" AutoPostBack="true" OnCheckedChanged="rdoPaymentMethod_CheckedChanged" />
                                    <label for="<%= rdoStore.ClientID %>">PlayStation Store Credit</label>
                                </div>
                            </div>
                        </div>
                        
                        <asp:Panel ID="pnlCreditCard" runat="server">
                            <div class="form-group">
                                <asp:Label ID="lblCardName" runat="server" Text="Cardholder Name:" AssociatedControlID="txtCardName"></asp:Label>
                                <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="Name on card"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCardName" runat="server" ControlToValidate="txtCardName" 
                                    ErrorMessage="Cardholder name is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lblCardNumber" runat="server" Text="Card Number:" AssociatedControlID="txtCardNumber"></asp:Label>
                                <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="XXXX XXXX XXXX XXXX"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCardNumber" runat="server" ControlToValidate="txtCardNumber" 
                                    ErrorMessage="Card number is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revCardNumber" runat="server" ControlToValidate="txtCardNumber"
                                    ValidationExpression="^[0-9]{16}$"
                                    ErrorMessage="Card number must be 16 digits" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RegularExpressionValidator>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <div class="form-group" style="flex: 1;">
                                    <asp:Label ID="lblExpDate" runat="server" Text="Expiration Date:" AssociatedControlID="txtExpDate"></asp:Label>
                                    <asp:TextBox ID="txtExpDate" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvExpDate" runat="server" ControlToValidate="txtExpDate" 
                                        ErrorMessage="Expiration date is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <asp:Label ID="lblCVV" runat="server" Text="CVV:" AssociatedControlID="txtCVV"></asp:Label>
                                    <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="4"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCVV" runat="server" ControlToValidate="txtCVV" 
                                        ErrorMessage="CVV is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlPayPal" runat="server" Visible="false">
                            <div class="form-group">
                                <asp:Label ID="lblPayPalEmail" runat="server" Text="PayPal Email:" AssociatedControlID="txtPayPalEmail"></asp:Label>
                                <asp:TextBox ID="txtPayPalEmail" runat="server" CssClass="form-control" placeholder="Enter your PayPal email" TextMode="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPayPalEmail" runat="server" ControlToValidate="txtPayPalEmail" 
                                    ErrorMessage="PayPal email is required" CssClass="error-message" Display="Dynamic" ValidationGroup="CheckoutValidation"></asp:RequiredFieldValidator>
                            </div>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlStoreCredit" runat="server" Visible="false">
                            <div class="form-group">
                                <asp:Label ID="lblStoreCredit" runat="server" Text="PlayStation Store Credit Balance:"></asp:Label>
                                <asp:Label ID="lblStoreCreditBalance" runat="server" Text="$50.00" CssClass="form-control"></asp:Label>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
            
            <div style="text-align: right; margin-top: 20px;">
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn" OnClick="btnCancel_Click" CausesValidation="false" style="background-color: #555; margin-right: 10px;" />
                <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="btn" OnClick="btnPlaceOrder_Click" ValidationGroup="CheckoutValidation" />
            </div>
            
            <asp:Panel ID="pnlErrorMessage" runat="server" Visible="false" CssClass="section" style="background-color: #561111; margin-top: 20px;">
                <asp:Label ID="lblErrorMessage" runat="server" Text=""></asp:Label>
            </asp:Panel>
        </div>
    </form>
</body>
</html>