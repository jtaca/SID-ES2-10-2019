package gui;

import cultura.Culture;
import cultura.CultureManager;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Modality;
import javafx.stage.Stage;
import medicoes.Measurement;
import medicoes.MeasurementManager;

import java.io.IOException;
import java.util.List;

public class InvestigatorController {

    @FXML
    public TableView<Culture> cultures_table;
    @FXML
    public TableColumn<Culture, String> culture_name_col;
    @FXML
    public TableColumn<Culture, String> culture_email_col;
    @FXML
    public TableColumn<Culture, String> culture_description_col;

    @FXML
    public TableView<Measurement> measurements_table;
    @FXML
    public TableColumn<Measurement, String> timestamp;
    @FXML
    public TableColumn<Measurement, String> measurementValue;
    @FXML
    public TableColumn<Measurement, String> idMeasuredVariable;
    @FXML
    public ComboBox<Culture> cultureSelector;


    private Stage primaryStage;
    private CultureManager cultureManager;
    private MeasurementManager measurementManager;

    @FXML
    public void initialize() {
        culture_name_col.setCellValueFactory(new PropertyValueFactory<>("cultureName"));
        culture_email_col.setCellValueFactory(new PropertyValueFactory<>("investigatorEmail"));
        culture_description_col.setCellValueFactory(new PropertyValueFactory<>("cultureDescription"));
        cultureManager = new CultureManager();
        ObservableList<Culture> cultureList = FXCollections.observableArrayList(cultureManager.getListOfCultures());
        cultures_table.setItems(cultureList);

        measurementManager = new MeasurementManager();
        cultureSelector.getItems().addAll(cultureManager.getListOfCultures());

        timestamp.setCellValueFactory(new PropertyValueFactory<>("dataHoraMedicao"));
        measurementValue.setCellValueFactory(new PropertyValueFactory<>("valorMedicao"));
        idMeasuredVariable.setCellValueFactory(new PropertyValueFactory<>("variavel"));
    }

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    public void addCulture(MouseEvent mouseEvent) {
        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening addCulture modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/addCulture.fxml"));
                StackPane root;
                try {
                    root = loader.load();
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }

                AddCultureController controller = loader.getController();
                controller.setCultureManager(cultureManager);

                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };
        Platform.runLater(task);
    }
    
    public void editCulture(MouseEvent mouseEvent) {
        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening editCulture modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/editCulture.fxml"));
                StackPane root;
                try {
                    root = loader.load();
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }

                EditCultureController controller = loader.getController();
                Culture selectedCulture = cultures_table.getSelectionModel().getSelectedItem();
                controller.setCulture(selectedCulture);
                controller.setCultureManager(cultureManager);
                controller.setName(selectedCulture.getCultureName());
                controller.setDescription(selectedCulture.getCultureDescription());

                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };
        Platform.runLater(task);
    }

    public void deleteCulture(MouseEvent mouseEvent) {
        Culture selected = cultures_table.getSelectionModel().getSelectedItem();
        if (selected != null) {
            List<Culture> list = cultureManager.deleteCulture(selected);
            ObservableList<Culture> cultureList = FXCollections.observableArrayList(list);
            cultures_table.setItems(cultureList);
        }
    }

    public void refreshCulturesTable(MouseEvent mouseEvent) {
        ObservableList<Culture> cultureList = FXCollections.observableArrayList(cultureManager.getListOfCultures());
        cultures_table.setItems(cultureList);
    }

    public void addMeasurement(MouseEvent mouseEvent) {
        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening addMeasurement modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/addMeasurement.fxml"));
                StackPane root;
                try {
                    root = loader.load();
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }

                AddMeasurementController controller = loader.getController();
                controller.setMeasurementManager(measurementManager);
                controller.setCulture(cultureSelector.getSelectionModel().getSelectedItem());

                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };
        Platform.runLater(task);
    }

    public void editMeasurement(MouseEvent mouseEvent) {
        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening editMeasurement modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/editMeasurement.fxml"));
                StackPane root;
                try {
                    root = loader.load();
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }

                EditMeasurementController controller = loader.getController();
                controller.setMeasurementManager(measurementManager);
                controller.setOldMeasurement(measurements_table.getSelectionModel().getSelectedItem());

                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };
        Platform.runLater(task);
    }

    public void deleteMeasurement(MouseEvent mouseEvent) {
        Measurement selected = measurements_table.getSelectionModel().getSelectedItem();
        if (selected != null) {
            List<Measurement> list = measurementManager.deleteMedicoes(selected);
            ObservableList<Measurement> measurementList = FXCollections.observableArrayList(list);
            measurements_table.setItems(measurementList);
        }
    }

    public void refreshMeasurementsTable(MouseEvent mouseEvent) {
        List<Measurement> list = measurementManager.selectMedicoes(cultureSelector.getSelectionModel().getSelectedItem());
        ObservableList<Measurement> obsList = FXCollections.observableArrayList(list);
        measurements_table.setItems(obsList);
    }

    public void getMeasurementsFromCulture(ActionEvent actionEvent) {
        List<Measurement> list = measurementManager.selectMedicoes(cultureSelector.getSelectionModel().getSelectedItem());
        ObservableList<Measurement> obsList = FXCollections.observableArrayList(list);
        measurements_table.setItems(obsList);
    }
}
