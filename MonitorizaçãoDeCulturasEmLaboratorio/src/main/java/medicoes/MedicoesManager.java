package medicoes;

import api.DatabaseConnection;
import com.mysql.cj.jdbc.CallableStatement;
import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class MedicoesManager {

  private final String TABELA_CULTURA = "medicoes";
  private List<Medicoes> listOfMedicoes = new ArrayList<Medicoes>();


  public List<Medicoes> getListOfMedicoes() {
      return listOfMedicoes;
  }


  public void getDBMedicoes() {

      DatabaseConnection DB = DatabaseConnection.getInstance();

      if(DB.isConnected()) {
          listOfMedicoes.clear();
          ResultSet medicoesResultSet = DB.select("SELECT * FROM estufa.medicoes");
          try {
              addMedicoes(medicoesResultSet);
          } catch (SQLException sqlException) {
              sqlException.printStackTrace();
          }
      }
  }

  private void addMedicoes (ResultSet varMedicao) throws SQLException {

      while(varMedicao.next()) {
          int numeroMedicao = varMedicao.getInt("NumeroMedicao");
          String dataHoraMedicao = varMedicao.getString("DataHoraMedicao");
          double valorMedicao = varMedicao.getDouble("ValorMedicao");
          int idVariaveisMedidas = varMedicao.getInt("idVariaveisMedidas");

          listOfMedicoes.add(new Medicoes(numeroMedicao, dataHoraMedicao, valorMedicao, idVariaveisMedidas));

      }
  }

  public void insertMedicoes (Medicoes medicao) {

      DatabaseConnection DB = DatabaseConnection.getInstance();

      if(DB.isConnected()) {
          DB.insert(TABELA_CULTURA, medicao.toString());
      }

      getDBMedicoes();
  }


  public void deleteMedicoes (int numeroMedicao) {

      try {
          CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call apagarMedicao(?)}");
          cStmt.setString(1, ""+numeroMedicao);

          if(cStmt.execute() == false) {
              System.out.println("A medição com número: " + numeroMedicao + " foi eliminada com sucesso.");
          }
      } catch (SQLException e) {
          System.out.println("Não foi possível apagar a medição pretendida. Exception: " + e.getMessage());
      }

  }


}
