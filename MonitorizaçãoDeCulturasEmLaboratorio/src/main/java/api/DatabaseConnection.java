package main.java.api;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;


public class DatabaseConnection {

	private static Connection conn = null;

	public DatabaseConnection() {

		// vou meter isto bonitinho em termos de extrutura � s� mm para poderem trabalhar

		try {
			conn =
					DriverManager.getConnection("jdbc:mysql://localhost/estufa?&serverTimezone=UTC&" +
							"user=root&password="); // mudar para phpUser maybe?

			// Do something with the Connection

		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}

	}

	public ResultSet select(String query) {

		// assume that conn is an already created JDBC connection (see previous examples)

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

		}
		catch (SQLException ex){
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}

		return rs;
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
