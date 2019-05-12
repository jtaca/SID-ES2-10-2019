package gui;

import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

public class AddCultureController {

    @FXML
    public TextField name;
    @FXML
    public TextArea description;

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save addCulture");
        System.out.println(
                name.getText()+"\n"+
                description.getText()
        );
    }

}
