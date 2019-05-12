package gui;

import api.DatabaseConnection;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.stage.Stage;
import javafx.util.Pair;

import java.io.IOException;

public class LoginController {

    @FXML
    public TextField username;
    @FXML
    public TextField password;

    private Stage primaryStage;

    void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }


    public void login(MouseEvent mouseEvent) {
        System.out.println("Logging in...");
        System.out.println("Username: "+username.getText());
        System.out.println("Password: "+password.getText());

        DatabaseConnection db = DatabaseConnection.getInstance();
        Pair<Boolean, String> result = db.connect(username.getText(), password.getText());

        if (!result.getKey())
            System.out.println("Erro no login");
        else if (result.getKey() && result.getValue().equals("investigador"))
            System.out.println("Sucesso");
        else if (result.getKey() && result.getValue().equals("administrador"))
            startAdminPanel();
        else
            System.out.println("not supposed to happen");
    }


    private void startAdminPanel() {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/gui/administrator.fxml"));
        Parent root;
        try {
            root = (Parent) loader.load();
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
        AdministratorController controller = loader.getController();
        controller.setPrimaryStage(primaryStage);

        primaryStage.setScene(new Scene(root));
    }

}
