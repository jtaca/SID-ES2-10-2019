package variaveis;

import api.DatabaseConnection;

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
            ResultSet variableResultSet = db.select("SELECT * FROM variaveis");
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

}
