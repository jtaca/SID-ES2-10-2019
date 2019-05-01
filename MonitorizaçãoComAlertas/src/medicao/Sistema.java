package medicao;

public class Sistema {
	private double limiteInferiorTemperatura;
	private double limiteSuperiorTemperatura;
	private double limiteInferiorLuz;
	private double limiteSuperiorLuz;
	private double percentagemVariacaoTemperatura;
	private double percentagemVariacaoLuz;
	private double margemSegurancaLuz;
	private double margemSegurancaTemperatura;
	
	
	public Sistema(double limiteInferiorTemperatura, double limiteSuperiorTemperatura, double limiteInferiorLuz,
			double limiteSuperiorLuz, double percentagemVariacaoTemperatura, double percentagemVariacaoLuz,
			double margemSegurancaLuz, double margemSegurancaTemperatura) {
		super();
		this.limiteInferiorTemperatura = limiteInferiorTemperatura;
		this.limiteSuperiorTemperatura = limiteSuperiorTemperatura;
		this.limiteInferiorLuz = limiteInferiorLuz;
		this.limiteSuperiorLuz = limiteSuperiorLuz;
		this.percentagemVariacaoTemperatura = percentagemVariacaoTemperatura;
		this.percentagemVariacaoLuz = percentagemVariacaoLuz;
		this.margemSegurancaLuz = margemSegurancaLuz;
		this.margemSegurancaTemperatura = margemSegurancaTemperatura;
	}


	public double getLimiteInferiorTemperatura() {
		return limiteInferiorTemperatura;
	}

	public double getLimiteSuperiorTemperatura() {
		return limiteSuperiorTemperatura;
	}

	public double getLimiteInferiorLuz() {
		return limiteInferiorLuz;
	}

	public double getLimiteSuperiorLuz() {
		return limiteSuperiorLuz;
	}

	public double getPercentagemVariacaoTemperatura() {
		return percentagemVariacaoTemperatura;
	}

	public double getPercentagemVariacaoLuz() {
		return percentagemVariacaoLuz;
	}

	public double getMargemSegurancaLuz() {
		return margemSegurancaLuz;
	}

	public double getMargemSegurancaTemperatura() {
		return margemSegurancaTemperatura;
	}
	
	

}
