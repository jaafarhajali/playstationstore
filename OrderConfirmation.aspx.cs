using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PlayStationStore
{
    public partial class OrderConfirmation : System.Web.UI.Page
    {
        // Get connection string from Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["PlayStationStoreConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if we have an order ID in session
                if (Session["LastOrderID"] != null)
                {
                    int orderId = Convert.ToInt32(Session["LastOrderID"]);
                    LoadOrderDetails(orderId);
                }
                else
                {
                    // No order ID found, redirect to home page
                    Response.Redirect("Default.aspx");
                }
            }
        }

        private void LoadOrderDetails(int orderId)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Get order details
                    string orderQuery = @"
                        SELECT OrderID, CustomerName, Email, ShippingAddress, City, State, ZipCode, 
                               OrderDate, PaymentMethod, SubTotal, Tax, TotalAmount, OrderStatus
                        FROM Orders
                        WHERE OrderID = @OrderID";

                    using (SqlCommand command = new SqlCommand(orderQuery, connection))
                    {
                        command.Parameters.AddWithValue("@OrderID", orderId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Display order details
                                lblOrderNumber.Text = reader["OrderID"].ToString();
                                lblEmail.Text = reader["Email"].ToString();
                                lblOrderDate.Text = Convert.ToDateTime(reader["OrderDate"]).ToString("MMMM d, yyyy");
                                lblPaymentMethod.Text = reader["PaymentMethod"].ToString();

                                // Format shipping address
                                string address = reader["ShippingAddress"].ToString();
                                string city = reader["City"].ToString();
                                string state = reader["State"].ToString();
                                string zipCode = reader["ZipCode"].ToString();
                                lblShippingAddress.Text = $"{address}, {city}, {state} {zipCode}";

                                // Set financial values
                                decimal subtotal = Convert.ToDecimal(reader["SubTotal"]);
                                decimal tax = Convert.ToDecimal(reader["Tax"]);
                                decimal total = Convert.ToDecimal(reader["TotalAmount"]);

                                lblSubtotal.Text = string.Format("Subtotal: {0:C}", subtotal);
                                lblTax.Text = string.Format("Tax (8%): {0:C}", tax);
                                lblTotal.Text = string.Format("Total: {0:C}", total);
                            }
                            else
                            {
                                // Order not found, redirect to home page
                                Response.Redirect("Default.aspx");
                                return;
                            }
                        }
                    }

                    // Get order items
                    string itemsQuery = @"
                        SELECT g.Title, oi.Quantity, oi.UnitPrice, oi.SubTotal
                        FROM OrderItems oi
                        INNER JOIN Games g ON oi.GameID = g.GameID
                        WHERE oi.OrderID = @OrderID";

                    using (SqlCommand command = new SqlCommand(itemsQuery, connection))
                    {
                        command.Parameters.AddWithValue("@OrderID", orderId);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            DataTable itemsTable = new DataTable();
                            adapter.Fill(itemsTable);

                            gvOrderItems.DataSource = itemsTable;
                            gvOrderItems.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error (could add a label to display error message)
                Response.Write("Error loading order details: " + ex.Message);
            }
        }

        protected void btnContinueShopping_Click(object sender, EventArgs e)
        {
            // Clear the order ID from session
            Session["LastOrderID"] = null;

            // Redirect to home page
            Response.Redirect("Default.aspx");
        }

        protected void btnViewOrders_Click(object sender, EventArgs e)
        {
            // Redirect to order history page (if you have one)
            // This would typically require user authentication
            Response.Redirect("OrderHistory.aspx");
        }
    }
}