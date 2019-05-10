package cultura;

import api.DatabaseConnection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.mysql.cj.jdbc.CallableStatement;

/**
 * Class responsible for crop management in the respective table of the database.
 * It has methods to insert, remove and update.
 */

public class CultureManager {


    private final String TABELA_CULTURA = "cultura";
    private List<Culture> listOfCultures = new ArrayList<Culture>();

    /**
     * @return an ArrayList of all the culturas in the database;
     */

    public List<Culture> getListOfCultures () {
        return listOfCultures;
    }

    /**
     * Extracts all records from the culturas table from the database.
     */

    public void getDBCultures () {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfCultures.clear();
            ResultSet varCulture = DB.select("SELECT * FROM estufa.cultura");
            try {
                addCultures(varCulture);
            } catch (SQLException sqlException) {
                //TODO
                sqlException.printStackTrace();
            }
        }
    }

    /**
     * Transforms all the records obtained in the data base`s culturas table in objects culture. It inserts those objects in a culture list.
     * @param varCulture represents the record of a culture extrated from the data base for a post transformation.
     */

    private void addCultures (ResultSet varCulture) throws SQLException {

        while(varCulture.next()) {
            int idCultura = varCulture.getInt("IDCultura");
            String nomeCultura = varCulture.getString("NomeCultura");
            String descricaoCultura = varCulture.getString("DescricaoCultura");
            String emailInvestigador = varCulture.getString("EmailInvestigador");

            listOfCultures.add(new Culture(idCultura, nomeCultura, descricaoCultura, emailInvestigador));

        }
    }

    /**
     * Insert a new culture into the database. If the culture does not have an ID it will be assigned one automatically by the database auto-increment.
     * @param culture the culture to be inserted.
     */

    public void insertCulture (Culture culture) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()){
            DB.insert(TABELA_CULTURA, culture.toString());
        }

        getDBCultures();
    }

    /**
     * Attempts to update information from a culture in the database by calling the updateCulture stored procedure through the current culture object and another culture object instantiated with the parameters to be modified, supplied as argument.
     * @param oldCulture object corresponding to the culture and his current information.
     * @param newCulture object corresponding to the same culture instantiated only with the information changed.
     */

    public void updateCulture (Culture oldCulture, Culture newCulture) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        try {

            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call updateCultura(?,?,?)}");
            cStmt.setString(1, ""+oldCulture.getId());
            cStmt.setString(2, newCulture.getCultureName());
            cStmt.setString(3, newCulture.getCultureDescription());

            if(cStmt.execute()==false) {
                System.out.println("A cultura com id: " + oldCulture.getId() + " foi atualizada com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível atualizar a cultura pretendida. Exception: " + e.getMessage());
        }

        getDBCultures();
    }

    /**
     * Tries to delete a culture by calling the stored procedure apagarCultura with the given parameters.
     * @param culture is the object culture that we want to delete.
     */

    public void deleteCulture (Culture culture) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call apagarCultura(?)}");
            cStmt.setString(1, ""+culture.getId());
            if(cStmt.execute()==false) {
                System.out.println("A cultura com id: " + culture.getId() + " e respectivas variaveis medidas e medicões foram eliminadas com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível apagar a cultura pretendida. Exception: " + e.getMessage());
        }

        getDBCultures();

    }
}
