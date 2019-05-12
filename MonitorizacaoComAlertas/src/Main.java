import connections.DatabaseConnection;
import connections.SensorsConnection;
import export.ExportThread;
import medicao.GestorDeMedicoes;

public class Main {

	public static void main(String[] args) {

        DatabaseConnection dc = new DatabaseConnection();
        dc.connect("java", "java");
        dc.initializeSystem();
        GestorDeMedicoes ges = dc.getGestor();
        SensorsConnection sc = new SensorsConnection(ges);

        ExportThread exportThread = new ExportThread();
        exportThread.start();
	}

}
