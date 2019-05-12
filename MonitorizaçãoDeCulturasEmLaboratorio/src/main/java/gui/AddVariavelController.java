package gui;

import api.DatabaseConnection;
import cultura.Culture;
import cultura.CultureManager;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import variaveis.Variable;
import variaveis.VariableManager;

public class AddVariavelController {

    private VariableManager variableManager;

    @FXML
    public TextField name;

    public void setVariableManager(VariableManager variableManager) {
        this.variableManager = variableManager;
    }

    public void register(MouseEvent mouseEvent) {
        System.out.println("Save Variable: " + name.getText() );

        variableManager.insertVariable(new Variable(name.getText()));
    }


}
