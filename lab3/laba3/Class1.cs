using System.Data.SqlClient;
using System.Data.SqlTypes;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static int GetCostByService(SqlDateTime start, SqlDateTime end)
    {
        int rows;
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();

        SqlCommand sqlCmd = conn.CreateCommand();

        sqlCmd.CommandText = @"select  sum([Delivery items])+ sum([Windows Install]) 
                               from Service PIVOT(sum(ServiceCost) for ServiceName in([Delivery items],
                               [Windows Install])) pvt  where ServiceDate > @start or  ServiceDate < @end";
        sqlCmd.Parameters.AddWithValue("@start", start);
        sqlCmd.Parameters.AddWithValue("@end", end);

        rows = (int)sqlCmd.ExecuteScalar();
        conn.Close();

        return rows;
    }
}