package medicao;

import java.util.ArrayList;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

import connections.EmailSender;
import connections.MongoConnection;

public class GestorDeMedicoes {
	private Sistema sistema;
	private int contador=0;
	private BlockingQueue<Medicao> bq;
	private MongoConnection mc = new MongoConnection();
	private EmailSender emailSender;
	
	public GestorDeMedicoes(Sistema sistema, EmailSender emailSender) {
		super();
		this.sistema = sistema;
		this.emailSender=emailSender;
		bq = new LinkedBlockingDeque<>(3);
	}
	
	public void adiciona(Medicao m) {
		try {
			if(contador > 2) {
				bq.poll();
				processaMedicao(m);
				bq.put(m);
				System.out.println(m.toString());
				mc.write(m);
				m.setExportadoParaOMongo(true);
				contador ++;
			}else {
				checkAlerts(m);
				bq.put(m);
				mc.write(m);
				m.setExportadoParaOMongo(true);
				contador ++;
			}
		} catch (InterruptedException e) {
			System.out.println("Erro " + e.getMessage());
		}
	}

	
	private void processaMedicao(Medicao m) throws InterruptedException {
		
		ArrayList<Medicao> aux = new ArrayList<Medicao>();
		bq.drainTo(aux);
		
		Medicao m1 = aux.get(0);
		Medicao m2 = aux.get(1);
		
		bq.put(m1);
		bq.put(m2);
		
		checkErrors( m,  m1,  m2);
		checkAlerts(m);
		

	}

	private void checkAlerts(Medicao m) {
		if(m.isErroLuminosidade()==0) {
			double margemAlertaLuz = (sistema.getLimiteSuperiorLuz() - sistema.getLimiteInferiorLuz()) * sistema.getMargemSegurancaLuz();
			
			
			if(sistema.getLimiteSuperiorLuz() - margemAlertaLuz <= m.getLuminosidade() ) {
				m.setAlertaLuminosidade(true);
				m.setCausaLuminosidade("O valor da medicao da luminosidade esta proximo do limite superior estabelecido.");
				emailSender.send4All("Alerta luminosidade", m.getCausaLuminosidade());
			}
			else if(sistema.getLimiteInferiorLuz() + margemAlertaLuz >= m.getLuminosidade()) {
				m.setAlertaLuminosidade(true);
				m.setCausaLuminosidade("O valor da medicao da luminosidade  esta proximo do limite inferior estabelecido.");
				emailSender.send4All("Alerta luminosidade", "Olá investigador! " + m.getCausaLuminosidade());
			}
			else if (sistema.getLimiteInferiorLuz() >= m.getLuminosidade()) {
				m.setAlertaLuminosidade(true);
				m.setCausaLuminosidade("O valor da medicao da luminosidade ultrapassou o limite inferior estabelecido.");
				emailSender.send4All("Alerta luminosidade", m.getCausaLuminosidade());
			}
			else if (  sistema.getLimiteSuperiorLuz() <= m.getLuminosidade()){
				m.setAlertaLuminosidade(true);
				m.setCausaLuminosidade("O valor da medicao da luminosidade ultrapassou o limite superior estabelecido.");
				emailSender.send4All("Alerta luminosidade", m.getCausaLuminosidade());
			}
				
				
				m.setAlertaLuminosidade(true);
		}
			
		if(m.isErroTemperatura()==0) {
			double margemAlertaTemp = (sistema.getLimiteSuperiorTemperatura() - sistema.getLimiteInferiorTemperatura()) * sistema.getMargemSegurancaTemperatura();
		if(sistema.getLimiteSuperiorTemperatura() - margemAlertaTemp <= m.getTemperatura() ) {
			m.setAlertaTemperatura(true);
			m.setCausaTemperatura("O valor da medicao da temperatura esta proximo do limite supeior estabelecido.");
			emailSender.send4All("Alerta temperatura", m.getCausaTemperatura());
		}
		else if ( sistema.getLimiteInferiorTemperatura() + margemAlertaTemp >= m.getTemperatura() ) {
			m.setAlertaTemperatura(true);
			m.setCausaTemperatura("O valor da medicao da temperatura esta proximo do limite inferior estabelecido.");
			emailSender.send4All("Alerta temperatura", m.getCausaTemperatura());
		}
		else if (m.getTemperatura()>= sistema.getLimiteSuperiorTemperatura() ) {
			m.setAlertaTemperatura(true);
			m.setCausaTemperatura("O valor da medicao da temperatura  ultrapassou o limite superior estabelecido.");
			emailSender.send4All("Alerta temperatura", m.getCausaTemperatura());
		}
		else if (m.getTemperatura()<=sistema.getLimiteInferiorTemperatura()) {
			m.setAlertaTemperatura(true);
			m.setCausaTemperatura("O valor da medicao da temperatura  ultrapassou o limite inferior estabelecido.");
			emailSender.send4All("Alerta temperatura", m.getCausaTemperatura());
		}
		}
	}

	private void checkErrors(Medicao m, Medicao m1, Medicao m2) {
		double margemErroLuz = (sistema.getLimiteSuperiorLuz() - sistema.getLimiteInferiorLuz()) * sistema.getPercentagemVariacaoLuz();
		double margemErroTemp = (sistema.getLimiteSuperiorTemperatura() - sistema.getLimiteInferiorTemperatura()) * sistema.getPercentagemVariacaoTemperatura();
		
		if ( (Math.abs(m.getLuminosidade() - m1.getLuminosidade()) > margemErroLuz) && (Math.abs(m.getLuminosidade() - m2.getLuminosidade()) > margemErroLuz || m.getLuminosidade() < 0) )
			m.setErroLuminosidade(true);
		
		if ( (Math.abs(m.getTemperatura() - m1.getTemperatura()) > margemErroTemp) && (Math.abs(m.getTemperatura() - m2.getTemperatura()) > margemErroTemp) )
			m.setAlertaTemperatura(true);	
	}

	
	
}
