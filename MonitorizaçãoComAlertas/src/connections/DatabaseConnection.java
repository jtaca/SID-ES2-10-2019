package connections;

import javafx.util.Pair;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;



public class DatabaseConnection {

	private static Connection conn = null;
	 private static DatabaseConnection single_instance = null;

    /**
     * Attempts to establish a connection to the database with the given parameters.
     * @param username a username
     * @param password a password
     * @return a Boolean, String pair. The Boolean represents the success of the connection. If false, the connection failed and the String contains the appropriate error message.
     */

	public Pair<Boolean, String> connect(String username, String password) {
	    try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/estufa?&serverTimezone=UTC&user=" + username + "&password=" + password);
        } catch (SQLException ex){
            String error;
            if(ex.getErrorCode() == 1045) {
                error = "Incorrect username or password.";
            } else if (ex.getErrorCode() == 0 ) {
                error = "Couldn't connect to the database. Are you sure it is running?";
            } else {
                error = "Unknown error. Please contact the system administrator.";
            }

            return(new Pair<Boolean, String>(false, error));
        }
        return(new Pair<Boolean, String>(true, ""));
    }

    /**
     *
     * @param query
     * @return
     */
	public ResultSet select(String query) {
	    if (conn == null) {
	        return null;
        }

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

		} catch (SQLException ex){
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}

		return rs;
	}

	public Connection getConnection() {
		return conn;
	}

	
	public static DatabaseConnection getInstance(){
	    if(single_instance == null) {
	        single_instance = new DatabaseConnection();
        }
        return single_instance;
    }

//	public static ResultSet select(String query) {
//
//		// assume that conn is an already created JDBC connection (see previous examples)
//
//		Statement stmt = null;
//		ResultSet rs = null;
//
//		try {
//		    stmt = conn.createStatement();
//		    rs = stmt.executeQuery(query);
//			while (rs.next()) {
//				String coffeeName = rs.getString(1);
//				System.out.println(coffeeName);
//			}
//		    // or alternatively, if you don't know ahead of time that
//		    // the query will be a SELECT...
//
//		    if (stmt.execute(query)) {
//		        rs = stmt.getResultSet();
//
//		        return rs;
//		    }
//
//		    // Now do something with the ResultSet ....
//		}
//		catch (SQLException ex){
//		    // handle any errors
//		    System.out.println("SQLException: " + ex.getMessage());
//		    System.out.println("SQLState: " + ex.getSQLState());
//		    System.out.println("VendorError: " + ex.getErrorCode());
//		}
//		finally {
//		    // it is a good idea to release
//		    // resources in a finally{} block
//		    // in reverse-order of their creation
//		    // if they are no-longer needed
//
//		    if (rs != null) {
//		        try {
//		            rs.close();
//		        } catch (SQLException sqlEx) { } // ignore
//
//		        rs = null;
//		    }
//
//		    if (stmt != null) {
//		        try {
//		            stmt.close();
//		        } catch (SQLException sqlEx) { } // ignore
//
//		        stmt = null;
//		    }
//		}
//		return rs;
//	}


}
