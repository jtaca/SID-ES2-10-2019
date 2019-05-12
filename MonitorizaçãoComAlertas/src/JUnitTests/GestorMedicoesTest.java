package JUnitTests;

import static org.junit.jupiter.api.Assertions.*;

import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.junit.jupiter.api.Test;

import medicao.GestorDeMedicoes;
import medicao.Medicao;
import medicao.Sistema;

class GestorMedicoesTest {

	@Test
	void test() {
		Sistema sis = new Sistema (0,20,0,300,0.5,0.5,0.5,0.5);
		
		GestorDeMedicoes ges = new GestorDeMedicoes (sis);
		
		Sistema sis1= ges.getSistema();
		
		assertEquals(sis.equals(sis1),true);
		
		byte m [] = {123,34,116,109 ,112,34,58,34,50,54,46,53,48,34,44,34,104,117,109,34,58,34,50,55,46,57,48,34,44,34,100,97,116,34,58,34,49,50,47,53,47,50,48,49,57,34 ,44
		             ,34,116,105,109,34,58,34,49,52,58,49,50,58,52,50,34,44,34,99,101,108,108,34,58,34,52,53,54,34,34,115,101,110,115,34,58,34,101,116,104,34,125};
		
		MqttMessage men = new MqttMessage (m);
		
		Medicao med = new Medicao (men);

		assertEquals(med.getTemperatura() == 26.5,true);
		assertEquals(med.getLuminosidade() == 456.0,true);

		ges.adiciona(med);
		
	
		
		
		
		
	}

}
