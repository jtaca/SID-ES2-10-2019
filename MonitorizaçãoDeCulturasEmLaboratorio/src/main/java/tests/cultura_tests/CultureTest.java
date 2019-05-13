package tests.cultura_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import cultura.Culture;
import medicoes.Measurement;

class CultureTest {

	@Test
	void testeCulture() {
		
		Culture c1 = new Culture(2, "Alfaces", "Cultura", "teste@gmail.com");
		Culture c2 = new Culture("Laranjas", "Cultura", "testeteste@gmail.com");
		
		assertTrue(c1.getCultureDescription().equals("Cultura"));
		assertTrue(c1.getCultureName().equals("Alfaces"));
		assertTrue(c1.getId().equals(2));
		assertTrue(c1.getInvestigatorEmail().equals("teste@gmail.com"));
		
		assertTrue(c2.toString().equals("(NULL, 'Laranjas', 'Cultura', 'testeteste@gmail.com')"));
		assertTrue(c1.toString().equals("(2, 'Alfaces', 'Cultura', 'teste@gmail.com')"));
		
		c1.setCultureDescription("Cultura1");
		c1.setCultureName("Pimentos");
		c1.setInvestigatorEmail("teste12@gmail.com");
		assertTrue(c1.getCultureDescription().equals("Cultura1"));
		assertTrue(c1.getCultureName().equals("Pimentos"));
		assertTrue(c1.getInvestigatorEmail().equals("teste12@gmail.com"));
		
	}

}
