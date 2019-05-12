package connections;

import java.sql.SQLException;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.eclipse.paho.client.mqttv3.MqttMessage;

import medicao.GestorDeMedicoes;

public class Main {

	public static void main(String[] args) throws SQLException, AddressException, MessagingException {

		DatabaseConnection dc = new DatabaseConnection();
		dc.connect("java", "java");
		dc.initializeSystem();
		GestorDeMedicoes ges = dc.getGestor();
		SensorsConnection sc = new SensorsConnection(ges);
		
//		MqttMessage m = new MqttMessage();
//		try {
//			sc.messageArrived(sc.topic, m);
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		System.out.println(m.getPayload());
	}

}
