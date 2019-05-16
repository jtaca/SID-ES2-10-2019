package medicoes;

import api.DatabaseConnection;
import cultura.Culture;
import variaveis.Variable;
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
        getDBMedicoes();
        return listOfMedicoes;
    }

    /**
     * Method that obtains for each measurement extracted from the database the respective variable object that gave rise to it. For this it uses the variable culture pair id provided by each measurement.
     * @param idVariavelMedidas the id of the variable culture pair.
     * @return the variable object that gave rise to the measurement.
     * @throws SQLException
     */

    private Variable addVariableToMeasurement(int idVariavelMedidas) throws SQLException  {

        DatabaseConnection DB = DatabaseConnection.getInstance();
        Variable variavel = null;

        if(DB.isConnected()) {
            
        	ResultSet ResultSet1 = DB.select("SELECT * FROM variaveis WHERE variaveis.IDVariavel IN (SELECT IDVariavel FROM variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas=" + idVariavelMedidas + ")");
            try {

                ResultSet1.next();
                String nome = ResultSet1.getString("NomeVariavel");
                int id = ResultSet1.getInt("IDVariavel");
                
                variavel = new Variable(id, nome);
                
            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }

        return variavel;
    }
    
    /**
     * Method that obtains for each measurement extracted from the database the respective culture object that gave rise to it. For this it uses the variable culture pair id provided by each measurement.
     * @param idVariavelMedidas the id of the variable culture pair.
     * @return the culture object that gave rise to the measurement.
     * @throws SQLException
     */
    
    private Culture addCultureToMeasurement(int idVariavelMedidas) throws SQLException  {

        DatabaseConnection DB = DatabaseConnection.getInstance();
        Culture cultura = null;

        if(DB.isConnected()) {
      
            ResultSet ResultSet2 = DB.select("SELECT * FROM cultura WHERE cultura.IDCultura IN (SELECT IDCultura FROM variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas=" + idVariavelMedidas + ")");
            try {

                ResultSet2.next();
                String nome = ResultSet2.getString("NomeCultura");
                int id = ResultSet2.getInt("IDCultura");
                String des = ResultSet2.getString("DescricaoCultura");
                String email = ResultSet2.getString("EmailInvestigador");
                
                cultura = new Culture(id, nome, des, email);

            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }

        return cultura;
    }


    /**
     * Extracts all records from the measurements table measurements from the database.
     */
    
    public void getDBMedicoes() {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfMedicoes.clear();
            ResultSet medicoesResultSet = DB.select("SELECT * FROM medicoes WHERE medicoes.idVariaveisMedidas IN (SELECT idVariaveisMedidas FROM variaveis_medidas WHERE variaveis_medidas.IDCultura IN (SELECT IDCultura FROM cultura WHERE cultura.EmailInvestigador IN (SELECT email FROM mysql.user WHERE CONCAT(mysql.user.USER, \"@%\")=CURRENT_USER)))");
            try {

                addMedicoes(extractMedicoes(medicoesResultSet));

            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }

    }
    
    /**
     * An auxiliary method that transforms the measurements obtained from the database into measurement objects and also adds the variable and culture objects that gave rise to the measurement using the addVariableToMeasurement and addCultureToMeasurement methods.
     * @param varMedicao represents the record of a measurement extracted from the data base for a post transformation.
     * @return the auxiliary array list of the measurements.
     * @throws SQLException
     */

    private List<Measurement> extractMedicoes (ResultSet varMedicao) throws SQLException {
        List<Measurement> AuxlistOfMedicoes = new ArrayList<Measurement>();
        while(varMedicao.next()) {
            int numeroMedicao = varMedicao.getInt("NumeroMedicao");
            String dataHoraMedicao = varMedicao.getString("DataHoraMedicao");
            double valorMedicao = varMedicao.getDouble("ValorMedicao");
            int idVariaveisMedidas = varMedicao.getInt("idVariaveisMedidas");

            AuxlistOfMedicoes.add(new Measurement(numeroMedicao, dataHoraMedicao,
                    valorMedicao, idVariaveisMedidas, addVariableToMeasurement(idVariaveisMedidas), addCultureToMeasurement(idVariaveisMedidas)));

        }
        return AuxlistOfMedicoes;
    }

    /**
     * Transposes only the measurements from an auxiliary list to the main list listOfMedicos.
     * @param extracted the auxiliary list.
     */

    private void addMedicoes (List<Measurement> extracted) {
        for (Measurement medicoes : extracted) {
            listOfMedicoes.add(medicoes);
        }
    }

    /**
     * Insert a new measure into the database. If the measure does not have an ID it will be assigned one automatically by the database auto-increment.
     * @param medicao the measure to be inserted.
     * @throws SQLException 
     */

    public void insertMedicoes (Measurement medicao){

        DatabaseConnection DB = DatabaseConnection.getInstance();
        
        int idVariavel = medicao.getVariavel().getId();
        int idCultura = medicao.getCultura().getId();
        
        if(DB.isConnected()) {
        	
        	listOfMedicoes.clear();
            ResultSet resultSet = DB.select("SELECT IdVariaveisMedidas FROM  variaveis_medidas WHERE variaveis_medidas.IDCultura=" + idCultura + " AND variaveis_medidas.IDVariavel=" + idVariavel);
        	int idVarMed = 0;
			try {
				resultSet.next();
				idVarMed = resultSet.getInt("IdVariaveisMedidas");
			} catch (SQLException e) {
				System.out.println("Não é possivel incerir esta medição. Não existe uma variavel_medida que relacione este par variavel-cultura.");
				return;
			}
            medicao.setIdVariaveisMedidas(idVarMed);
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
                System.out.println("A medi��o com id: " + oldMedicao.getNumeroMedicao() + " foi atualizada com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi poss�vel atualizar a medi��o pretendida. Exception: " + e.getMessage());
        }

        getDBMedicoes();
    }

    /**
     * Delete a measure into the database.
     * @param medicao the measure to be deleted.
     */


    public List<Measurement> deleteMedicoes (Measurement medicao) {

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

        return getListOfMedicoes();

    }



    public List<Measurement>  selectMedicoes(Culture cultura) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall
                    ("{call selectMedicoes(?)}");
            cStmt.setString(1, "variaveis_medidas.IDCultura = " + cultura.getId() +" and medicoes.IdVariaveisMedidas = variaveis_medidas.IdVariaveisMedidas");
            cStmt.execute();
            ResultSet rs = cStmt.getResultSet();

            System.out.println(rs);

            List<Measurement> AuxList =  extractMedicoes(rs);

            System.out.println(AuxList);

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