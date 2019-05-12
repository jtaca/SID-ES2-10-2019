package connections;

import export.AndroidAlert;
import export.Measurement;
import javafx.util.Pair;
import medicao.GestorDeMedicoes;
import medicao.Sistema;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;


@SuppressWarnings("restriction")
public class DatabaseConnection {

	private static Connection conn = null;
	private static DatabaseConnection single_instance = null;
	private static GestorDeMedicoes ges ;

	/**
	 * Attempts to establish a connection to the database with the given parameters.
	 * @param username is the username.
	 * @param password is the password.
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

			return(new Pair<>(false, error));
		}
		return(new Pair<>(true, ""));
	}


	public static Connection getConnection() {
		return conn;
	}

	/**
	 * Returns an instance of the connection.
	 * @return an instance of the connection.
	 */

	public static DatabaseConnection getInstance(){
		if(single_instance == null) {
			single_instance = new DatabaseConnection();
		}
		return single_instance;
	}

	/**
	 * Does a select to a table given by the parameter table.
	 * @param con is the connection to the database.
	 * @param table is the name of the table.
	 * @param column is the column of the table that we want to select
	 * @return a double value relative to the select.
	 */

	public double viewTable(Connection con,String table, String column)
			throws SQLException {
		double res = 0;
		Statement stmt = null;
		String query = "select " + table + "."  + column + " from estufa." + table  ;
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


	/**
	 * Creates a'system' object which contains all the information on the greenhouse.
	 * @return system object .
	 */


	public Sistema initializeSystem() {
		Sistema sis=null;

		try {
			double limiteInferiorTemperatura = viewTable(conn,"sistema", "LimiteInferiorTemperatura");
			double limiteSuperiorTemperatura = viewTable(conn,"sistema", "LimiteSuperiorTemperatura");
			double limiteInferiorLuz = viewTable(conn,"sistema", "LimiteInferiorLuz");
			double limiteSuperiorLuz = viewTable(conn,"sistema", "LimiteSuperiorLuz");
			double percentagemVariacaoTemperatura = viewTable(conn,"sistema", "PercentagemVariacaoTemperatura");
			double percentagemVariacaoLuz = viewTable(conn,"sistema", "PercentagemVariacaoLuz");
			double margemSegurancaLuz = viewTable(conn,"sistema", "MargemSegurancaLuz");
			double margemSegurancaTemperatura = viewTable(conn,"sistema", "MargemSegurancaTemperatura");
			sis= new Sistema (limiteInferiorTemperatura,limiteSuperiorTemperatura,limiteInferiorLuz,limiteSuperiorLuz,percentagemVariacaoTemperatura,percentagemVariacaoLuz,margemSegurancaLuz,margemSegurancaTemperatura);
			ges = new GestorDeMedicoes(sis);
		} catch (SQLException e) {
			System.out.println("Erro "+ e.getMessage());
		}

		return sis;

	}

	/**
	 * Return the attribute relative to the measurement manager.
	 * @return object 'GestorDeMedicoes'.
	 */
	public GestorDeMedicoes getGestor() {
		return ges;
	}

    public void insertMeasurement(Measurement measurement) throws SQLException {
        Statement stmt = null;
        String query = "INSERT INTO "
                + getTableNameFromType(measurement.getType(), measurement.isError())
                + " VALUES " + measurement.toString();

        System.out.println(query);
        executeStatement(stmt, query);
    }

    public void insertAlert(AndroidAlert alert) throws SQLException {
        Statement stmt = null;
        String query = "INSERT INTO "
                + "alertas"
                + " VALUES " + alert.toString();

        System.out.println(query);
        executeStatement(stmt, query);
    }

    private void executeStatement(Statement stmt, String query) throws SQLException {
        try {
            stmt = conn.createStatement();
            int result = stmt.executeUpdate(query);
        } catch (SQLException e ) {
            e.printStackTrace();
        } finally {
            if (stmt != null) { stmt.close(); }
        }
    }

    private enum TableNames {
	    LIGHT("medicoes_luminosidade"),
        TEMP("medicoes_temperatura"),
        LIGHT_ERROR("medicoes_luminosidade_incorretas"),
        TEMP_ERROR("medicoes_temperatura_incorretas");

	    private String tableName;

        TableNames(String tableName) {
            this.tableName = tableName;
        }
    }

    public String getTableNameFromType(Measurement.MeasurementType type, boolean error) {
        String tableName;
        if(type == Measurement.MeasurementType.LIGHT) {
            if(error) {
                tableName = TableNames.LIGHT_ERROR.tableName;
            } else {
                tableName = TableNames.LIGHT.tableName;
            }
        } else { // Temp
            if(error) {
                tableName = TableNames.TEMP_ERROR.tableName;
            } else {
                tableName = TableNames.TEMP.tableName;
            }
        }
        return tableName;
    }
}
