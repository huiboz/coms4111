
package hw5;

import redis.clients.jedis.Jedis;

import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.io.StringWriter;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


public class hw5func1 {

    private static java.sql.Connection getConnection() {
        java.sql.Connection conn = null;

        try {
            // You must set the schema, user ID and password for your local database.
            conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/finalexamhw5?&useSSL=false&" +
                "user=root&password=z123456");
        } catch (SQLException ex) {
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());

            conn = null;
        }

        return conn;
    }

    public static void test1() {
        Map < String, String > result;

        //Connecting to Redis server on localhost 
        Jedis jedis = new Jedis("localhost");
        System.out.println("Connection to server sucessfully");

        result = jedis.hgetAll("players:willite01");
        System.out.println("Ted Williams = " + result);
        // Get the stored data and print it 
        System.out.println("Stored string in redis:: " + jedis.get("tutorialname"));
        jedis.close();
    }

    private static JSONObject find_mysql_by_id(String id) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        JSONObject obj = new JSONObject();
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM Master WHERE playerID='" + id + "'");
            rs.first();

            String playerID, nameLast, nameFirst, birthYear, birthCountry;

            playerID = rs.getString("playerID");
            nameLast = rs.getString("nameLast");
            nameFirst = rs.getString("nameFirst");
            birthYear = rs.getString("birthYear");
            birthCountry = rs.getString("birthCountry");
            System.out.println("playerID = " + playerID + ", last name = " + nameLast +
                ", first name = " + nameFirst + ", birth year = " + birthYear + ", birth Country = " + birthCountry);
            obj.put("playerID",playerID);
            obj.put("nameLast",nameLast);
            obj.put("nameFirst",nameFirst);
            obj.put("birthYear",birthYear);
            obj.put("birthCountry",birthCountry);


            System.out.print(obj.toString());
        } catch (SQLException ex) {
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        } finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) {} // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) {} // ignore

                stmt = null;
            }
        }
        return obj;
    }

    public static void main(String[] args) {

        find_mysql_by_id("aardsda01");
        //test1();

    }

}
