package medicoes;

import api.DatabaseConnection;
import cultura.Culture;

import com.mysql.cj.jdbc.CallableStatement;

import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Class responsible for manipulating measurements made by investigators the respective variables for their cultures.
 * Has methods to insert, remove and select measures.
 */

public class MeasurementManager {

    private final String TABELA_CULTURA = "medicoes";
    private List<Measurement> listOfMedicoes = new ArrayList<Measurement>();

    /**
     * @return an ArrayList of all the measures in the database;
     */

    public List<Measurement> getListOfMedicoes() {
        return listOfMedicoes;
    }

    /**
     * Extracts all records from the medicoes table measurements from the database.
     */

    public void getDBMedicoes() {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfMedicoes.clear();
            ResultSet medicoesResultSet = DB.select("SELECT * FROM estufa.medicoes");
            try {

                addMedicoes(extractMedicoes(medicoesResultSet));
            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }
    }

    private List<Measurement> extractMedicoes (ResultSet varMedicao) throws SQLException {
        List<Measurement> AuxlistOfMedicoes = new ArrayList<Measurement>();
        while(varMedicao.next()) {
            int numeroMedicao = varMedicao.getInt("NumeroMedicao");
            String dataHoraMedicao = varMedicao.getString("DataHoraMedicao");
            double valorMedicao = varMedicao.getDouble("ValorMedicao");
            int idVariaveisMedidas = varMedicao.getInt("idVariaveisMedidas");

            AuxlistOfMedicoes.add(new Measurement(numeroMedicao, dataHoraMedicao,
                    valorMedicao, idVariaveisMedidas));

        }
        return AuxlistOfMedicoes;
    }

    /**
     * Transforms all the records obtained in the data base`s medicoes table in objects medicoes. It inserts those objects in a medicoes list.
     * @param varMedicao represents the record of a medicao extrated from the data base for a post transformation.
     */

    private void addMedicoes (List<Measurement> extracted) {
        for (Measurement medicoes : extracted) {
            listOfMedicoes.add(medicoes);
        }
    }

    /**
     * Insert a new measure into the database. If the measure does not have an ID it will be assigned one automatically by the database auto-increment.
     * @param medicao the measure to be inserted.
     */

    public void insertMedicoes (Measurement medicao) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            DB.insert(TABELA_CULTURA, medicao.toString());
        }

        getDBMedicoes();
    }

    /**
     * Attempts to update the value of a measure in the database by invoking the stored procedure alterarValorMedido through the current measurement object and another measurement object instantiated with the value parameter to be modified, supplied as argument.
     * @param oldMedicao the oldMedicao object corresponding to the measurement and its current information.
     * @param newMedicao the newMedicao object corresponding to the same measurement instantiated only with of new value to changed.
     */

    public void updateMedicoes (Measurement oldMedicao, Measurement newMedicao) {

        try {

            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call alterarValorMedido(?,?)}");
            cStmt.setString(1, ""+oldMedicao.getNumeroMedicao());
            cStmt.setString(2, ""+newMedicao.getValorMedicao());

            if(cStmt.execute()==false) {
                System.out.println("A medição com id: " + oldMedicao.getNumeroMedicao() + " foi atualizada com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível atualizar a medição pretendida. Exception: " + e.getMessage());
        }

        getDBMedicoes();
    }

    /**
     * Delete a measure into the database.
     * @param medicao the measure to be deleted.
     */


    public void deleteMedicoes (Measurement medicao) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().
                    getConnection().prepareCall("{call apagarMedicao(?)}");
            cStmt.setString(1, ""+medicao.getNumeroMedicao());

            if(cStmt.execute() == false) {
                System.out.println("A medicao com numero: " + medicao.getNumeroMedicao() +
                        " foi eliminada com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel apagar a medicao pretendida. Exception: " + e.getMessage());
        }

        getDBMedicoes();

    }

    public List<Measurement>  selectMedicoes(Culture cultura) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall
                    ("{call selectMedicoes()}");
            boolean hadResults = cStmt.execute();
            System.out.println("Measurement tem entradas? "+ hadResults);

            if(DB.isConnected()) {
                ResultSet medicoesResultSet = DB.select("Select * FROM medicoes, variaveis_medidas WHERE IDCultura = "
                        + cultura.getId() +" and medicoes.IdVariaveisMedidas = variaveis_medidas.IdVariaveisMedidas");

            }
            ResultSet rs = cStmt.getResultSet();

            List<Measurement> AuxList =  extractMedicoes(rs);

            if(cStmt.execute()) {
                System.out.println("SelectMedicoes foi executado com sucesso!");
            }

            return AuxList;

        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar selectMedicoes. Exception: " + e.getMessage());
        }
        return null;
    }


}
