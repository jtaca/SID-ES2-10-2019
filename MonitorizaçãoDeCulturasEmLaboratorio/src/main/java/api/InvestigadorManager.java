package api;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import com.mysql.cj.jdbc.CallableStatement;

public class InvestigadorManager {

    private List<Investigador> listOfUsers = new ArrayList<Investigador>();

    public InvestigadorManager() {}

    /**
     * Tries to create a user by calling the stored procedure addUser with the given parameters.
     * @param nome is the name
     * @param email is the email
     * @param categoriaProfissional is the professional category
     * @param password is the password
     * @param role is the role  that the user we want to register plays in the database
     */

    public List<Investigador> getListOfInvestigadores () {
        return listOfUsers;
    }

    public void getDBInvestigador () {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfUsers.clear();
            ResultSet varUser = DB.select("SELECT * FROM estufa.investigador");

            try {
                addInvestigadores(varUser);
            } catch (SQLException sqlException) {
                //TODO
                sqlException.printStackTrace();
            }
        }
    }

    private void addInvestigadores (ResultSet varUser) throws SQLException {

        while(varUser.next()) {
            String nomeInvestigador = varUser.getString("NomeInvestigador");
            String default_role = "investigador";
            String email = varUser.getString("Email");
            String categoriaProfissional = varUser.getString("CategoriaProfissional");

            Investigador u = new Investigador(nomeInvestigador, email, categoriaProfissional, default_role);
            listOfUsers.add(u);
        }

    }

    public void insertInvestigador(Investigador investigador) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call addUser(?,?,?,?,?)}");
            cStmt.setString(1, investigador.getUser_type());
            cStmt.setString(2, investigador.getName());
            cStmt.setString(3, investigador.getPassword());
            cStmt.setString(4, investigador.getEmail());
            cStmt.setString(5, investigador.getCategory());
            if(cStmt.execute()==false) {
                System.out.println("O utilizador " + investigador.getName() +" foi corretamente registado" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }

        getDBInvestigador();
    }


    public void updateInvestigador(Investigador oldInvestigador, Investigador newInvestigador) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {

            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call updateInvestigador(?,?,?,?,?)}");
            cStmt.setString(1, oldInvestigador.getEmail());
            cStmt.setString(2, newInvestigador.getName());
            cStmt.setString(3, newInvestigador.getCategory());
            cStmt.setString(4, newInvestigador.getPassword());
            cStmt.setString(5, newInvestigador.getEmail());

            String emailAtual = "";
            if(newInvestigador.getEmail() == "" || newInvestigador.getEmail() == null) {
                emailAtual = oldInvestigador.getEmail();
            } else {
                emailAtual = newInvestigador.getEmail();
            }

            if(cStmt.execute()==false) {
                System.out.println("O dados do investigador com email: " + emailAtual + " foi atualizado com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível atualizar os dados do investigador pretendido. Exception: " + e.getMessage());
        }

        getDBInvestigador();

    }


    /**
     * Tries to delete a user by calling the stored procedure deleteUser with the given parameters.
     * @param email is the email of the user that we want to delete
     */

    public void deleteInvestigador(Investigador investigador) {
        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call deleteUser(?)}");
            cStmt.setString(1, investigador.getEmail());
            if(cStmt.execute()==false) {
                System.out.println("O utilizador com o email " + investigador.getEmail() +" foi apagado com sucesso" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }

        getDBInvestigador();
    }
}
