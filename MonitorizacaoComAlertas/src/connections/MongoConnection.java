package connections;

import com.mongodb.*;
import medicao.Medicao;

import java.util.ArrayList;

public class MongoConnection {

    private static MongoConnection single_instance = null;

    public static MongoConnection getInstance(){
        if(single_instance == null) {
            single_instance = new MongoConnection();
        }
        return single_instance;
    }

    private MongoConnection(){}

    /**
     * Allows to read data from a mongo database.
     * @return arraylist of read DBObjects
     * @throws InterruptedException if interrupted while waiting to read again
     */
    public ArrayList<DBObject> read() {
        ArrayList<DBObject> objects = new ArrayList<>();

        MongoClient mongoClient1 = new MongoClient("localhost", 27017);
        DB db = mongoClient1.getDB("sensores_grupo10");
        DBCollection table = db.getCollection("medicoes");
        DBCursor cursor = table.find();
        while (cursor.hasNext()) {
            objects.add(cursor.next());
        }

        return objects;
    }

    /**
     * Deletes all the mongoDB values from the sensores_grupo10 collection.
     */
    public void deleteAll() {
        MongoClient mongoClient1 = new MongoClient("localhost", 27017);
        DB db = mongoClient1.getDB("sensores_grupo10");
        DBCollection table = db.getCollection("medicoes");
        table.remove(new BasicDBObject());
    }

    /**
     * Allows you to write data to a mongo database.
     * @param m is the measurement that must be recorded in the database.
     */
    public void write(Medicao m) {
        MongoClient mongoClient1 = new MongoClient("localhost", 27017);
        @SuppressWarnings("deprecation")
        DB db = mongoClient1.getDB("sensores_grupo10");
        DBCollection table = db.getCollection("medicoes");

		BasicDBObject document = new BasicDBObject();
		document.put("timestamp",m.getTimestamp());
		if(m.getTemperatura()!=null)
			document.put("temperatura",m.getTemperatura() + "");
		if(m.getLuminosidade()!=null)
			document.put("luminosidade",m.getLuminosidade()+ "");
		if(m.isAlertaTemperatura() == 1)
			document.put("alertaTemperatura",1 + "");
		if(m.isAlertaLuminosidade() == 1)
			document.put("alertaLuminosidade",1 + "");
		if(m.isErroTemperatura() == 1)
			document.put("erroTemperatura",1 + "");
		if(m.isErroLuminosidade() == 1)
			document.put("erroLuminosidade",1 + "");
		if(!m.getCausaTemperatura().equals(""))
			document.put("causaTemperatura", m.getCausaTemperatura());
		if(!m.getCausaLuminosidade().equals(""))
			document.put("causaLuminosidade", m.getCausaLuminosidade());
		document.put("exportado", 0 + "");

		try { table.insert(document);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mongoClient1.close();
	}
}	



