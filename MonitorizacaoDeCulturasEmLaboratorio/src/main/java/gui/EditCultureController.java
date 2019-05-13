package gui;

import cultura.Culture;
import cultura.CultureManager;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

public class EditCultureController {

    private Culture culture;
    private CultureManager cultureManager;

    @FXML
    public TextField name;
    @FXML
    public TextArea description;

    public void setName(String name) {
        this.name.setText(name);
    }

    public void setDescription(String description) {
        this.description.setText(description);
    }

    public void setCulture(Culture culture) {
        this.culture = culture;
    }

    public void setCultureManager(CultureManager cultureManager) {
        this.cultureManager = cultureManager;
    }

    public void save(MouseEvent mouseEvent) {
        System.out.println("Save editCulture: " + name.getText() + "; " + description.getText());

        culture.setCultureName(name.getText());
        culture.setCultureDescription(description.getText());

        cultureManager.updateCulture(culture);
    }

}
