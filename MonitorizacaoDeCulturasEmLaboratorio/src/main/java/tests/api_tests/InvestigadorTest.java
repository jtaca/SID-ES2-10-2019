package tests.api_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import api.Investigador;

class InvestigadorTest {

	@Test
	void testInvestigador() {
		
		Investigador i = new Investigador("123", "testeInvestigador", "teste@gmail.com", "categoria");
		
		assertTrue(i.getCategory().equals("categoria"));
		assertTrue(i.getEmail().equals("teste@gmail.com"));
		assertTrue(i.getName().equals("testeInvestigador"));
		assertTrue(i.getPassword().equals("123"));
		
		i.setCategory("eng");
		i.setEmail("testeTeste@gmail.com");
		i.setName("investigador");
		i.setPassword("1234");
		
		assertTrue(i.getCategory().equals("eng"));
		assertTrue(i.getEmail().equals("testeTeste@gmail.com"));
		assertTrue(i.getName().equals("investigador"));
		assertTrue(i.getPassword().equals("1234"));
		
		assertTrue(i.toString().equals("Investigador{" +
                "password='" + "1234" + '\'' +
                ", name='" + "investigador" + '\'' +
                ", email='" + "testeTeste@gmail.com" + '\'' +
                ", category='" + "eng" + '\'' +
                '}'));
	}

}
