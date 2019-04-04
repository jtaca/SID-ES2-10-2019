package main.java;

import main.java.api.DatabaseConnection;
import main.java.variaveis.VariableManager;
import main.java.variaveis.Variable;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Main {

    public static void main(String[] args) throws SQLException {
        System.out.println("Starting app...");

        // Connect to the database
        // For now we connect with the root account. This should be changed later to the user account.
        DatabaseConnection db = new DatabaseConnection();
        db.connect("root", "");

        // Prepare variables from the database
        // This can also be moved later so we only prepare them if the admin logs in
        VariableManager variableManager = new VariableManager();
        ResultSet variableResultSet = db.select("SELECT * FROM variaveis");
        while(variableResultSet.next()){
            int variableID = variableResultSet.getInt("IDVariavel");
            String variableName = variableResultSet.getString("NomeVariavel");

            variableManager.addVariavel(new Variable(variableID, variableName));
        }

        System.out.println(variableManager);



        // Test prints
        System.out.println("\nTabela de logs\n");
        ResultSet result = db.select("SELECT * FROM logs");
        while (result.next()) {
            String logid = result.getString(1);
            System.out.println("LogID: " + logid);
        }

        System.out.println("\nTabela de investigadores\n");
        result = db.select("SELECT * FROM investigador");
        while (result.next()) {
            String email = result.getString(1);
            String name = result.getString(2);
            String prof = result.getString(3);
            System.out.println("Email: " + email + " | Nome: " + name + " | Categoria: " + prof);
        }
    }

}
