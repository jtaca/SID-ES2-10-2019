package api;
import javafx.util.Pair;

import java.sql.*;


public class DatabaseConnection {

    private static DatabaseConnection single_instance = null;
	private static Connection conn = null;

	private static String userEmail = null;

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
	
    /**
     * Gets  boolean with the state of the connection to the database 
     * @return boolean, that contains the connection state
     */

    public boolean isConnected() {
	    return conn != null;
    }
    
    
    /**
     * Gets the User email attribute associated 
     * @return String, that contains the user's email
     */


    public static String getUserEmail() {
        return userEmail;
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
            conn = DriverManager.getConnection("jdbc:mysql://localhost/estufa?&serverTimezone=UTC&user=" + username + "&password=" + password + "&noAccessToProcedureBodies=true");
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
        userEmail = getDBUserEmail();
        System.out.println(userEmail);

	    return(new Pair<Boolean, String>(true, getRoleLogin()));
    }
	
    /**
     * Attempts to get the role of the user
     * @return String that contains the User's role
     */


    private String getRoleLogin(){

        DatabaseConnection DB = getInstance();
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
    
    
    /**
     * Attempts to get the email of the user
     * @return String that contains the User's email
     */


    private String getDBUserEmail(){

        DatabaseConnection DB = getInstance();
        String email = "";

        if(DB.isConnected()) {
            ResultSet variableResultSet = DB.select("SELECT email from mysql.user where CONCAT(User, \"@%\")=CURRENT_USER");
            try {

                variableResultSet.next();
                email = variableResultSet.getString("email");


            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }
        return email;
    }
    
    
    /**
     * Attempts to make a select action on the db.
     * @param String query
     * @return ResultSet, that contains the result of a select
     */


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
	
    
    /**
     * Attempts to do an insert action in the database.
     * @param String table
     * @param String values
     */


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
