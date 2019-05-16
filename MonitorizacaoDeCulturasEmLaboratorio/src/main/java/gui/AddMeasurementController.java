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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddMeasurementController {

    private MeasurementManager measurementManager;
    private Culture culture;

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

    public void setCulture(Culture culture) {
        this.culture = culture;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save addMeasurement: " + value.getText());

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();

        String date_now = dateFormat.format(date);
        double value_double = Double.parseDouble(value.getText());
        Variable selected_variable = variableSelector.getSelectionModel().getSelectedItem();

        measurementManager.insertMedicoes(new Measurement(date_now, value_double, selected_variable, culture));
    }

}
