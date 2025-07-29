using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PlayStationStore
{
    public partial class Checkout : System.Web.UI.Page
    {
        // Get connection string from Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["PlayStationStoreConnection"].ConnectionString;
        private decimal subtotal = 0;
        private decimal tax = 0;
        private decimal total = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Disable unobtrusive validation
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (!IsPostBack)
            {
                // Check if cart is empty
                DataTable cartTable = (DataTable)Session["ShoppingCart"];
                if (cartTable == null || cartTable.Rows.Count == 0)
                {
                    Response.Redirect("ShoppingCart.aspx");
                    return;
                }

                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            if (cartTable == null || cartTable.Rows.Count == 0)
            {
                // Redirect to shopping cart if cart is empty
                Response.Redirect("ShoppingCart.aspx");
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Create a DataTable to hold order summary with game details
                    DataTable orderSummary = new DataTable();
                    orderSummary.Columns.Add("GameID", typeof(int));
                    orderSummary.Columns.Add("Title", typeof(string));
                    orderSummary.Columns.Add("Price", typeof(decimal));
                    orderSummary.Columns.Add("Quantity", typeof(int));
                    orderSummary.Columns.Add("Subtotal", typeof(decimal));

                    subtotal = 0;

                    // Loop through each cart item and get game details
                    foreach (DataRow cartRow in cartTable.Rows)
                    {
                        int gameId = Convert.ToInt32(cartRow["GameID"]);
                        int quantity = Convert.ToInt32(cartRow["Quantity"]);

                        // Get game details from database
                        string query = "SELECT Title, Price FROM Games WHERE GameID = @GameID";
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@GameID", gameId);

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    string title = reader["Title"].ToString();
                                    decimal price = Convert.ToDecimal(reader["Price"]);
                                    decimal itemSubtotal = price * quantity;

                                    // Add to order summary table
                                    DataRow newRow = orderSummary.NewRow();
                                    newRow["GameID"] = gameId;
                                    newRow["Title"] = title;
                                    newRow["Price"] = price;
                                    newRow["Quantity"] = quantity;
                                    newRow["Subtotal"] = itemSubtotal;
                                    orderSummary.Rows.Add(newRow);

                                    subtotal += itemSubtotal;
                                }
                            }
                        }
                    }

                    // Bind to GridView
                    gvOrderSummary.DataSource = orderSummary;
                    gvOrderSummary.DataBind();

                    // Calculate tax and total
                    tax = Math.Round(subtotal * 0.08m, 2); // 8% tax
                    total = subtotal + tax;

                    // Update the labels
                    lblSubtotal.Text = string.Format("Subtotal: {0:C}", subtotal);
                    lblTax.Text = string.Format("Tax (8%): {0:C}", tax);
                    lblTotal.Text = string.Format("Total: {0:C}", total);

                    // Store values in session for order processing
                    Session["OrderSubtotal"] = subtotal;
                    Session["OrderTax"] = tax;
                    Session["OrderTotal"] = total;
                }
            }
            catch (Exception ex)
            {
                pnlErrorMessage.Visible = true;
                lblErrorMessage.Text = "Error loading order summary: " + ex.Message;
            }
        }

        protected void rdoPaymentMethod_CheckedChanged(object sender, EventArgs e)
        {
            // Show/hide payment panels based on selection
            pnlCreditCard.Visible = rdoCredit.Checked;
            pnlPayPal.Visible = rdoPayPal.Checked;
            pnlStoreCredit.Visible = rdoStore.Checked;

            // Update validators based on visible panels
            SetValidators();
        }

        private void SetValidators()
        {
            // Enable/disable validators based on payment method
            rfvCardName.Enabled = rdoCredit.Checked;
            rfvCardNumber.Enabled = rdoCredit.Checked;
            revCardNumber.Enabled = rdoCredit.Checked;
            rfvExpDate.Enabled = rdoCredit.Checked;
            rfvCVV.Enabled = rdoCredit.Checked;

            rfvPayPalEmail.Enabled = rdoPayPal.Checked;
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                // Get user information
                string name = txtName.Text;
                string email = txtEmail.Text;
                string address = txtAddress.Text;
                string city = txtCity.Text;
                string state = ddlState.SelectedValue;
                string zip = txtZip.Text;

                // Get payment method
                string paymentMethod = rdoCredit.Checked ? "Credit Card" :
                                      (rdoPayPal.Checked ? "PayPal" : "Store Credit");

                // Create order in database
                int orderId = CreateOrder(name, email, address, city, state, zip, paymentMethod);

                if (orderId > 0)
                {
                    // Add order items to database
                    AddOrderItems(orderId);

                    // Clear shopping cart
                    Session["ShoppingCart"] = null;

                    // Store order ID in session
                    Session["LastOrderID"] = orderId;

                    // Redirect to order confirmation page
                    Response.Redirect("OrderConfirmation.aspx");
                }
                else
                {
                    pnlErrorMessage.Visible = true;
                    lblErrorMessage.Text = "Failed to create order. Please try again.";
                }
            }
            catch (Exception ex)
            {
                pnlErrorMessage.Visible = true;
                lblErrorMessage.Text = "Error processing order: " + ex.Message;
            }
        }

        private int CreateOrder(string name, string email, string address, string city, string state, string zip, string paymentMethod)
        {
            int orderId = 0;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        INSERT INTO Orders 
                        (CustomerName, Email, ShippingAddress, City, State, ZipCode, 
                         OrderDate, PaymentMethod, SubTotal, Tax, TotalAmount, OrderStatus) 
                        VALUES 
                        (@CustomerName, @Email, @ShippingAddress, @City, @State, @ZipCode, 
                         @OrderDate, @PaymentMethod, @SubTotal, @Tax, @TotalAmount, @OrderStatus);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@CustomerName", name);
                        command.Parameters.AddWithValue("@Email", email);
                        command.Parameters.AddWithValue("@ShippingAddress", address);
                        command.Parameters.AddWithValue("@City", city);
                        command.Parameters.AddWithValue("@State", state);
                        command.Parameters.AddWithValue("@ZipCode", zip);
                        command.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                        command.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                        command.Parameters.AddWithValue("@SubTotal", subtotal);
                        command.Parameters.AddWithValue("@Tax", tax);
                        command.Parameters.AddWithValue("@TotalAmount", total);
                        command.Parameters.AddWithValue("@OrderStatus", "Pending");

                        // Get the new OrderID
                        object result = command.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            orderId = Convert.ToInt32(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error creating order: " + ex.Message);
            }

            return orderId;
        }

        private void AddOrderItems(int orderId)
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            if (cartTable == null || cartTable.Rows.Count == 0)
            {
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    foreach (DataRow cartRow in cartTable.Rows)
                    {
                        int gameId = Convert.ToInt32(cartRow["GameID"]);
                        int quantity = Convert.ToInt32(cartRow["Quantity"]);

                        // Get game details from database
                        decimal price = 0;
                        string query = "SELECT Price FROM Games WHERE GameID = @GameID";
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@GameID", gameId);
                            object result = command.ExecuteScalar();
                            if (result != null && result != DBNull.Value)
                            {
                                price = Convert.ToDecimal(result);
                            }
                        }

                        // Add order item
                        string insertQuery = @"
                            INSERT INTO OrderItems 
                            (OrderID, GameID, Quantity, UnitPrice, SubTotal) 
                            VALUES 
                            (@OrderID, @GameID, @Quantity, @UnitPrice, @SubTotal)";

                        using (SqlCommand command = new SqlCommand(insertQuery, connection))
                        {
                            command.Parameters.AddWithValue("@OrderID", orderId);
                            command.Parameters.AddWithValue("@GameID", gameId);
                            command.Parameters.AddWithValue("@Quantity", quantity);
                            command.Parameters.AddWithValue("@UnitPrice", price);
                            command.Parameters.AddWithValue("@SubTotal", price * quantity);
                            command.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error adding order items: " + ex.Message);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Return to shopping cart
            Response.Redirect("ShoppingCart.aspx");
        }

        protected void lnkBackToCart_Click(object sender, EventArgs e)
        {
            // Return to shopping cart
            Response.Redirect("ShoppingCart.aspx");
        }
    }
}