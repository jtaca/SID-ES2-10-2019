package cultura;

import api.DatabaseConnection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.mysql.cj.jdbc.CallableStatement;
import java.sql.SQLException;


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
            ResultSet varCulture = DB.select("SELECT * FROM estufa.cultura");
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


    public void insertCulture (Culture culture) {

        DatabaseConnection DB = DatabaseConnection.getInstance();

        if(DB.isConnected()){
            DB.insert(TABELA_CULTURA, culture.toString());
        }

        getDBCultures();
    }


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
