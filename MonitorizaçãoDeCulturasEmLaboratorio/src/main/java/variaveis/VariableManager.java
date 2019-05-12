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

    public void getDBVariables() {

        DatabaseConnection db = DatabaseConnection.getInstance();

        if(db.isConnected()) {
            variables.clear();
            ResultSet variableResultSet = db.select("SELECT * FROM estufa.variaveis");
            try {
                addVariablesResultSet(variableResultSet);
            } catch (SQLException sqlException) {
                //TODO
                sqlException.printStackTrace();
            }
        }

    }

    /**
     * Transforms all the records obtained in the data base`s variaveis table in objects medicoes. It inserts those objects in a Variable list.
     * @param variableResultSet represents the record of a variaveis extrated from the data base for a post transformation.
     */

    private void addVariablesResultSet(ResultSet variableResultSet) throws SQLException {
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

    public void insertVariable(Variable variable){
        DatabaseConnection db = DatabaseConnection.getInstance();

        if(db.isConnected()) {
            db.insert(NOME_TABELA, variable.toString());
        }
        getDBVariables();
    }


    /**
     * Tries to delete a variable by calling the stored procedure apagarVariaveis with the given parameters.
     * @param variable is the object variavel that we want to delete.
     */

    public void deleteVariable (Variable variable) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call apagarVariaveis(?)}");
            cStmt.setString(1, ""+variable.getId());
            if(cStmt.execute()==false) {
                System.out.println("A variavel com id: " + variable.getId() + " e respectivas variaveis medidas e medicões foram eliminadas com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível apagar a variavel pretendida. Exception: " + e.getMessage());
        }

        getDBVariables();

    }

    /**
     * Calls a stored procedure through its name that is entered as an argument. Method to help update the limits of temperature and luminosity of the greenhouse.
     * @param sp the name of the stored procedure to be called (alterarLimitesTemperatura and alterarLimitesLuz).
     * @param arg1 the field to enter the lower or higher value of the luminosity or temperature limits.
     * @param arg2 the field to enter the lower or higher value of the luminosity or temperature limits.
     * @param message the field corresponding to a message that tells what has changed, whether the luminosity or temperature limits.
     */

    public void callStoredProcedure2Doubles(String sp, double arg1, double arg2, String message) {
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

    /**
     * Method that changes the values ​​of the upper and lower limits of the greenhouse temperature.
     * @param limiteInferior the value of lower limit.
     * @param limiteSuperior the value of upper limit.
     */

    public void alterarLimitesTemperatura(double limiteInferior, double limiteSuperior){
        callStoredProcedure2Doubles("alterarLimitesTemperatura",limiteInferior,limiteSuperior,
                "Os limites de Temperatura foram atualizados: limite Inferior: " + limiteInferior +
                        " e limite Superior: " + limiteSuperior );
    }


    /**
     * Method that changes the values ​​of the upper and lower limits of the greenhouse luminosity.
     * @param limiteInferior the value of lower limit.
     * @param limiteSuperior the value of upper limit.
     */

    public void alterarLimitesLuz(double limiteInferior, double limiteSuperior){
        callStoredProcedure2Doubles("alterarLimitesLuz",limiteInferior,limiteSuperior,
                "Os limites de Luz foram atualizados: limite Inferior: " + limiteInferior +
                        " e limite Superior: " + limiteSuperior );
    }

}
