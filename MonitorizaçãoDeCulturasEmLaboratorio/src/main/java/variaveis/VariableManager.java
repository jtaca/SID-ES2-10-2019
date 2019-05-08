package variaveis;

import api.DatabaseConnection;
import com.mysql.cj.jdbc.CallableStatement;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Class representing all the variables the administrator has created.
 * Has methods to add, edit and remove variables.
 */
public class VariableManager {

    private final String NOME_TABELA = "variaveis";

    private ArrayList<Variable> variables = new ArrayList<Variable>();

    public void updateLocalVariables() {
        DatabaseConnection db = DatabaseConnection.getInstance();

        if(db.isConnected()) {
            variables.clear();
            ResultSet variableResultSet = db.select("SELECT * FROM estufa.variaveis");
            try {
                processResultSet(variableResultSet);
            } catch (SQLException sqlException) {
                //TODO
                sqlException.printStackTrace();
            }
        }

    }

    private void processResultSet(ResultSet variableResultSet) throws SQLException {
        while(variableResultSet.next()){
            int variableID = variableResultSet.getInt("IDVariavel");
            String variableName = variableResultSet.getString("NomeVariavel");

            variables.add(new Variable(variableID, variableName));
        }
    }

    /**
     * @return an ArrayList of all the variables in the database.
     */
    public ArrayList<Variable> getVariables() {
        return variables;
    }

    /**
     * Insert a new variable into the database. If the variable does not have an ID it will be assigned one automatically by the database auto-increment.
     * @param variable the variable to be inserted.
     */
    public void addVariable(Variable variable){
        DatabaseConnection db = DatabaseConnection.getInstance();

        if(db.isConnected()) {
            db.insert(NOME_TABELA, variable.toString());
        }
        updateLocalVariables();
    }

    /**
     * Tries to modify the value of a measured variable with its id and the new value with the given parameters.
     * @param idMedicao is the id of the variable measured that we want to modify.
     * @param novoValor is the new value for the measurement.
     */

    public void callStoredProcedure2Doubles(String sp,double arg1, double arg2, String message) {
        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall
                    ("{call "+sp+"(?,?)}");
            cStmt.setDouble(1, arg1);
            cStmt.setDouble(2, arg2);

            if(cStmt.execute()==false) {
                System.out.println(message);
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }
    }



    public void alterarValorMedido(int idMedicao, double novoValor) {
        callStoredProcedure2Doubles("alterarValorMedido",idMedicao,novoValor,
                "A mediçao com id " + idMedicao + " foi corretamente atualizado para " + novoValor );
    }

    public void alterarLimitesTemperatura(double limiteInferior, double limiteSuperior){
        callStoredProcedure2Doubles("alterarLimitesTemperatura",limiteInferior,limiteSuperior,
                "Os limites de Temperatura foram atualizados: limite Inferior: " + limiteInferior +
                        " e limite Superior: " + limiteSuperior );
    }

}
