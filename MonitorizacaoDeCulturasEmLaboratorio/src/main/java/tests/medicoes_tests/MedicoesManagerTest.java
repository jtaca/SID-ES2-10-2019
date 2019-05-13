package tests.medicoes_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import medicoes.Measurement;
import medicoes.MeasurementManager;

class MedicoesManagerTest {

	@Test
	void testeMeasurementManager() {
		
		MeasurementManager m = new MeasurementManager();
		
		Measurement medicao = new Measurement(null, "2019", 3.56, 1, "Chumbo");
		Measurement newMedicao = new Measurement(30, "2019", 4.56, 1, "Chumbo");
		
		m.insertMedicoes(medicao);
		m.updateMedicoes(medicao, newMedicao);
		m.deleteMedicoes(medicao);
		
		
		
	}

}
