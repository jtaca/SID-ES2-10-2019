package tests.cultura_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import cultura.Culture;
import cultura.CultureManager;

class CultureManagerTest {

	@Test
	void cultureManagerTest() {
		
		CultureManager cm = new CultureManager();
		
		Culture c1 = new Culture(2, "Alfaces", "Cultura", "teste@gmail.com");
		Culture c2 = new Culture("Laranjas", "Cultura", "TesteInvestigador@gmail.com");
		
		cm.insertCulture(c2);
		cm.deleteCulture(c1);
		
	}

}
