package JUnitTests;

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
		db.initializeSystem();

		
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
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteSuperiorTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists1=false;
		if(limite!=(Double)null) {
			exists1=true;
		}
		assertEquals(exists1,true);
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteInferiorLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists2=false;
		if(limite!=(Double)null) {
			exists2=true;
		}
		assertEquals(exists2,true);
		
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteSuperiorLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists3=false;
		if(limite!=(Double)null) {
			exists3=true;
		}
		assertEquals(exists3,true);
		
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "PercentagemVariacaoTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists4=false;
		if(limite!=(Double)null) {
			exists4=true;
		}
		assertEquals(exists4,true);
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "PercentagemVariacaoLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists5=false;
		if(limite!=(Double)null) {
			exists5=true;
		}
		assertEquals(exists5,true);
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "MargemSegurancaLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists6=false;
		if(limite!=(Double)null) {
			exists6=true;
		}
		assertEquals(exists6,true);
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "MargemSegurancaTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists7=false;
		if(limite!=(Double)null) {
			exists7=true;
		}
		assertEquals(exists7,true);
		
		
	}

}
