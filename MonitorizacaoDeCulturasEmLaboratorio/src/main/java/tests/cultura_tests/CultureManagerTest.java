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
		
		Culture c1 = new Culture(40, "Pimentos", "Cultura", "testeinvestigador@gmail.com");
		Culture c2 = new Culture(null, "Laranjas", "Cultura", "testeinvestigador@gmail.com");
		
		cm.insertCulture(c2);
		
	}

}
