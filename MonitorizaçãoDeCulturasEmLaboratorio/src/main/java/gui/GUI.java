package gui;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import java.io.IOException;

public class GUI extends Application {

    private Stage primaryStage;

    public void start(Stage primaryStage) throws Exception {

        this.primaryStage = primaryStage;

        mainGUI();

    }

    /**
     * Loads and shows the JavaFX main application
     */
    private void mainGUI() {
        FXMLLoader loader = new FXMLLoader(getClass().getClassLoader().getResource("/fxml/investigador.fxml"));
        System.out.println(getClass().getClassLoader().getResource("/fxml/investigador.fxml"));
        Parent root;
        try {
            root = (Parent) loader.load();
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        primaryStage.setTitle("The Greenhouse - Management Area");
        primaryStage.setScene(new Scene(root));
        primaryStage.setMaximized(false);
        primaryStage.show();
    }
}