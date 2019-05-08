package medicoes;

public class Medicoes {

    private Integer numeroMedicao;
    private String dataHoraMedicao;
    private double valorMedicao;
    private Integer idVariaveisMedidas;

    public Medicoes (Integer numeroMedicao, String dataHoraMedicao, double valorMedicao, Integer idVariaveisMedidas){
        this.numeroMedicao = numeroMedicao;
        this.dataHoraMedicao = dataHoraMedicao;
        this.valorMedicao = valorMedicao;
        this.idVariaveisMedidas = idVariaveisMedidas;
    }

    public Medicoes (double valorMedicao, Integer idVariaveisMedidas){
        this.dataHoraMedicao = dataHoraMedicao;
        this.valorMedicao = valorMedicao;
        this.idVariaveisMedidas = idVariaveisMedidas;
    }

    public Integer getNumeroMedicao() {
        return numeroMedicao;
    }

    public String getDataHoraMedicao(){
        return dataHoraMedicao;
    }

    public double getValorMedicao(){
        return valorMedicao;
    }

    public Integer getIdVariaveisMedidas(){
        return idVariaveisMedidas;
    }

    @Override
    public String toString() {
        if(numeroMedicao == null) {
            return "(NULL, NULL, '" + valorMedicao + "', '" + idVariaveisMedidas + "')";
        } else {
            return "(" + numeroMedicao + ", NULL, '" + valorMedicao + "', '" + idVariaveisMedidas + "')";
        }
    }
}
