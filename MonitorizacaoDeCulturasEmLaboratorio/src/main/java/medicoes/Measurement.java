package medicoes;

import cultura.Culture;
import variaveis.Variable;

/**
 *Class that represents an measurement and the respective attributes that define it.
 */

public class Measurement {

    private Integer numeroMedicao;
    private String dataHoraMedicao;
    private double valorMedicao;
    private Integer idVariaveisMedidas;
    private Variable variavel;
    private Culture cultura;

    /**
     * Class constructor used mainly to deleted measurements in database.
     * @param numeroMedicao the identifier number of measurement in the database.
     * @param dataHoraMedicao the date and time at which the measurement is inserted into the database.
     * @param valorMedicao the measured value.
     * @param idVariaveisMedidas the identifier of the variable-culture pair for which the measurement was made.
     */

    public Measurement(Integer numeroMedicao, String dataHoraMedicao, double valorMedicao, Integer idVariaveisMedidas, Variable variavel, Culture cultura){
        this.numeroMedicao = numeroMedicao;
        this.dataHoraMedicao = dataHoraMedicao;
        this.valorMedicao = valorMedicao;
        this.idVariaveisMedidas = idVariaveisMedidas;
        this.variavel = variavel;
        this.cultura = cultura;
    }

    /**
     * Class constructor used mainly to register or update informations of the measurements in database.
     * @param valorMedicao the measured or new measured value.
     * @param idVariaveisMedidas the identifier of the variable-culture pair for which the measurement was made.
     */

    public Measurement(double valorMedicao, Integer idVariaveisMedidas){
        this.valorMedicao = valorMedicao;
        this.idVariaveisMedidas = idVariaveisMedidas;
    }

    /**
     * Returns the identifier number of the measurement.
     * @return the identifier number.
     */

    public Variable getVariavel() {
        return variavel;
    }
    
    /**
     * Changes the variable object associated with the measurement.
     * @param newVariavel the new variable object.
     */

    public void setVariavel(Variable newVariavel) {
        variavel = newVariavel;
    }
    
    /**
     * @return the culture object associated with the measurement.
     */
    
    public Culture getCultura() {
        return cultura;
    }
    
    /**
     * Changes the culture object associated with the measurement.
     * @param newCultura the new culture object.
     */

    public void setCultura(Culture newCultura) {
        cultura = newCultura;
    }

    /**
     * @return the identification number of the measurement.
     */
    public Integer getNumeroMedicao() {
        return numeroMedicao;
    }

    /**
     * Returns the date and time that the measurement was entered into the database.
     * @return the date and time.
     */

    public String getDataHoraMedicao(){
        return dataHoraMedicao;
    }

    /**
     * Returns the measurement value
     * @return the value.
     */

    public double getValorMedicao(){
        return valorMedicao;
    }

    /**
     * Returns the identifier number of the variable-culture pair for which the measurement was made.
     * @return the identifier number.
     */

    public Integer getIdVariaveisMedidas(){
        return idVariaveisMedidas;
    }
    
    /**
     * @param newIdVariaveisMedidas
     */
    
    public void setIdVariaveisMedidas(int newIdVariaveisMedidas) {
    	idVariaveisMedidas = newIdVariaveisMedidas;
    }

    /**
     * A method that returns a part of the query that is responsible by inserted a measurements into the database.
     * @return Returns the query with or without the id of the measurement. If return with id a measurement is inserted into the database with the id specified by the user . If returned without id, the field in the database destined for this value is automatically attributed.
     */

    @Override
    public String toString() {
        if(numeroMedicao == null) {
            return "(NULL, NULL, '" + valorMedicao + "', '" + idVariaveisMedidas + "')";
        } else {
            return "(" + numeroMedicao + ", NULL, '" + valorMedicao + "', '" + idVariaveisMedidas + "')";
        }
    }

}