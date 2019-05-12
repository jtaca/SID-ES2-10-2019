package gui;

import api.DatabaseConnection;
import api.Investigador;
import api.InvestigadorManager;
import javafx.util.Pair;
import variaveis.VariableManager;
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
import java.util.ArrayList;
import java.util.List;

public class AdministratorController {

    private Stage primaryStage;

    @FXML
    public TableView<Investigador> users_table;
    @FXML
    public TableColumn<Investigador, String> user_name_col;
    @FXML
    public TableColumn<Investigador, String> user_email_col;
    @FXML
    public TableColumn<Investigador, String> user_category_col;
    @FXML
    public TableColumn<Investigador, String> user_type_col;
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


    private Investigador selected_variable;
    private DatabaseConnection db1;

    @FXML
    public void initialize() {
        variable_name_col.setCellValueFactory(new PropertyValueFactory<>("name"));
        variables_table.setItems(VariableList());

        user_name_col.setCellValueFactory(new PropertyValueFactory<>("name"));
        user_email_col.setCellValueFactory(new PropertyValueFactory<>("email"));
        user_category_col.setCellValueFactory(new PropertyValueFactory<>("category"));
        users_table.setItems(UserList());

        System.out.println("Starting app...");

        // Connect to the database
        // For now we connect with the root account. This should be changed later to the user account.
        db1 = DatabaseConnection.getInstance();
        Pair<Boolean, String> connectionState1 = db1.connect("root", "");
        if(!connectionState1.getKey()) {
            System.out.println(connectionState1.getValue());
            System.exit(0);
        }

    }
    public AdministratorController getInstance(){
        return this;
    }

    public Investigador getSelected_variable() {
        return selected_variable;
    }

    public void setSelected_variable(Investigador selected_variable) {
        this.selected_variable = selected_variable;
    }

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    private ObservableList<Variable> VariableList() {
        ObservableList<Variable> list = FXCollections.observableArrayList();

        VariableManager var = new VariableManager();
        var.getDBVariables();
        ArrayList<Variable> vars = var.getVariables();
        System.out.println(vars.toString());

        for (Variable ivar: vars) {
            list.add(ivar);
        }
        System.out.println("I was here");
/*
        for (int i=0; i<25; i++) {
            Random r = new Random();
            char a = (char)(r.nextInt(26) + 'a');
            char b = (char)(r.nextInt(26) + 'a');

            String finalString = "Mineral " + Character.toUpperCase(a) + Character.toUpperCase(b);

            list.add(new Variable(i, finalString));
        }*/
        return list;
    }

    public void addVariable(MouseEvent mouseEvent) {
        System.out.println("insertVariable");
        Variable selected_variable = variables_table.getSelectionModel().getSelectedItem();
        System.out.println(selected_variable.toString());
        VariableManager var = new VariableManager();
                var.insertVariable(selected_variable);

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
        variables_table.setItems(VariableList());
    }

    private ObservableList<Investigador> UserList() {
        ObservableList<Investigador> list = FXCollections.observableArrayList();

        InvestigadorManager inv = new InvestigadorManager();
        inv.getDBInvestigador();

        List<Investigador> invs = inv.getListOfInvestigadores();
        System.out.println(invs.toString());

        for (Investigador ivar: invs) {
            list.add(ivar);
        }
        System.out.println("I was here too! ^_^");

/*        for (int i=0; i<25; i++) {
            Random r = new Random();
            char a = (char)(r.nextInt(26) + 'a');
            char b = (char)(r.nextInt(26) + 'a');

            String name = "Pessoa " + Character.toUpperCase(a) + Character.toUpperCase(b);

            list.add(new Investigador("pass", name, a+"@"+b+".pt", "Agricultor"));
        }*/
        return list;
    }

    public void addInvestigator(MouseEvent mouseEvent) {
        System.out.println("addInvestigator");
        Investigador selected_variable = users_table.getSelectionModel().getSelectedItem();
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
        Investigador selected_variable1 = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable1 +"  +  "+ this.selected_variable);

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


                EditInvestigatorController controller = loader.getController();
                controller.setCategory(selected_variable1.getCategory());
                controller.setEmail(selected_variable1.getEmail());
                controller.setName(selected_variable1.getName());
                controller.setPassword(selected_variable1.getPassword());


                dialog.setScene(new Scene(root));
                dialog.show();

                return null;
            }
        };

        Platform.runLater(task);
        System.out.println("Selected: " + selected_variable1 +"  +  "+ this.selected_variable);
/*        this.getSelected_variable();

        if (this.getSelected_variable().getPassword().equals("")){
            this.getSelected_variable().setPassword();
        }
        if (this.getSelected_variable().getName().equals("")){
            name1 = admin.getSelected_variable().getName();
        }
        if (this.getSelected_variable().getEmail().equals("")){
            email1 = admin.getSelected_variable().getEmail();
        }
        if (this.getSelected_variable().getCategory().equals("")){
            category1 = admin.getSelected_variable().getCategory();
        }
        System.out.println(inv2.toString());
        System.out.println("try");
        InvestigadorManager inv = new InvestigadorManager();
        inv.updateInvestigador(selected_variable,inv2);*/
    }

    public void deleteUser(MouseEvent mouseEvent) {
        System.out.println("deleteUser");
        Investigador selected_variable = users_table.getSelectionModel().getSelectedItem();
        System.out.println("Selected: " + selected_variable);

        InvestigadorManager inv = new InvestigadorManager();
        inv.deleteInvestigador(selected_variable);
    }

    public void refreshUsersTable(MouseEvent mouseEvent) {
        System.out.println("refreshUsersTable");
        users_table.setItems(UserList());
    }
}
