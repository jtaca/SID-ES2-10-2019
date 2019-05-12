package gui;

import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import variaveis.Variable;
import variaveis.VariableManager;

public class ChangeLight {


        @FXML
        public TextField upperLimit;
        @FXML
        public TextField low;

        private VariableManager variableManager;

        public void setVariableManager(VariableManager variableManager) {
            this.variableManager = variableManager;
        }

        public void save(MouseEvent mouseEvent) {
            System.out.println("Save change Light: " + upperLimit.getText() + "; " + low.getText());


            variableManager.alterarLimitesLuz(Double.parseDouble(low.getText())
                    ,Double.parseDouble(upperLimit.getText()));
        }

}
