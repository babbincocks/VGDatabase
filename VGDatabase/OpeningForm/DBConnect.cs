using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace SQLSource
{
    class DBConnect
    {
        const string CONNECTIONSTRING = @"user id=VGClient;pwd=Scuttlebug;Server=PL1\MTCDB;Database=VGDatabase;
                                            Trusted_Connection=False;";

        public static SqlConnection sqlConn = new SqlConnection(CONNECTIONSTRING);



    }
}
