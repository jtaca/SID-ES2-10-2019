package gui;

import cultura.Culture;
import cultura.CultureManager;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import variaveis.Variable;
import variaveis.VariableManager;

public class ChangeTemperature {


    @FXML
    public TextField upperLimit;
    @FXML
    public TextField lowermost;

    private VariableManager variableManager;

    public void setVariableManager(VariableManager variableManager) {
        this.variableManager = variableManager;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save change Temperature: " + Double.parseDouble(upperLimit.getText()) + "; " + Double.parseDouble(lowermost.getText()));


        variableManager.alterarLimitesTemperatura(Double.parseDouble(lowermost.getText())
                ,Double.parseDouble(upperLimit.getText()));
    }
}
