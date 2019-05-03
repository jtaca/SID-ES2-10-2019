package medicao;

import java.util.ArrayList;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

import connections.MongoConnection;

public class GestorDeMedicoes {
	private Sistema sistema;
	private int contador=0;
	private BlockingQueue<Medicao> bq;
	private MongoConnection mc = new MongoConnection();
	
	public GestorDeMedicoes(Sistema sistema) {
		super();
		this.sistema = sistema;
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
			if(sistema.getLimiteSuperiorLuz() - margemAlertaLuz <= m.getLuminosidade() 
					|| sistema.getLimiteInferiorLuz() + margemAlertaLuz >= m.getLuminosidade() || sistema.getLimiteInferiorLuz() >= m.getLuminosidade()
					||  sistema.getLimiteSuperiorLuz() <= m.getLuminosidade())
				m.setAlertaLuminosidade(true);
		}
			
		if(m.isErroTemperatura()==0) {
			double margemAlertaTemp = (sistema.getLimiteSuperiorTemperatura() - sistema.getLimiteInferiorTemperatura()) * sistema.getMargemSegurancaTemperatura();
		if(sistema.getLimiteSuperiorTemperatura() - margemAlertaTemp <= m.getTemperatura() || sistema.getLimiteInferiorTemperatura() + margemAlertaTemp >= m.getTemperatura() 
				|| m.getTemperatura()>= sistema.getLimiteSuperiorTemperatura() || m.getTemperatura()<=sistema.getLimiteInferiorTemperatura())
			m.setAlertaTemperatura(true);
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
