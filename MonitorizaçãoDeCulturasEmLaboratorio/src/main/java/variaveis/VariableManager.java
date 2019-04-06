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
     * Adds a new variable to the database.
     * TODO check for errors such as inserting something when pk already exists
     * @param variable the variable to be inserted.
     */
    public void addVariable(Variable variable){
        DatabaseConnection db = DatabaseConnection.getInstance();

        if(db.isConnected()) {
            db.insertVariable(variable);
        }

        updateLocalVariables();
    }

}
