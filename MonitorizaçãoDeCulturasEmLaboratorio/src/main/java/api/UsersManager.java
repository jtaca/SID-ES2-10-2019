package api;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import com.mysql.cj.jdbc.CallableStatement;
import javafx.util.Pair;

public class UsersManager {

    private final String TABELA_USERS = "user";
    private List<User> listOfUsers = new ArrayList<User>();

    public UsersManager() {}

    /**
     * Tries to create a user by calling the stored procedure addUser with the given parameters.
     * @param nome is the name
     * @param email is the email
     * @param categoriaProfissional is the professional category
     * @param password is the password
     * @param role is the role  that the user we want to register plays in the database
     */

    public List<User> getListOfUsers () {
        return listOfUsers;
    }

    public void getDBUsers () {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfUsers.clear();
            ResultSet varUser1 = DB.select("SELECT * FROM estufa.investigador");
            ResultSet varUser2 = DB.select("SELECT * FROM mysql.user");

            try {
                addUsers(varUser1, varUser2);
            } catch (SQLException sqlException) {
                sqlException.printStackTrace();
            }
        }
    }

    private void addUsers (ResultSet varUser1, ResultSet varUser2) throws SQLException {

        List<User> listOfInvestigadores = new ArrayList<User>();
        List<User> listOfMysqlUsers = new ArrayList<User>();

        while(varUser1.next()) {
            String user = varUser1.getString("NomeInvestigador");
            String default_role = "investigador";
            String email = varUser1.getString("Email");
            String categoriaProfissional = varUser1.getString("CategoriaProfissional");

            listOfInvestigadores.add(new User(user, email, categoriaProfissional, default_role));
            System.out.println(listOfInvestigadores.size());
        }

        while(varUser2.next()) {
            String user = varUser2.getString("User");
            String email = varUser2.getString("email");

            listOfMysqlUsers.add(new User(user, email, "", ""));
            System.out.println(listOfMysqlUsers.size());
        }
    }

    public void insertUser(User user) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call addUser(?,?,?,?,?)}");
            cStmt.setString(1, user.getUser_type());
            cStmt.setString(2, user.getName());
            cStmt.setString(3, user.getPassword());
            cStmt.setString(4, user.getEmail());
            cStmt.setString(5, user.getCategory());
            if(cStmt.execute()==false) {
                System.out.println("O utilizador " + user.getName() +" foi corretamente registado" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }
    }

    /**
     * Tries to delete a user by calling the stored procedure deleteUser with the given parameters.
     * @param email is the email of the user that we want to delete
     */

    public void deleteUser(String email) {
        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call deleteUser(?)}");
            cStmt.setString(1, email);
            if(cStmt.execute()==false) {
                System.out.println("O utilizador com o email " + email +" foi apagado com sucesso" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }
    }
}
