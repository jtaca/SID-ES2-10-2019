package cultura;

import api.DatabaseConnection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CultureManager {


    private final String TABELA_CULTURA = "cultura";
    private List<Culture> listOfCultures = new ArrayList<Culture>();


    public List<Culture> getListOfCultures () {
        return listOfCultures;
    }


    public void getDBCultures () {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()) {
            listOfCultures.clear();
            ResultSet varCulture = DB.select("SELECT * FROM cultura");
            try {
                addCultures(varCulture);
            } catch (SQLException sqlException) {
                //TODO
                sqlException.printStackTrace();
            }
        }
    }


    private void addCultures (ResultSet varCulture) throws SQLException {

        while(varCulture.next()) {
            int idCultura = varCulture.getInt("IDCultura");
            String nomeCultura = varCulture.getString("NomeCultura");
            String descricaoCultura = varCulture.getString("DescricaoCultura");
            String emailInvestigador = varCulture.getString("EmailInvestigador");

            listOfCultures.add(new Culture(idCultura, nomeCultura, descricaoCultura, emailInvestigador));

        }
    }


    public void insertCultura (Culture culture) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()){
            DB.insert(TABELA_CULTURA, culture.toString());
        }

        getDBCultures();
    }


    public void deleteCultura (int idCulture) {

    }
}
