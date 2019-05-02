package connections;

import java.sql.SQLException;

import medicao.GestorDeMedicoes;

public class Main {

	public static void main(String[] args) throws SQLException {
	
		DatabaseConnection dc = new DatabaseConnection();
		dc.connect("java", "java");
		dc.initializeSystem();
		GestorDeMedicoes ges = dc.getGestor();
		SensorsConnection sc = new SensorsConnection(ges);	
		
	}
}
