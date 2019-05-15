package tests.api_tests;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;


import api.DatabaseConnection;
import javafx.util.Pair;

class DatabaseConnectionTest {
	
	private static DatabaseConnection dbconn = null;
		
	
	@Test
	void testDatabaseConnection() {
		
		dbconn = DatabaseConnection.getInstance();
		assertTrue(dbconn != null);
		
		assertFalse(dbconn.isConnected());
			
		DatabaseConnection db1 = DatabaseConnection.getInstance();
        Pair<Boolean, String> connectionState1 = db1.connect("TesteInvestigador", "iscte");
        assertTrue(db1.getUserEmail().equals("testeinvestigador@gmail.com"));
        assertTrue(db1.getUserRole().equals("investigador"));
        assertTrue(connectionState1.equals(new Pair<Boolean, String>(true, "investigador")));
        
        Pair<Boolean, String> connectionState2 = db1.connect("TesteInvestigador", "isc");
        assertTrue(connectionState2.equals(new Pair<Boolean, String>(false, "Incorrect username or password.")));
        
        Pair<Boolean, String> connectionState3 = db1.connect("root", "");
        
	}
	

}
