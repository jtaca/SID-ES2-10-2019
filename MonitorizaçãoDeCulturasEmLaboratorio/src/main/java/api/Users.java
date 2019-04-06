package api;

import java.sql.SQLException;

import com.mysql.cj.jdbc.CallableStatement;

public class Users {

    public Users() {

    }

    /**
     * Tries to create a user by calling the stored procedure addUser with the given parameters.
     * @param nome is the name
     * @param email is the email
     * @param categoriaProfissional is the professional category
     * @param password is the password
     * @param role is the role  that the user we want to register plays in the database
     */

    public void addUser(String nome, String email, String categoriaProfissional, String password, String role) {
        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call addUser(?,?,?,?,?)}");
            cStmt.setString(1, role);
            cStmt.setString(2, nome);
            cStmt.setString(3, password);
            cStmt.setString(4, email);
            cStmt.setString(5, categoriaProfissional);
            if(cStmt.execute()==false) {
                System.out.println("O utilizador " + nome +" foi corretamente registado" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }
    }
}
