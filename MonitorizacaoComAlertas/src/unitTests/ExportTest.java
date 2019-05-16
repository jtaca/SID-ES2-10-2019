import export.ExportThread;
import medicao.Sistema;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ExportTest {

    @Test
    void getTemperatureMeasurementTest(){
        ExportThread exportThread = new ExportThread();
        exportThread.setSistema(new Sistema(0,0,0,0,0,0,0,0,0,0));
        String jsonTest = "{\"causaTemperatura\":\"CausaTemp\",\"exportado\":\"0\",\"alertaLuminosidade\":\"1\",\"causaLuminosidade\":\"CausaLum\",\"_id\":{\"$oid\":\"123456789012345678901234\"},\"alertaTemperatura\":\"1\",\"temperatura\":\"25.0\",\"luminosidade\":\"1000.0\",\"timestamp\":\"2019-05-12 22:53:43\"}";

        JSONParser parser = new JSONParser();

        JSONObject obj = null;
        try {
            obj = (JSONObject) parser.parse(jsonTest);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        exportThread.getTemperatureMeasurement(obj);
        assertEquals(1, exportThread.getMeasurements().size());
    }

    @Test
    void getLightMeasurementTest() {
        ExportThread exportThread = new ExportThread();
        exportThread.setSistema(new Sistema(0,0,0,0,0,0,0,0,0,0));
        String jsonTest = "{\"causaTemperatura\":\"CausaTemp\",\"exportado\":\"0\",\"alertaLuminosidade\":\"1\",\"causaLuminosidade\":\"CausaLum\",\"_id\":{\"$oid\":\"123456789012345678901234\"},\"alertaTemperatura\":\"1\",\"temperatura\":\"25.0\",\"luminosidade\":\"1000.0\",\"timestamp\":\"2019-05-12 22:53:43\"}";

        JSONParser parser = new JSONParser();

        JSONObject obj = null;
        try {
            obj = (JSONObject) parser.parse(jsonTest);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        exportThread.getLightMeasurement(obj);
        assertEquals(1, exportThread.getMeasurements().size());
    }

}
