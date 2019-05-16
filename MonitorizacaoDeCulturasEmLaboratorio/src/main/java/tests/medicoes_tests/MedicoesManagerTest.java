package tests.medicoes_tests;

import static org.junit.jupiter.api.Assertions.*;
import java.util.List;
import org.junit.jupiter.api.Test;

import cultura.Culture;
import medicoes.Measurement;
import medicoes.MeasurementManager;
import variaveis.Variable;

class MedicoesManagerTest {

	List<Measurement> list = null;
	boolean insert = false;
	
	@Test
	void testeMeasurementManager() {
		
		MeasurementManager m = new MeasurementManager();
		
		Culture c1 = new Culture(2, "CultureName", "CultureDescription", "emailInvestigador");
		Variable v1 = new Variable(5, "VariableName");
		
		Measurement medicao = new Measurement(40, null, 3.56, 1, v1, c1);
		Measurement newMedicao1 = new Measurement(null, null, 4.56, 1, v1, c1);
		Measurement newMedicao2 = new Measurement(40, null, 4.56, 1, v1, c1);
		
		m.insertMedicoes(medicao);
		
		m.getDBMedicoes();
		
		list = m.getListOfMedicoes();
		assertNotNull(list);
		m.updateMedicoes(medicao, newMedicao1);
		m.deleteMedicoes(medicao);
		
	}


}
