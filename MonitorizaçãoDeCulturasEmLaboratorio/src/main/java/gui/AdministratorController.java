package gui;

import api.User;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Modality;
import javafx.stage.Stage;
import variaveis.Variable;

import java.io.IOException;
import java.util.Random;

public class AdministratorController {

    private Stage primaryStage;

    @FXML
    public TableView<User> users_table;
    @FXML
    public TableColumn<User, String> user_name_col;
    @FXML
    public TableColumn<User, String> user_email_col;
    @FXML
    public TableColumn<User, String> user_category_col;
    @FXML
    public TableColumn<User, String> user_type_col;
    @FXML
    public Button add_user_btn;
    @FXML
    public Button edit_user_btn;
    @FXML
    public Button delete_user_btn;
    @FXML
    public Button refresh_user_btn;

    @FXML
    public TableView<Variable> variables_table;
    @FXML
    public TableColumn<Variable, String> variable_name_col;
    @FXML
    public Button add_variable_btn;
    @FXML
    public Button edit_variable_btn;
    @FXML
    public Button delete_variable_btn;
    @FXML
    public Button refresh_variable_btn;

    @FXML
    public void initialize() {
        variable_name_col.setCellValueFactory(new PropertyValueFactory<>("name"));
        variables_table.setItems(randomVariableList());

        user_name_col.setCellValueFactory(new PropertyValueFactory<>("name"));
        user_email_col.setCellValueFactory(new PropertyValueFactory<>("email"));
        user_category_col.setCellValueFactory(new PropertyValueFactory<>("category"));
        user_type_col.setCellValueFactory(new PropertyValueFactory<>("user_type"));
        users_table.setItems(randomUserList());
    }

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    private ObservableList<Variable> randomVariableList() {
        ObservableList<Variable> list = FXCollections.observableArrayList();
        for (int i=0; i<25; i++) {
            Random r = new Random();
            char a = (char)(r.nextInt(26) + 'a');
            char b = (char)(r.nextInt(26) + 'a');

            String finalString = "Mineral " + Character.toUpperCase(a) + Character.toUpperCase(b);

            list.add(new Variable(i, finalString));
        }
        return list;
    }

    public void addVariable(MouseEvent mouseEvent) {
        System.out.println("addVariable");
        Variable selected_variable = variables_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
    }

    public void editVariable(MouseEvent mouseEvent) {
        System.out.println("editVariable");
        Variable selected_variable = variables_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
    }

    public void deleteVariable(MouseEvent mouseEvent) {
        System.out.println("deleteVariable");
        Variable selected_variable = variables_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
    }

    public void refreshVariablesTable(MouseEvent mouseEvent) {
        System.out.println("refreshVariablesTable");
        variables_table.setItems(randomVariableList());
    }

    private ObservableList<User> randomUserList() {
        ObservableList<User> list = FXCollections.observableArrayList();
        for (int i=0; i<25; i++) {
            Random r = new Random();
            char a = (char)(r.nextInt(26) + 'a');
            char b = (char)(r.nextInt(26) + 'a');

            String name = "Pessoa " + Character.toUpperCase(a) + Character.toUpperCase(b);

            list.add(new User(i,name, a+"@"+b+".pt", "Agricultor","Investigador"));
        }
        return list;
    }

    public void addInvestigator(MouseEvent mouseEvent) {
        System.out.println("addInvestigator");
        User selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);

        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening addInvestigator modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/addInvestigator.fxml"));
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

    public void editUser(MouseEvent mouseEvent) {
        System.out.println("editUser");
        User selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);

        Task<Void> task = new Task<Void>() {
            @Override
            public Void call() {
                System.out.println("Opening editInvestigator modal...");
                final Stage dialog = new Stage();
                dialog.initModality(Modality.APPLICATION_MODAL);
                dialog.initOwner(primaryStage);
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/editInvestigator.fxml"));
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

    public void deleteUser(MouseEvent mouseEvent) {
        System.out.println("deleteUser");
        User selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
    }

    public void refreshUsersTable(MouseEvent mouseEvent) {
        System.out.println("refreshUsersTable");
        users_table.setItems(randomUserList());
    }
}
