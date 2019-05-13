package gui;

import api.DatabaseConnection;
import cultura.Culture;
import cultura.CultureManager;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import medicoes.Measurement;
import medicoes.MeasurementManager;
import variaveis.Variable;
import variaveis.VariableManager;

public class AddMeasurementController {

    private MeasurementManager measurementManager;

    @FXML
    public ComboBox<Variable> variableSelector;
    @FXML
    public TextField value;

    @FXML
    public void initialize() {
        VariableManager v = new VariableManager();
        variableSelector.getItems().addAll(v.getVariables());
    }

    public void setMeasurementManager(MeasurementManager measurementManager) {
        this.measurementManager = measurementManager;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save addMeasurement: " + value.getText());

        measurementManager.insertMedicoes(new Measurement(Double.parseDouble(value.getText()), variableSelector.getSelectionModel().getSelectedItem().getId()));
    }

}
