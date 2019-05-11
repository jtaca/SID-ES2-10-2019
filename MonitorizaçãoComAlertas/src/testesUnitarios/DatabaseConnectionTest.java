package testesUnitarios;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;

import org.junit.jupiter.api.Test;

import connections.DatabaseConnection;

class DatabaseConnectionTest {

	@Test
	void test() {
		DatabaseConnection db = DatabaseConnection.getInstance();
		String username="java";
		String password = "java";
		db.connect(username, password);
		double limite=(Double) null;
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteInferiorTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists=false;
		if(limite!=(Double)null) {
			exists=true;
		}
		assertEquals(exists,true);
		
	}

}
