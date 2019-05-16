import api.DatabaseConnection;
import api.Investigador;
import api.InvestigadorManager;
import gui.GUI;
import medicoes.Measurement;
import medicoes.MeasurementManager;
import variaveis.Variable;
import variaveis.VariableManager;
import javafx.util.Pair;

public class Main {

    public static void main(String[] args) {
        System.out.println("Starting app...");

        // Connect to the database
        // For now we connect with the root account. This should be changed later to the user account.
        DatabaseConnection db1 = DatabaseConnection.getInstance();
        Pair<Boolean, String> connectionState1 = db1.connect("TesteInvestigador", "iscte");
        if(!connectionState1.getKey()) {
            System.out.println(connectionState1.getValue());
            System.exit(0);
        }
    }

}
