package gui;

import cultura.Culture;
import cultura.CultureManager;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Modality;
import javafx.stage.Stage;

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

    private Stage primaryStage;
    private CultureManager cultureManager;

    @FXML
    public void initialize() {
        culture_name_col.setCellValueFactory(new PropertyValueFactory<>("cultureName"));
        culture_email_col.setCellValueFactory(new PropertyValueFactory<>("investigatorEmail"));
        culture_description_col.setCellValueFactory(new PropertyValueFactory<>("cultureDescription"));
        cultureManager = new CultureManager();
        ObservableList<Culture> cultureList = FXCollections.observableArrayList(cultureManager.getListOfCultures());
        cultures_table.setItems(cultureList);
    }

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    private void openModal(String fxmlName) {
        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening " + fxmlName + " modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/" + fxmlName + ".fxml"));
                StackPane root;
                try {
                    root = loader.load();
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }

                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };
        Platform.runLater(task);
    }

    public void addCulture(MouseEvent mouseEvent) {
        openModal("addCulture");
    }
    
    public void editCulture(MouseEvent mouseEvent) {
        openModal("editCulture");
    }

    public void deleteCulture(MouseEvent mouseEvent) {
        List<Culture> list = cultureManager.deleteCulture(cultures_table.getSelectionModel().getSelectedItem());
        ObservableList<Culture> cultureList = FXCollections.observableArrayList(list);
        cultures_table.setItems(cultureList);
    }

    public void refreshCulturesTable(MouseEvent mouseEvent) {
    }

    public void addMeasurement(MouseEvent mouseEvent) {
    }

    public void editMeasurement(MouseEvent mouseEvent) {
    }

    public void deleteMeasurement(MouseEvent mouseEvent) {
    }

    public void refreshMeasurementsTable(MouseEvent mouseEvent) {
    }
}
