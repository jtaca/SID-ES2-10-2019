package tests.api_tests;

import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;
import api.Investigador;
import api.InvestigadorManager;

class InvestigadorManagerTest {

	private static List<Investigador> list;
	private boolean insert = false;
	
	@Test
	void testGetDBInvestigador() {
		
		InvestigadorManager im = new InvestigadorManager();
		
		Investigador i = new Investigador("testeapi", "TesteAPI", "testeapi@gmail.com", "teste");
		Investigador newi = new Investigador("testeapi", "TesteAPIES", "testeapies@gmail.com", "testeteste");
		
		im.insertInvestigador(i);
		
		im.getDBInvestigador();
		list=im.getListOfInvestigadores();
		assertNotNull(list);
		
	}
}
