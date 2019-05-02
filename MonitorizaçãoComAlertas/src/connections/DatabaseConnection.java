package connections;

import javafx.util.Pair;
import medicao.GestorDeMedicoes;
import medicao.Sistema;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;



public class DatabaseConnection {

	private static Connection conn = null;
	private static DatabaseConnection single_instance = null;
	private static GestorDeMedicoes ges ;
	
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

	
	public  double viewTable(Connection con, String column)
		    throws SQLException {
	    	double res = 0;
		    Statement stmt = null;
		    String query = "select sistema." + column+
		                   " from estufa.sistema"  ;
		    try {
		        stmt = con.createStatement();
		        ResultSet rs = stmt.executeQuery(query);
		        while (rs.next()) {
		        	 res = rs.getDouble(column);
		           
		        }
		    } catch (SQLException e ) {
		     e.printStackTrace();
		    } finally {
		        if (stmt != null) { stmt.close(); }
		    }
			return res;
		}

	public Sistema initializeSystem() {
		Sistema sis = null;
		try {
			double limiteInferiorTemperatura = viewTable(conn, "LimiteInferiorTemperatura");
			double limiteSuperiorTemperatura = viewTable(conn, "LimiteSuperiorTemperatura");
			double limiteInferiorLuz = viewTable(conn, "LimiteInferiorLuz");
			double limiteSuperiorLuz = viewTable(conn, "LimiteSuperiorLuz");
			double percentagemVariacaoTemperatura = viewTable(conn, "PercentagemVariacaoTemperatura");
			double percentagemVariacaoLuz = viewTable(conn, "PercentagemVariacaoLuz");
			double margemSegurancaLuz = viewTable(conn, "MargemSegurancaLuz");
			double margemSegurancaTemperatura = viewTable(conn, "MargemSegurancaTemperatura");
			sis= new Sistema (limiteInferiorTemperatura,limiteSuperiorTemperatura,limiteInferiorLuz,limiteSuperiorLuz,percentagemVariacaoTemperatura,percentagemVariacaoLuz,margemSegurancaLuz,margemSegurancaTemperatura);
			ges = new GestorDeMedicoes(sis);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return sis;
		
	}
	
	public GestorDeMedicoes getGestor() {
		return ges;
	}

}
