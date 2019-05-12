package JUnitTests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import connections.SensorsConnection;
import medicao.GestorDeMedicoes;
import medicao.Sistema;

class SensorsConnectionTest {

	@Test
	void test() {
		
		Sistema sis = new Sistema (0,20,0,300,0.5,0.5,0.5,0.5, 15);
		
		GestorDeMedicoes ges = new GestorDeMedicoes (sis);
		
		SensorsConnection sc = new SensorsConnection(ges);
		assertEquals(sc.getGes().equals(ges),true);

		assertEquals(sc.getClient().getClass().getCanonicalName().equals("org.eclipse.paho.client.mqttv3.MqttClient"),true);
		
		
		
		
	}

}
