package gui;

import api.DatabaseConnection;
import cultura.Culture;
import cultura.CultureManager;
import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

public class AddCultureController {

    private CultureManager cultureManager;

    @FXML
    public TextField name;
    @FXML
    public TextArea description;

    public void setCultureManager(CultureManager cultureManager) {
        this.cultureManager = cultureManager;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save addCulture: " + name.getText() + "; " + description.getText());

        cultureManager.insertCulture(new Culture(name.getText(), description.getText(), DatabaseConnection.getUserEmail()));
    }

}
