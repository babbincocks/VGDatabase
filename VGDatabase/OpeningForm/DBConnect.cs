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

        public static bool dataConnect()
        {
            bool returnValue;

            try
            {
                //Then it attempts to open the SqlConnection created outside of this test. If it works, it then makes the Boolean variable return
                //true.
                sqlConn.Open();
                returnValue = true;
            }

            catch
            {
                //If the connection attempt fails and raises an exception, it sets the Boolean variable to equal false, and it throws a 
                //new exception.
                returnValue = false;
                throw new Exception("Unable to connect to the VG Database. Check your settings, namely the connection string, and try again.");
            }
            finally
            {
                //Regardless of whether the attempt succeeds or not, the connection is closed.
                sqlConn.Close();
            }
            //The result of the test is then returned.
            return returnValue;

        }


    }
}
