using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PlayStationStore
{
    public partial class GameDetails : System.Web.UI.Page
    {
        // Get connection string from Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["PlayStationStoreConnection"].ConnectionString;

        private int gameId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get game ID from query string
            if (!String.IsNullOrEmpty(Request.QueryString["id"]))
            {
                if (int.TryParse(Request.QueryString["id"], out gameId))
                {
                    if (!IsPostBack)
                    {
                        LoadGameDetails(gameId);
                    }
                }
                else
                {
                    // Invalid ID format
                    Response.Redirect("Default.aspx");
                }
            }
            else
            {
                // No ID provided
                Response.Redirect("Default.aspx");
            }
        }

        private void LoadGameDetails(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT Title, Description, ReleaseDate, Developer, Publisher, Price " +
                                  "FROM Games WHERE GameID = @GameID";

                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@GameID", id);

                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTitle.Text = reader["Title"].ToString();
                            lblDescription.Text = reader["Description"].ToString();

                            // Format the date if it's not null
                            if (reader["ReleaseDate"] != DBNull.Value)
                            {
                                DateTime releaseDate = Convert.ToDateTime(reader["ReleaseDate"]);
                                lblReleaseDate.Text = releaseDate.ToShortDateString();
                            }

                            lblDeveloper.Text = reader["Developer"].ToString();
                            lblPublisher.Text = reader["Publisher"].ToString();

                            decimal price = Convert.ToDecimal(reader["Price"]);
                            lblPrice.Text = string.Format("{0:C}", price);
                        }
                        else
                        {
                            // Game not found
                            Response.Redirect("Default.aspx");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error loading game details: " + ex.Message);
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            // Create or retrieve the shopping cart from session
            DataTable cartTable;

            if (Session["ShoppingCart"] == null)
            {
                cartTable = new DataTable();
                cartTable.Columns.Add("GameID", typeof(int));
                cartTable.Columns.Add("Quantity", typeof(int));
                Session["ShoppingCart"] = cartTable;
            }
            else
            {
                cartTable = (DataTable)Session["ShoppingCart"];
            }

            // Check if game already in cart
            DataRow[] foundRows = cartTable.Select($"GameID = {gameId}");

            if (foundRows.Length > 0)
            {
                // Update quantity if game already in cart
                foundRows[0]["Quantity"] = Convert.ToInt32(foundRows[0]["Quantity"]) + 1;
            }
            else
            {
                // Add new game to cart
                DataRow newRow = cartTable.NewRow();
                newRow["GameID"] = gameId;
                newRow["Quantity"] = 1;
                cartTable.Rows.Add(newRow);
            }

            // Redirect to shopping cart
            Response.Redirect("ShoppingCart.aspx");
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void lnkCart_Click(object sender, EventArgs e)
        {
            Response.Redirect("ShoppingCart.aspx");
        }
    }
}