package gui;

import api.User;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import variaveis.Variable;

import java.util.Random;

public class AdministratorController {

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

            list.add(new User(name, a+"@"+b+".pt", "Agricultor","Investigador"));
        }
        return list;
    }

    public void addUser(MouseEvent mouseEvent) {
        System.out.println("addUser");
        User selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
    }

    public void editUser(MouseEvent mouseEvent) {
        System.out.println("editUser");
        User selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);
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
