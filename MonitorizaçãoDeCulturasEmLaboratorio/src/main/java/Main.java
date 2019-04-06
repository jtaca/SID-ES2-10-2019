import api.DatabaseConnection;
import api.Users;
import variaveis.Variable;
import variaveis.VariableManager;
import javafx.util.Pair;

public class Main {

    public static void main(String[] args) {
        System.out.println("Starting app...");

        // Connect to the database
        // For now we connect with the root account. This should be changed later to the user account.
        DatabaseConnection db = DatabaseConnection.getInstance();
        Pair<Boolean, String> connectionState = db.connect("root", "");
        if(!connectionState.getKey()) {
            System.out.println(connectionState.getValue());
            System.exit(0);
        }

        Users users= new Users();
        users.addUser("testeeee", "teste@gmail.com", "chefe", "588", "investigador");


        // Prepare variables from the database
        VariableManager variableManager = new VariableManager();
        variableManager.updateLocalVariables();
        // Insert a new variable into the database. If the variable does not have an ID it will be assigned one automatically (By the database auto-increment).
        variableManager.addVariable(new Variable("nomeDaVariavel"));

        for (Variable v: variableManager.getVariables()) {
            System.out.println(v);
        }

    }

}
