package gui;

import cultura.Culture;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import medicoes.Measurement;
import medicoes.MeasurementManager;
import variaveis.Variable;
import variaveis.VariableManager;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class EditMeasurementController {

    private MeasurementManager measurementManager;
    private Measurement oldMeasurement;

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

    public void setOldMeasurement(Measurement oldMeasurement) {
        this.oldMeasurement = oldMeasurement;
        variableSelector.getSelectionModel().select(oldMeasurement.getVariavel());
        value.setText(String.valueOf(oldMeasurement.getValorMedicao()));
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save editMeasurement: " + value.getText());

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();

        String date_now = dateFormat.format(date);
        double value_double = Double.parseDouble(value.getText());
        Variable selected_variable = variableSelector.getSelectionModel().getSelectedItem();
        Measurement newMeasurement = new Measurement(date_now, value_double, selected_variable, oldMeasurement.getCultura());

        measurementManager.updateMedicoes(oldMeasurement, newMeasurement);
    }

}
