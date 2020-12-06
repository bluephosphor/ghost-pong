using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using System.Data.SqlClient;

namespace gp_database
{
    public partial class FormMain : Form
    {
        SqlConnection connection;
        string connection_string;

        public FormMain()
        {
            InitializeComponent();

            connection_string = ConfigurationManager.ConnectionStrings["gp_database.Properties.Settings.gpConnectionString"].ConnectionString;
        }

        private void FormMain_Load(object sender, EventArgs e)
        {
            PopulateClients();
        }

        //SHOWING CLIENTS
        private void PopulateClients()
        {
            using (connection = new SqlConnection(connection_string))
            using (SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM gpclients", connection))
            {
                DataTable client_table = new DataTable();
                adapter.Fill(client_table);

                list_box_clients.DisplayMember = "username";
                list_box_clients.ValueMember = "ID";
                list_box_clients.DataSource = client_table;
            }
        }

        //SHOWING SERVERS
        private void PopulateServers()
        {
            string query = "SELECT IP FROM gpclients " +
                           "WHERE is_server = 1;";

            using (connection = new SqlConnection(connection_string))
            using (SqlDataAdapter adapter = new SqlDataAdapter(query, connection))
            {

                DataTable server_table = new DataTable();
                adapter.Fill(server_table);

                list_box_servers.DisplayMember = "ip";
                list_box_servers.ValueMember = "ID";
                list_box_servers.DataSource = server_table;
            }
        }

        private void list_box_clients_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateServers();
        }

        //ADDING CLIENTS
        private void btn_add_client_Click(object sender, EventArgs e)
        {
            string query = "INSERT INTO gpclients VALUES (@gpclientsusername, '4.4.4.4' , 1)";

            using (connection = new SqlConnection(connection_string))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();

                command.Parameters.AddWithValue("@gpclientsusername", txt_client_name.Text);

                command.ExecuteScalar();

            }

            PopulateClients();
        }

        //UPDATING CLIENT VALUES (like usernames)
        private void btn_update_Click(object sender, EventArgs e)
        {
            string query = "UPDATE gpclients SET username = @gpclientsusername WHERE ID = @gpclientsID";

            using (connection = new SqlConnection(connection_string))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();

                command.Parameters.AddWithValue("@gpclientsusername", txt_client_name.Text);
                command.Parameters.AddWithValue("@gpclientsID", list_box_clients.SelectedValue);

                command.ExecuteScalar();

            }

            PopulateClients();
        }

        //DELETE CLIENTS FROM TABLE
        private void btn_delete_client_Click(object sender, EventArgs e)
        {
            string query = "DELETE FROM gpclients WHERE ID = @gpclientsID";

            using (connection = new SqlConnection(connection_string))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();

                command.Parameters.AddWithValue("@gpclientsID", list_box_clients.SelectedValue);

                command.ExecuteScalar();

            }

            PopulateClients();
        }
    }
}
