package tests.variaveis_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import variaveis.Variable;

class VariableTest {

	@Test
	void testeCulture() {
	
		Variable v1 = new Variable(2, "Chumbo");
		Variable v2 = new Variable("Chumbo");
	
		assertTrue(v1.getId().equals(2));
		assertTrue(v1.getName().equals("Chumbo"));
	
		assertTrue(v2.toString().equals("(NULL, \"" + "Chumbo" +"\")"));
		assertTrue(v1.toString().equals("(2,\"" + "Chumbo" +"\")"));
	
	}
}
