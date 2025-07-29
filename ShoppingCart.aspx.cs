using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PlayStationStore
{
    public partial class ShoppingCart : System.Web.UI.Page
    {
        // Get connection string from Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["PlayStationStoreConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCartItems();
            }
        }

        private void LoadCartItems()
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            if (cartTable == null || cartTable.Rows.Count == 0)
            {
                // Cart is empty
                gvCart.DataSource = null;
                gvCart.DataBind();
                lblTotal.Text = "Total: $0.00";
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Create a DataTable to hold cart items with game details
                    DataTable cartDetails = new DataTable();
                    cartDetails.Columns.Add("GameID", typeof(int));
                    cartDetails.Columns.Add("Title", typeof(string));
                    cartDetails.Columns.Add("Price", typeof(decimal));
                    cartDetails.Columns.Add("Quantity", typeof(int));
                    cartDetails.Columns.Add("Subtotal", typeof(decimal));

                    decimal total = 0;

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
                                    decimal subtotal = price * quantity;

                                    // Add to cart details table
                                    DataRow newRow = cartDetails.NewRow();
                                    newRow["GameID"] = gameId;
                                    newRow["Title"] = title;
                                    newRow["Price"] = price;
                                    newRow["Quantity"] = quantity;
                                    newRow["Subtotal"] = subtotal;
                                    cartDetails.Rows.Add(newRow);

                                    total += subtotal;
                                }
                            }
                        }
                    }

                    // Bind to GridView
                    gvCart.DataSource = cartDetails;
                    gvCart.DataBind();

                    // Update total
                    lblTotal.Text = string.Format("Total: {0:C}", total);
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error loading cart: " + ex.Message);
            }
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int gameId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "UpdateQuantity")
            {
                // Find the quantity textbox in the row
                GridViewRow row = (GridViewRow)(((Button)e.CommandSource).NamingContainer);
                TextBox txtQuantity = (TextBox)row.FindControl("txtQuantity");
                int quantity = Convert.ToInt32(txtQuantity.Text);

                UpdateCartItemQuantity(gameId, quantity);
            }
            else if (e.CommandName == "RemoveItem")
            {
                RemoveCartItem(gameId);
            }

            // Reload cart
            LoadCartItems();
        }

        private void UpdateCartItemQuantity(int gameId, int quantity)
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            if (cartTable != null)
            {
                foreach (DataRow row in cartTable.Rows)
                {
                    if (Convert.ToInt32(row["GameID"]) == gameId)
                    {
                        if (quantity > 0)
                        {
                            row["Quantity"] = quantity;
                        }
                        else
                        {
                            // If quantity is 0 or negative, remove the item
                            cartTable.Rows.Remove(row);
                        }
                        break;
                    }
                }
            }
        }

        private void RemoveCartItem(int gameId)
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            if (cartTable != null)
            {
                DataRow[] rowsToRemove = cartTable.Select($"GameID = {gameId}");

                foreach (DataRow row in rowsToRemove)
                {
                    cartTable.Rows.Remove(row);
                }
            }
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            // Clear the cart
            Session["ShoppingCart"] = null;
            LoadCartItems();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            
            Response.Redirect("Checkout.aspx");
        }

        protected void lnkContinueShopping_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}