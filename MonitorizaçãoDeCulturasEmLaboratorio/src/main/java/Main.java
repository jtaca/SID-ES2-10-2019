import api.DatabaseConnection;
import api.Investigador;
import api.InvestigadorManager;
import medicoes.MedicoesManager;
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

        // Prepare variables from the database
        VariableManager variableManager = new VariableManager();
        variableManager.updateLocalVariables();
        // Insert a new variable into the database. If the variable does not have an ID it will be assigned one automatically (By the database auto-increment).
        variableManager.addVariable(new Variable("nomeDaVariavel"));
        variableManager.alterarLimitesTemperatura(19,30);
        variableManager.alterarLimitesLuz(1,3);
        MedicoesManager med = new MedicoesManager();
        med.selectMedicoes();


        for (Variable v: variableManager.getVariables()) {
            System.out.println(v);
        }

    }

}
