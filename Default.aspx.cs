using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PlayStationStore
{
    public partial class Default : System.Web.UI.Page
    {
        // Get connection string from Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["PlayStationStoreConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load games from database
                LoadGames();
            }
        }

        private void LoadGames()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand("SELECT GameID, Title, Description, Price FROM Games", connection);

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable gamesTable = new DataTable();
                    adapter.Fill(gamesTable);

                    rptGames.DataSource = gamesTable;
                    rptGames.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Log error or display message
                Response.Write("Error loading games: " + ex.Message);
            }
        }

        protected void rptGames_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int gameId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewDetails")
            {
                // Redirect to game details page
                Response.Redirect($"GameDetails.aspx?id={gameId}");
            }
            else if (e.CommandName == "AddToCart")
            {
                AddGameToCart(gameId);
                Response.Redirect("ShoppingCart.aspx");
            }
        }

        private void AddGameToCart(int gameId)
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
        }

        protected void lnkCart_Click(object sender, EventArgs e)
        {
            Response.Redirect("ShoppingCart.aspx");
        }
    }
}