package gui;

import api.DatabaseConnection;
import api.Investigador;
import api.InvestigadorManager;
import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.util.Pair;

public class EditInvestigatorController {

    @FXML
    public TextField name;
    @FXML
    public PasswordField password;
    @FXML
    public TextField email;
    @FXML
    public TextField category;

    public void register(MouseEvent mouseEvent) {
        System.out.println("EditInvestigator");
        System.out.println(
                name.getText()+"\n"+
                password.getText()+"\n"+
                email.getText()+"\n"+
                category.getText()
        );

        DatabaseConnection db1 = DatabaseConnection.getInstance();
        Pair<Boolean, String> connectionState1 = db1.connect("root", "");
        if(!connectionState1.getKey()) {
            System.out.println(connectionState1.getValue());
            System.exit(0);
        }

        InvestigadorManager inv = new InvestigadorManager();
        inv.insertInvestigador(new Investigador(password.getText(),name.getText(),email.getText(),category.getText()));





    }

}
