package gui;

import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

public class AddInvestigatorController {

    @FXML
    public TextField name;
    @FXML
    public PasswordField password;
    @FXML
    public TextField email;
    @FXML
    public TextField category;

    public void register(MouseEvent mouseEvent) {
        System.out.println("addInvestigator");
        System.out.println(
                name.getText()+"\n"+
                password.getText()+"\n"+
                email.getText()+"\n"+
                category.getText()
        );
    }

}
