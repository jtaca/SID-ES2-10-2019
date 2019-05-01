package medicao;

import java.util.Date;

public class Medicao {
	private int id;
	private Date timestamp;
	private int temperatura;
	private int luminosidade;
	private boolean alertaLuminosidade;
	private boolean alertaTemperatura;
	private boolean erroTemperatura;
	private boolean erroLuminosidade;
	
	public Medicao(int id, Date timestamp, int temperatura, int luminosidade) {
		super();
		this.id = id;
		this.timestamp = timestamp;
		this.temperatura = temperatura;
		this.luminosidade = luminosidade;
		alertaLuminosidade = false;
		alertaTemperatura = false;
		erroTemperatura = false;
		erroLuminosidade = false;
		
	}
	
	

}
