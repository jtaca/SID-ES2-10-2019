package export;

import com.mongodb.DBObject;
import connections.DatabaseConnection;
import connections.MongoConnection;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.sql.SQLException;
import java.util.ArrayList;

public class ExportThread extends Thread {

    private MongoConnection mongoConnection = MongoConnection.getInstance();
    private DatabaseConnection databaseConnection = DatabaseConnection.getInstance();
    private Long lastTimestamp = null;
    private long timeSinceLastTemperatureAlert = 0;
    private long timeSinceLastLightAlert = 0;

    private ArrayList<Measurement> measurements = new ArrayList<>();
    private ArrayList<AndroidAlert> lightAlerts = new ArrayList<>();
    private ArrayList<AndroidAlert> temperatureAlerts = new ArrayList<>();

    @Override
    public synchronized void start() {
        super.start();
        lastTimestamp = System.currentTimeMillis();
    }

    @Override
    public void run() {

        while(true) {

            calculateDeltas();

            readFromMongo();

            // Check if was woken by an alert
            if(lightAlerts.size() > 0) {
                timeSinceLastLightAlert = 0;

                lightAlerts.forEach(alert -> {
                    try {
                        databaseConnection.insertAlert(alert);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                });

                lightAlerts.clear();
            }

            if(temperatureAlerts.size() > 0) {
                timeSinceLastTemperatureAlert = 0;

                temperatureAlerts.forEach(alert -> {
                    try {
                        databaseConnection.insertAlert(alert);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                });

                temperatureAlerts.clear();
            }

            // export measurements
            for(Measurement measurement: measurements) {
                try {
                    databaseConnection.insertMeasurement(measurement);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            measurements.clear();
        }

    }

    /**
     * Updates the time deltas
     */
    private void calculateDeltas() {
        timeSinceLastTemperatureAlert += System.currentTimeMillis() - lastTimestamp;
        timeSinceLastLightAlert += System.currentTimeMillis() - lastTimestamp;
    }

    /**
     * Reads all values from the MongoDB database, interprets them, and adds them to the corresponding lists.
     */
    private void readFromMongo() {
        // Read from mongo
        ArrayList<DBObject> arrayList = new ArrayList<>();
        try {
            arrayList = mongoConnection.read();
            System.out.println("----| Starting export of " + arrayList.size() + " database objects |----");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        for (DBObject object : arrayList) {
            interpretJSON(object);
        }

        System.out.println("There are currently " + lightAlerts.size() + " light alerts, and " + temperatureAlerts.size() + " temperature alerts!");

        mongoConnection.deleteAll();
    }

    private void interpretJSON(DBObject object) {
        System.out.println("Time since last light alert: " + timeSinceLastLightAlert);
        System.out.println("Time since last temperature alert: " + timeSinceLastTemperatureAlert);
        JSONParser parser = new JSONParser();

        System.out.println(object.toString());

        JSONObject obj = null;
        try {
            obj = (JSONObject) parser.parse(object.toString());
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Measurement lightMeasurement = null;
        Measurement temperatureMeasurement = null;

        if(obj != null) {
            String timestamp = (String) obj.get("timestamp");

            Object lightObject = obj.get("luminosidade");

            if(lightObject != null) {
                int light = (int) Double.parseDouble((String) lightObject);
                String lightReason = (String) obj.get("causaLuminosidade");
                boolean lightError = Boolean.parseBoolean((String)obj.get("erroLuminosidade"));

                lightMeasurement = new Measurement(Measurement.MeasurementType.LIGHT, timestamp, light, lightReason, lightError);

                String lightAlert = (String) obj.get("alertaLuminosidade");
                if(lightAlert != null && timeSinceLastLightAlert >= 15000) { // TODO replace hardcoded value

                    String description = "Description here";

                    lightAlerts.add(new AndroidAlert("luz", timestamp, -11111, -11111, light, description));
                    timeSinceLastLightAlert = 0;
                }
            }

            Object tempObject = obj.get("temperatura");

            if(tempObject != null) {
                int temp = (int) Double.parseDouble((String)tempObject);
                String tempReason = (String) obj.get("causaTemperatura");
                boolean tempError = Boolean.parseBoolean((String)obj.get("erroTemperatura"));

                temperatureMeasurement = new Measurement(Measurement.MeasurementType.TEMP, timestamp, temp, tempReason, tempError);

                String temperatureAlert = (String) obj.get("alertaTemperatura");
                if(temperatureAlert != null && timeSinceLastTemperatureAlert > 15000) { // TODO replace hardcoded value
                    temperatureAlerts.add(new AndroidAlert("temperatura", timestamp, -11111, -11111, temp, "Descri aqui!"));
                    timeSinceLastTemperatureAlert = 0;
                }
            }
        }

        if(lightMeasurement != null)
            measurements.add(lightMeasurement);
        if(temperatureMeasurement != null)
            measurements.add(temperatureMeasurement);

    }



}
