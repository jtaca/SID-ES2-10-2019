package connections;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken; 
import org.eclipse.paho.client.mqttv3.MqttCallback; 
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException; 
import org.eclipse.paho.client.mqttv3.MqttMessage;

import medicao.GestorDeMedicoes;
import medicao.Medicao;

public class SensorsConnection implements MqttCallback {

	String topic= "/sid_lab_2019_2";  
	MqttClient client;
	String broker= "tcp://broker.mqtt-dashboard.com:1883";
	String clientId= "clientId-OJtthizHtB";
	GestorDeMedicoes ges;

	public SensorsConnection(GestorDeMedicoes ges) {
		this.ges=ges;
		init();
	}

	@Override
	public void connectionLost(Throwable cause) { 
		System.out.println(cause.toString());
		init();
	}

	@Override
	public void messageArrived(String topic, MqttMessage message) throws Exception {
		System.out.println(message.toString() + "  CHEGOUUUU");
		Medicao medicao= new Medicao (message);
		ges.adiciona(medicao);

	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {			
	}

	public void init() {
		try {
			client = new MqttClient(broker, clientId);
			MqttConnectOptions connOpts = new MqttConnectOptions();
			connOpts.setCleanSession(true);  
			System.out.println("Conectado ao broker: "+broker);  
			client.connect(connOpts);
			client.setCallback(this);
			client.subscribe(topic);
			System.out.println("Connected");  
		} catch (MqttException exception) {		
			System.out.println("reason "+exception.getReasonCode());
			System.out.println("mensagem "+exception.getMessage());
			System.out.println("localização "+ exception.getLocalizedMessage());
			System.out.println("cause "+ exception.getCause());
			System.out.println("excepcao "+ exception);
			exception.printStackTrace();
		}
	}

}

