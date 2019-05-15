package tests.medicoes_tests;

import static org.junit.jupiter.api.Assertions.*;
import java.util.List;
import org.junit.jupiter.api.Test;
import medicoes.Measurement;
import medicoes.MeasurementManager;

class MedicoesManagerTest {

	List<Measurement> list = null;
	boolean insert = false;
	
	@Test
	void testeMeasurementManager() {
		
		MeasurementManager m = new MeasurementManager();
		
		Measurement medicao = new Measurement(40, null, 3.56, 1, "Chumbo");
		Measurement newMedicao1 = new Measurement(null, null, 4.56, 1, "Chumbo");
		Measurement newMedicao2 = new Measurement(40, null, 4.56, 1, "Chumbo");
		
		m.insertMedicoes(medicao);
		
		m.getDBMedicoes();
		
		list = m.getListOfMedicoes();
		assertNotNull(list);
		m.updateMedicoes(medicao, newMedicao1);
		m.deleteMedicoes(medicao);
		
	}


}
