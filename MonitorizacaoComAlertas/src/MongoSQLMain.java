import connections.DatabaseConnection;
import export.ExportThread;

public class MongoSQLMain {

    public static void main(String[] args) {
        DatabaseConnection dc = new DatabaseConnection();
        dc.connect("java", "java");
        dc.initializeSystem();

        ExportThread exportThread = new ExportThread();
        exportThread.start();
    }

}
