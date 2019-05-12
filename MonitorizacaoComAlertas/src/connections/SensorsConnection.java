package connections;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import medicao.GestorDeMedicoes;
import medicao.Medicao;


/**
 * Connects to sensors.
 */
public class SensorsConnection implements MqttCallback {

	String topic= "/sid_lab_2019_2";  
	MqttClient client;
	String broker= "tcp://broker.mqtt-dashboard.com:1883";
	//String broker= "tcp://iot.eclipse.org:1883";
	String clientId= "clientId-OJtthizHtB";
	GestorDeMedicoes ges;

	/**
	 * Creates a connection to sensors.
	 * @param ges is an instance of the class that manages the measurements received from the sensor.
	 */
	public SensorsConnection(GestorDeMedicoes ges) {
		this.ges=ges;
		init();
	}

	/**
	 * Reconnect the sensors if the previous one is lost.
	 * @param cause is what motivated the loss of the link.
	 */
	@Override
	public void connectionLost(Throwable cause) { 
		System.out.println("Erro: " + cause.toString());
		init();
	}

	/**
	 *  Receives a message from the given topic as an argument.
	 * @param topic is the topic.
	 * @param message is the received message
	 */
	@Override
	public void messageArrived(String topic, MqttMessage message) throws Exception {
		
		if(message.toString().contains("{") && message.toString().contains("}") &&( message.toString().contains("cell")) || message.toString().contains("tmp")){
			Medicao medicao= new Medicao (message);
			ges.adiciona(medicao);
		}else {
			System.out.println("Mensagem não reconhecida.");
		}

	}


	/**
	 *  Initializes the connection.
	 */
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

	/**
	 * Return the attribute relative to the measurement manager.
	 * @return object 'GestorDeMedicoes'.
	 */
	public GestorDeMedicoes getGes() {
		return ges;
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
	}
	/**
	 * @return attribute 'client'.
	 */
	public MqttClient getClient() {
		return client;
	}

	
}

