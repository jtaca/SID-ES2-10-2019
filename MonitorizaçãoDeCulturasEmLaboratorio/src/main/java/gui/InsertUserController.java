package gui;

import javafx.fxml.FXML;
import javafx.scene.control.ToggleGroup;
import javafx.scene.input.MouseEvent;

public class InsertUserController {

    @FXML
    public ToggleGroup radio_group;

    public void register(MouseEvent mouseEvent) {
        System.out.println("registerUser");
    }

}
