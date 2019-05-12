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

		
		double limite=-1000;
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteInferiorTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists=false;
		if(limite!=-1000) {
			exists=true;
		}
		assertEquals(exists,true);
		limite=-1000;
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteSuperiorTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists1=false;
		if(limite!=-1000) {
			exists1=true;
		}
		assertEquals(exists1,true);
		limite=-1000;
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteInferiorLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists2=false;
		if(limite!=-1000) {
			exists2=true;
		}
		assertEquals(exists2,true);
		limite=-1000;
		
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "LimiteSuperiorLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists3=false;
		if(limite!=-1000) {
			exists3=true;
		}
		assertEquals(exists3,true);
		limite=-1000;
		
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "PercentagemVariacaoTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists4=false;
		if(limite!=-1000) {
			exists4=true;
		}
		assertEquals(exists4,true);
		limite=-1000;
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "PercentagemVariacaoLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists5=false;
		if(limite!=-1000) {
			exists5=true;
		}
		assertEquals(exists5,true);
		limite=-1000;
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "MargemSegurancaLuz");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists6=false;
		if(limite!=-1000) {
			exists6=true;
		}
		assertEquals(exists6,true);
		limite=-1000;
		
		try {
			limite= db.viewTable(DatabaseConnection.getConnection(), "sistema", "MargemSegurancaTemperatura");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		boolean exists7=false;
		if(limite!=-1000) {
			exists7=true;
		}
		assertEquals(exists7,true);
		
		String className =db.getGestor().getClass().getSimpleName(); 
		assertEquals(className.equals("GestorDeMedicoes"),true);
	}

}
