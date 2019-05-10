package api;
import javafx.util.Pair;

import java.sql.*;


public class DatabaseConnection {

    private static DatabaseConnection single_instance = null;
	private static Connection conn = null;

    /**
     * Returns or creates an instance of database connection.
     * Does not establish the connection. To do that see the {@see #connect(String, String)} method.
     * @return singleton instance of the DatabaseConnection object.
     */
	public static DatabaseConnection getInstance(){
	    if(single_instance == null) {
	        single_instance = new DatabaseConnection();
        }
        return single_instance;
    }

    public boolean isConnected() {
	    return conn != null;
    }

    /**
     * Private constructor to prevent unwanted instantiation.
     */
    private DatabaseConnection() {
    }


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
	    System.out.println(new Pair<Boolean, String>(true, getRoleLogin()).toString());
        return(new Pair<Boolean, String>(true, getRoleLogin()));
    }


    private String getRoleLogin(){

        DatabaseConnection DB = DatabaseConnection.getInstance();
        String roleLogin = "";

        if(DB.isConnected()) {
            ResultSet variableResultSet = DB.select("SELECT default_role from mysql.user where CONCAT(User, \"@%\")=CURRENT_USER");
            try {

                variableResultSet.next();
                roleLogin = variableResultSet.getString("default_role");


            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }
        return roleLogin;
    }


	public ResultSet select(String query) {
	    if (!this.isConnected()) {
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

    public void insert(String table, String values) {
        if(isConnected()) {
            String insertQuery = "Insert into " + table + " values " + values;
            try {
                Statement statement = conn.createStatement();
                int result = statement.executeUpdate(insertQuery);
                System.out.println(result);

            } catch (SQLIntegrityConstraintViolationException ex) {
                System.out.println("Problem while inserting: " + ex.getMessage());
            } catch (SQLException ex) {
                ex.printStackTrace();
                if(ex.getErrorCode() == 1146) {
                    System.out.println("Table " + table + " does not exist.");
                } else {
                    System.out.println("Unknown error.");
                }
            }
        }
    }

    //"DELETE FROM `cultura` WHERE `cultura`.`IDCultura` = 4"

    /**
     * Returns the instance of que connection
     * @return a connection instance
     */

    public Connection getConnection() {
        return conn;
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
