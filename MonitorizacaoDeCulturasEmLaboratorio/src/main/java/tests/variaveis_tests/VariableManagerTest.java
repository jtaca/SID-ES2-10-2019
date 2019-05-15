package tests.variaveis_tests;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import org.junit.jupiter.api.Test;
import variaveis.Variable;
import variaveis.VariableManager;

class VariableManagerTest {

	private ArrayList<Variable> list = new ArrayList<Variable>();
	
	@Test
	void testUpdateLocalVariables() {

		
		VariableManager vm = new VariableManager();
		
		Variable var = new Variable(2, "Chumbo");
		Variable newVar = new Variable("Chumbo++");
		
		vm.insertVariable(newVar);
		
		vm.getDBVariables();;
		
		list = vm.getVariables();
		assertNotNull(list);
		//vm.updateMedicoes(medicao, newMedicao1);
		//vm.deleteMedicoes(medicao);
	}

}
