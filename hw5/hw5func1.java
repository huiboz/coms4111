
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

import redis.clients.jedis.BinaryJedis;
import org.json.*;
import javax.json.*;

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

    private static Map<String,String> find_mysql_by_id(String id) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        Map<String,String> map = new HashMap<String,String>();
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
            //System.out.println("playerID = " + playerID + ", last name = " + nameLast +
            //    ", first name = " + nameFirst + ", birth year = " + birthYear + ", birth Country = " + birthCountry);
            map.put("playerID",playerID);
            map.put("nameLast",nameLast);
            map.put("nameFirst",nameFirst);
            map.put("birthYear",birthYear);
            map.put("birthCountry",birthCountry);

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
        return map;
    }
    
    private static Map<String,String> find_redis_by_id(String id) {
        Map < String, String > result;

        //Connecting to Redis server on localhost 
        Jedis jedis = new Jedis("localhost");
        System.out.println("Connection to server sucessfully");
        result = jedis.hgetAll("players:" + id);
        jedis.close();
        return result;
    }
    
    private static void add_to_redis(String id, Map<String,String> data) {
        Jedis jedis = new Jedis("localhost");
        String result = jedis.hmset("players:"+id,data);
        if (result.substring(0,2).equals("OK"))
           System.out.println("Successfully add to redis!");
    
    }
    
    
    private static Map<String,String> find_by_id(String id) {
        Map<String, String> result;
        
        result = find_redis_by_id(id);
        
        if(result.isEmpty()) {
           System.out.println("Will load data from MySQL to Redis..");
           result = find_mysql_by_id(id);
           add_to_redis(id,find_mysql_by_id(id));
        } else {
           System.out.println("Found data in Redis");
        }
           
        return result;


    }

    public static void main(String[] args) {
        System.out.println(find_by_id("napolmi01"));
    }

}
