using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

namespace VGDatabase
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string term = txtSearch.Text;
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["Desktop Door"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connString))
            {
                
            }
        }
    }
}