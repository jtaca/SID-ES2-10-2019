package gui;

import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

public class LoginController {

    @FXML
    public TextField username;
    @FXML
    public TextField password;

    public void login(MouseEvent mouseEvent) {
        System.out.println("Logging in...");
    }

}
