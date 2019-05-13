package api;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import com.mysql.cj.jdbc.CallableStatement;


/**
 * Class responsible for the management of investigators in the respective table of the database.
 *  Has methods to insert, remove and update.
 */

public class InvestigadorManager {

    private static List<Investigador> listOfUsers = new ArrayList<Investigador>();


    public List<Investigador> getListOfInvestigadores () {
        return listOfUsers;
    }

    /**
     * Extracts all records from the investigators table from the database.
     */

    public static void getDBInvestigador() {

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

    /**
     * Transforms all the records obtained in the data base`s investigators table in objects investigator. It inserts those objects in a investigators list.
     * @param varUser represents the record of a investigators extracted from the data base for a post transformation.
     */

    private static void addInvestigadores(ResultSet varUser) throws SQLException {

        while(varUser.next()) {
            String nomeInvestigador = varUser.getString("NomeInvestigador");
            String default_role = "investigador";
            String email = varUser.getString("Email");
            String categoriaProfissional = varUser.getString("CategoriaProfissional");
            Investigador u = new Investigador("password",nomeInvestigador,email,categoriaProfissional);
            listOfUsers.add(u);
        }

    }

    /**
     * Attempts to create an investigator in the database by calling the stored procedure addUser through the provided investigator object as argument.
     * @param investigador is the object investigator to be inserted.
     *
     */

    public static void insertInvestigador(Investigador investigador) {

        System.out.println(investigador.toString());

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call addUser(?,?,?,?,?)}");
            cStmt.setString(1, "investigador");
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

    /**
     * Attempts to update an investigator's information in the database by calling the stored procedure updateInvestigador through the current investigator object and another investigator object instantiated with the parameters to be modified, provided as argument.
     * @param oldInvestigador object investigator corresponding to the investigator and the his current information.
     * @param newInvestigador investigator object corresponding to the same investigator instantiated only with the information to be changed.
     */

    public static void updateInvestigador(Investigador oldInvestigador, Investigador newInvestigador) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {

            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().
                    prepareCall("{call updateInvestigador(?,?,?,?,?)}");
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
     * @param investigador is the object investigator that we want to delete.
     */

    public void deleteInvestigador(Investigador investigador) {
        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().
                    prepareCall("{call deleteUser(?)}");
            cStmt.setString(1, investigador.getEmail());
            System.out.println(investigador.getEmail());
            if(cStmt.execute()==false) {
                System.out.println("O utilizador com o email " + investigador.getEmail() +" foi apagado com sucesso" );
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possivel executar com sucesso o seu pedido. Exception: " + e.getMessage() );
        }

        getDBInvestigador();
    }
}
