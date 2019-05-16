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
	private double tempoEntreAlertasConsecutivos;
	private double tempoExport;

    /**
	 *  Creates the system that represents the greenhouse.
	 *  @param limiteInferiorTemperatura is the lower limit of temperature of the stove.
	 *  @param limiteSuperiorTemperatura is the upper limit of temperature of the stove.
	 *  @param limiteInferiorLuz is the lower limit of brightness of the stove.
	 *  @param limiteSuperiorLuz is the upper limit of brightness of the stove.
	 *  @param percentagemVariacaoTemperatura is the maximum percentage of variation relative to the upper and lower limits of temperature between a measurement and the two previous ones so that it is considered a measurement error if it is exceeded.
	 *  @param percentagemVariacaoLuz is the maximum percentage of variation relative to the upper and lower limits of brightness between a measurement and the two previous ones so that it is considered a measurement error if it is exceeded.
	 *  @param margemSegurancaLuz is the maximum percentage of variation that a brightness measurement may be below the upper limit and above the lower limit so as not to be considered a measurement error.
	 *  @param margemSegurancaTemperatura is the maximum percentage of variation that a temperature measurement may be below the upper limit and above the lower limit so as not to be considered a measurement error.
     *  @param tempoEntreAlertasConsecutivos is the minimum time between alerts.
	 */

	public Sistema(double limiteInferiorTemperatura, double limiteSuperiorTemperatura, double limiteInferiorLuz,
			double limiteSuperiorLuz, double percentagemVariacaoTemperatura, double percentagemVariacaoLuz,
			double margemSegurancaLuz, double margemSegurancaTemperatura, double tempoEntreAlertasConsecutivos, double tempoExport) {
		super();
		this.limiteInferiorTemperatura = limiteInferiorTemperatura;
		this.limiteSuperiorTemperatura = limiteSuperiorTemperatura;
		this.limiteInferiorLuz = limiteInferiorLuz;
		this.limiteSuperiorLuz = limiteSuperiorLuz;
		this.percentagemVariacaoTemperatura = percentagemVariacaoTemperatura;
		this.percentagemVariacaoLuz = percentagemVariacaoLuz;
		this.margemSegurancaLuz = margemSegurancaLuz;
		this.margemSegurancaTemperatura = margemSegurancaTemperatura;
		this.tempoEntreAlertasConsecutivos = tempoEntreAlertasConsecutivos;
		this.tempoExport = tempoExport;
	}

	/**
	 *  @return the lower limit of temperature.
	 */

	public double getLimiteInferiorTemperatura() {
		return limiteInferiorTemperatura;
	}

	/**
	 *  @return the upper limit of temperature.
	 */

	public double getLimiteSuperiorTemperatura() {
		return limiteSuperiorTemperatura;
	}

	/**
	 *  @return the lower limit of brightness.
	 */

	public double getLimiteInferiorLuz() {
		return limiteInferiorLuz;
	}

	/**
	 *  @return the upper limit of brightness.
	 */

	public double getLimiteSuperiorLuz() {
		return limiteSuperiorLuz;
	}

	/**
	 *  @return the maximum percentage of variation relative to the upper and lower limits of temperature between a measurement and the two previous ones so that it is considered a measurement error if it is exceeded.
	 */ 

	public double getPercentagemVariacaoTemperatura() {
		return percentagemVariacaoTemperatura;
	}

	/**
	 *  @return the maximum percentage of variation relative to the upper and lower limits of brightness between a measurement and the two previous ones so that it is considered a measurement error if it is exceeded.
	 */ 

	public double getPercentagemVariacaoLuz() {
		return percentagemVariacaoLuz;
	}

	/**
	 *  @return the maximum percentage of variation that a brightness measurement may be below the upper limit and above the lower limit so as not to be considered a measurement error.
	 */ 

	public double getMargemSegurancaLuz() {
		return margemSegurancaLuz;
	}

	/**
	 *  @return the maximum percentage of variation that a temperature measurement may be below the upper limit and above the lower limit so as not to be considered a measurement error.
	 */ 

	public double getMargemSegurancaTemperatura() {
		return margemSegurancaTemperatura;
	}

    /**
     *  @return the minimum time between system alerts.
     */
    public double getTempoEntreAlertasConsecutivos() {
        return tempoEntreAlertasConsecutivos;
    }

    /**
     * @return the time between exports
     */
    public double getTempoExport() {
        return tempoExport;
    }
}
