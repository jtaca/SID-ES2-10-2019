package connections;

import java.sql.ResultSet;
import java.sql.SQLException;

import medicao.GestorDeMedicoes;

public class Main {

	public static void main(String[] args) throws SQLException {
	
		// liga ao relacional 
		DatabaseConnection dc = new DatabaseConnection();
		dc.connect("java", "java");
		dc.initializeSystem();
		
		
//		double res = dc.viewTable(dc.getConnection(), "LimiteInferiorLuz");
//		System.out.println(res);
		GestorDeMedicoes ges = dc.getGestor();
		
		SensorsConnection sc = new SensorsConnection(ges);		
//		ResultSet rs = dc.select("SELECT sistema.LimiteInferiorLuz FROM sistema;");
//		double luz = rs.getDouble("LimiteInferiorLuz");
//		System.out.println(luz);
		
		
		
	}

}
