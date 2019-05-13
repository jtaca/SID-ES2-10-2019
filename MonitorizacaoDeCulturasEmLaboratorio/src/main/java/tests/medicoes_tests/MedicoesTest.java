package tests.medicoes_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import medicoes.Measurement;


class MedicoesTest {

	Measurement m;
	
	@Test
	void testeMeasurement() {
		Measurement m1 = new Measurement(2, "2019", 3.56, 6, "Chumbo");
		Measurement m2 = new Measurement(4.56, 3);
		
		assertTrue(m1.getDataHoraMedicao().equals("2019"));
		assertTrue(m1.getIdVariaveisMedidas().equals(6));
		assertTrue(m1.getNomeVariavel().equals("Chumbo"));
		assertTrue(m1.getNumeroMedicao().equals(2));
		assertTrue(m1.getValorMedicao()==3.56);
		
		m1.setNomeVariavel("Mercurio");
		assertTrue(m1.getNomeVariavel().equals("Mercurio"));
		
		assertTrue(m2.toString().equals("(NULL, NULL, '4.56', '3')"));
		assertTrue(m1.toString().equals("(2, NULL, '3.56', '6')"));
	}
	
	

}
