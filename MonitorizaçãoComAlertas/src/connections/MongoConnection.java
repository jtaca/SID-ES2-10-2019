package connections;
import com.mongodb.*;

import medicao.Medicao;

public class MongoConnection {

	public void read(){

		@SuppressWarnings("resource")
		MongoClient mongoClient1 = new MongoClient( "localhost",27017);
		@SuppressWarnings("deprecation")
		DB db = mongoClient1.getDB("sensores_grupo10");
		DBCollection table = db.getCollection("medicoes");
		DBCursor cursor = table.find();
		while(cursor.hasNext()) {
			System.out.println(cursor.next());
		}

	}

	public void write(Medicao m){
		MongoClient mongoClient1 = new MongoClient( "localhost",27017);
		@SuppressWarnings("deprecation")
		DB db = mongoClient1.getDB("sensores_grupo10");
		DBCollection table = db.getCollection("medicoes");

		BasicDBObject document = new BasicDBObject();
		document.put("timestamp",m.getTimestamp());
		document.put("temperatura",m.getTemperatura() + "");
		document.put("luminosidade",m.getLuminosidade()+ "");
		document.put("alertaTemperatura",m.isAlertaTemperatura() + "");
		document.put("alertaLuminosidade",m.isAlertaLuminosidade() + "");
		document.put("erroTemperatura",m.isErroTemperatura() + "");
		document.put("erroLuminosidade",m.isErroLuminosidade() + "");
		document.put("exportado", 0 + "");
		try { table.insert(document);} catch (Exception e) {}
		try{Thread.sleep(5000);} catch (InterruptedException  e) {Thread.currentThread().interrupt();}
		mongoClient1.close();		
	}
}	



