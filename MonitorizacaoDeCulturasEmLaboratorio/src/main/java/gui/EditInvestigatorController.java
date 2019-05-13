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
    private Investigador inv;
    private InvestigadorManager investigadorManager;

    public void setInvestigadorManager(InvestigadorManager investigadorManager) {
        this.investigadorManager = investigadorManager;
    }

    public void setName(String name) {
        this.name.setText(name);
    }

    public void setPassword(String password) {
        this.password.setText( password);
    }

    public void setEmail(String email) {
        this.email.setText(email);
    }

    public void setCategory(String category) {
        this.category.setText(category);
    }

    public void setInv(Investigador inv) {
        this.inv = inv;
    }

    public void register(MouseEvent mouseEvent) {
        System.out.println("EditInvestigator");
        System.out.println(
                name.getText()+"\n"+
                password.getText()+"\n"+
                email.getText()+"\n"+
                category.getText()
        );
        investigadorManager.updateInvestigador(inv,new Investigador(password.getText(),name.getText(),email.getText(),category.getText()));


    }

}
