package tests.medicoes_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import cultura.Culture;
import medicoes.Measurement;
import variaveis.Variable;


class MedicoesTest {

	Measurement m;
	
	@Test
	void testeMeasurement() {
		
		Culture c1 = new Culture(2, "CultureName", "CultureDescription", "emailInvestigador");
		Culture c2 = new Culture(2, "Culture", "Description", "email");
		Variable v1 = new Variable(5, "VariableName");
		Variable v2 = new Variable(5, "Variable");
		
		Measurement m1 = new Measurement(2, "2019", 3.56, 6, v1, c1);
		Measurement m2 = new Measurement(4.56, 3);
		
		assertTrue(m1.getDataHoraMedicao().equals("2019"));
		assertTrue(m1.getIdVariaveisMedidas().equals(6));
		assertTrue(m1.getCultura().equals(c1));
		assertTrue(m1.getVariavel().equals(v1));
		assertTrue(m1.getNumeroMedicao().equals(2));
		assertTrue(m1.getValorMedicao()==3.56);
		
		m1.setCultura(c2);;
		assertTrue(m1.getCultura().equals(c2));
		m1.setVariavel(v2);
		assertTrue(m1.getVariavel().equals(v2));
		
		assertTrue(m2.toString().equals("(NULL, NULL, '4.56', '3')"));
		assertTrue(m1.toString().equals("(2, NULL, '3.56', '6')"));
		
		m1.setIdVariaveisMedidas(7);
		assertTrue(m1.getIdVariaveisMedidas().equals(7));
		
	}
	
	

}
