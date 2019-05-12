package medicao;


import java.time.LocalDateTime;

import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.json.JSONObject;

public class Medicao {
	private String timestamp;
	private double temperatura;
	private double luminosidade;
	private boolean alertaLuminosidade;
	private boolean alertaTemperatura;
	private boolean erroTemperatura;
	private boolean erroLuminosidade;
	private boolean exportadoParaOMongo;
	private String causaTemperatura;
	private String causaLuminosidade;

	/**
	 * This class represents a sensor measurement.
	 * @param message is the measurement used to build the object.	 
	 */

	public Medicao(MqttMessage message) {
		super();
		parseMessage(message);
		alertaLuminosidade = false;
		alertaTemperatura = false;
		erroTemperatura = false;
		erroLuminosidade = false;
		exportadoParaOMongo=false;
		causaLuminosidade="";
		causaTemperatura="";
	}



	/**
	 * @return Returns what motivated the temperature alert.
	 */

	public String getCausaTemperatura() {
		return causaTemperatura;
	}


	/**
	 * Allows you to change the cause of the temperature alert.
	 * @param causaTemperatura represents what motivated the temperature alert.
	 */

	public void setCausaTemperatura(String causaTemperatura) {
		this.causaTemperatura = causaTemperatura;
	}

	/**
	 * @return Returns what motivated the brightness alert.
	 */

	public String getCausaLuminosidade() {
		return causaLuminosidade;
	}

	/**
	 * Allows you to change the cause of the brightness alert.
	 * @param causaLuminosidade represents what motivated the brightness alert.
	 */
	public void setCausaLuminosidade(String causaLuminosidade) {
		this.causaLuminosidade = causaLuminosidade;
	}

	/**
	 * It analyzes the received message from the sensor and assigns the values to the respective attributes of the measurement.
	 * @param message is the measurement coming from the sensor.
	 */

	public void parseMessage(MqttMessage message) {

		String aux = message.toString().replace("\"\"sens", "\",\"sens");
		JSONObject obj = new JSONObject(aux);


		if( aux.contains("cell")) {
			String luz = obj.getString("cell");
			this.luminosidade = Integer.parseInt(luz);
		} else {
			this.luminosidade = -999;
		}
		if( aux.contains("tmp")) {
			String temperatura = obj.getString("tmp");
			this.temperatura = Double.parseDouble(temperatura);
		}else {
			this.temperatura = -10000;
		}

		this.timestamp = parseDate();

	}


	/**
	 * Lets you specify whether or not a temperature measurement is an alert.
	 * @param alertaLuminosidade indicates whether or not the  temperature measurement is an alert.
	 */

	public void setAlertaLuminosidade(boolean alertaLuminosidade) {
		this.alertaLuminosidade = alertaLuminosidade;
	}

	/**
	 * Lets you specify whether or not a brightness measurement represents an alert.
	 * @param alertaTemperatura indicates whether or not the brightness measurement is an alert.
	 */
	public void setAlertaTemperatura(boolean alertaTemperatura) {
		this.alertaTemperatura = alertaTemperatura;
	}

	/**
	 * Lets you specify whether or not a temperature measurement is a sensor measurement error.
	 * @param erroTemperatura indicates whether or not the brightness measurement is a sensor measurement error.
	 */

	public void setErroTemperatura(boolean erroTemperatura) {
		this.erroTemperatura = erroTemperatura;
	}

	/**
	 * @return the date of measurement.
	 */

	public String getTimestamp() {
		return timestamp;
	}

	/**
	 * @return the temperature value.
	 */
	public double getTemperatura() {
		return temperatura;
	}

	/**
	 * @return the brightness value.
	 */
	public double getLuminosidade() {
		return luminosidade;
	}

	/**
	 * @return 1 if the brightness measurement is an alert and 0 otherwise.
	 */

	public int isAlertaLuminosidade() {
		if(alertaLuminosidade){
			return 1;
		}else {
			return 0;
		}
	}

	/**
	 * @return 1 if the temperature measurement is an alert and 0 otherwise.
	 */

	public int isAlertaTemperatura() {
		if(alertaTemperatura){
			return 1;
		}else {
			return 0;
		}
	}

	/**
	 * @return 1 if the temperature measurement is an error and 0 otherwise.
	 */

	public int isErroTemperatura() {
		if(erroTemperatura){
			return 1;
		}else {
			return 0;
		}
	}

	/**
	 * @return 1 if the brightness measurement is an error and 0 otherwise.
	 */

	public int isErroLuminosidade() {
		if(erroLuminosidade){
			return 1;
		}else {
			return 0;
		}
	}

	/**
	 * @return true if the measurement was exported to the mongo database and false otherwise.
	 */
	public boolean isExportadoParaOMongo() {
		return exportadoParaOMongo;
	}

	/**
	 * Lets you specify whether a measurement has been exported to the mongo database or not.
	 * @param exportadoParaOMongo represents whether a measurement has been exported to the mongo database or not.
	 */

	public void setExportadoParaOMongo(boolean exportadoParaOMongo) {
		this.exportadoParaOMongo = exportadoParaOMongo;
	}

	/**
	 * Lets you specify whether a measurement of brightness is a sensor error or not.
	 * @param erroLuminosidade represents whether a measurement of brightness is a measurement error or not.
	 */
	public void setErroLuminosidade(boolean erroLuminosidade) {
		this.erroLuminosidade = erroLuminosidade;
	}

	/**
	 * @return the date in the desired format.
	 */

	public String parseDate() {
		String currentDate = LocalDateTime.now() +"";
		String replacedDate = currentDate.replace('T', ' ');
		return replacedDate.substring(0, replacedDate.length()-4);

	}


	@Override
	public String toString() {
		return "Medicao [timestamp=" + timestamp + ", temperatura=" + temperatura + ", luminosidade=" + luminosidade
				+ ", alertaLuminosidade=" + alertaLuminosidade + ", alertaTemperatura=" + alertaTemperatura
				+ ", erroTemperatura=" + erroTemperatura + ", erroLuminosidade=" + erroLuminosidade + "]";
	}

}
