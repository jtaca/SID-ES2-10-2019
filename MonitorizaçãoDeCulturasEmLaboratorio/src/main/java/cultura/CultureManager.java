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


    public void upadateCultura (int culturaId) {

        //UPDATE `cultura` SET `DescricaoCultura` = 'Cultura Hidroponica ++' WHERE `cultura`.`IDCultura` = 4;
    }


    public void deleteCultura (int idCulture) {

        try {
            CallableStatement cStmt = (CallableStatement) DatabaseConnection.getInstance().getConnection().prepareCall("{call apagarCultura(?)}");
            cStmt.setString(1, ""+idCulture);
            if(cStmt.execute()==false) {
                System.out.println("A cultura com id: " + idCulture + " e respectivas variaveis medidas e medicões foram eliminadas com sucesso.");
            }
        } catch (SQLException e) {
            System.out.println("Nao foi possível apagar a cultura pretendida. Exception: " + e.getMessage());
        }

    }
}
