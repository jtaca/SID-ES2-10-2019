package medicoes;

import api.DatabaseConnection;
import com.mysql.cj.jdbc.CallableStatement;
import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Class responsible for manipulating measurements made by investigators the respective variables for their cultures.
 * Has methods to insert, remove and select measures.
 */

public class MedicoesManager {

  private final String TABELA_CULTURA = "medicoes";
  private List<Medicoes> listOfMedicoes = new ArrayList<Medicoes>();


    /**
     * @return an ArrayList of all the measures in the database;
     */

  public List<Medicoes> getListOfMedicoes() {
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
              addMedicoesResultSet(medicoesResultSet);
          } catch (SQLException sqlException) {
              sqlException.printStackTrace();
          }
      }
  }

    /**
     * Transforms all the records obtained in the data base`s medicoes table in objects medicoes. It inserts those objects in a medicoes list.
     * @param varMedicao represents the record of a medicao extrated from the data base for a post transformation.
     */

  private void addMedicoesResultSet(ResultSet varMedicao) throws SQLException {

      while(varMedicao.next()) {
          int numeroMedicao = varMedicao.getInt("NumeroMedicao");
          String dataHoraMedicao = varMedicao.getString("DataHoraMedicao");
          double valorMedicao = varMedicao.getDouble("ValorMedicao");
          int idVariaveisMedidas = varMedicao.getInt("idVariaveisMedidas");

          listOfMedicoes.add(new Medicoes(numeroMedicao, dataHoraMedicao, valorMedicao, idVariaveisMedidas));

      }
  }

    /**
     * Insert a new measure into the database. If the measure does not have an ID it will be assigned one automatically by the database auto-increment.
     * @param medicao the measure to be inserted.
     */
  public void insertMedicoes (Medicoes medicao) {

      DatabaseConnection DB = DatabaseConnection.getInstance();

      if(DB.isConnected()) {
          DB.insert(TABELA_CULTURA, medicao.toString());
      }

      getDBMedicoes();
  }

    /**
     * Delete a measure into the database.
     * @param medicao the measure to be deleted.
     */

  public void deleteMedicoes (Medicoes medicao) {

      try {
          CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall
                  ("{call apagarMedicao(?)}");
          cStmt.setString(1, ""+medicao.getNumeroMedicao());

          if(cStmt.execute() == false) {
              System.out.println("A medição com número: " + medicao.getNumeroMedicao() + " foi eliminada com sucesso.");
          }
      } catch (SQLException e) {
          System.out.println("Não foi possível apagar a medição pretendida. Exception: " + e.getMessage());
      }

      getDBMedicoes();

  }

    public void selectMedicoes() {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall
                    ("{call selectMedicoes()}");
            boolean hadResults = cStmt.execute();
            System.out.println("Medições tem entradas? "+ hadResults);

            ResultSet rs = cStmt.getResultSet();
            addMedicoesResultSet(rs);

            //System.out.println("SelectMedicoesIn: "+ getListOfMedicoes().toString());


            if(cStmt.execute()) {
                System.out.println("SelectMedicoes foi executado com sucesso!");
            }
        } catch (SQLException e) {
            System.out.println("Não foi possível executar selectMedicoes. Exception: " + e.getMessage());
        }
    }


}
