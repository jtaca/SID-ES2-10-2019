package main.java;

import main.java.api.DatabaseConnection;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Main {

    public static void main(String[] args) throws SQLException {
        System.out.println("Starting app...");

        DatabaseConnection db = new DatabaseConnection();
        db.connect("root", "");

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
