package tests.api_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import api.DatabaseConnection;
import api.Investigador;
import api.InvestigadorManager;

class InvestigadorManagerTest {
	private InvestigadorManager inv;
	private DatabaseConnection dbconn;
	private Investigador test;

	@BeforeEach
	void setUp() throws Exception {
		 inv = new InvestigadorManager();
		 dbconn.connect("aa", "aa");
		 inv.insertInvestigador(test);
		 
	}

	@AfterEach
	void tearDown() throws Exception {
		inv.deleteInvestigador(test);
	}

	@Test
	void testInvestigadorManager() {
		 inv.getDBInvestigador();
	}

	@Test
	void testGetListOfInvestigadores() {
		fail("Not yet implemented");
	}

	@Test
	void testGetDBInvestigador() {
		fail("Not yet implemented");
	}

	@Test
	void testInsertInvestigador() {
		test = new Investigador("pass","nome","email","role");
		inv.insertInvestigador(test);
	}

	@Test
	void testUpdateInvestigador() {
		inv.updateInvestigador(test, new Investigador("pass","nome1","email","role"));
	}

	@Test
	void testDeleteInvestigador() {
		inv.insertInvestigador(test);
		inv.deleteInvestigador(test);
		inv.deleteInvestigador(test);

	}

}
