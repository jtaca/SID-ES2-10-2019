package gui;

import variaveis.Variable;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import variaveis.VariableManager;

public class EditVariableController {

    private Variable variable;
    private VariableManager variableManager;

    @FXML
    public TextField name;


    public void setVariable(Variable variable) {
        this.variable = variable;
    }

    public void setVariableManager(VariableManager variableManager) {
        this.variableManager = variableManager;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save editCulture: " + name.getText() +"   "+ variable.toString() );

        variableManager.editVariable(variable,new Variable(name.getText()));
    }
}
