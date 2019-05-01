//package databasesConnections;
//import com.mongodb.*;
//import java.util.*;
//import com.mongodb.*;
//import java.net.UnknownHostException;
//
//public class MongoConnection {
//
//	public void mongoRead{
//		
//		MongoClient mongoClient1 = new MongoClient( new MongoClientURI("mongodb://TOSHIBA:27017,TOSHIBA:25017,TOSHIBA:23017/?replicaSet=replicaDemo"));
//
//		DB db = mongoClient1.getDB("db_demo");
//		DBCollection table = db.getCollection("collection_demo");
//		DBCursor cursor = table.find();
//		while(cursor.hasNext()) {
//		    System.out.println(cursor.next());
//		  }
//
//    }
//
//	public void mongoWrite{
//		int i;
//		MongoClient mongoClient = null;
//		MongoClient mongoClient1 = new MongoClient( 
//		   //new MongoClientURI("mongodb://TOSHIBA:27017,TOSHIBA:25017,TOSHIBA:23017/?replicaSet=replicaDemo&autoConnectRetry=true"));
//		   new MongoClientURI("mongodb://TOSHIBA:27017,TOSHIBA:25017,TOSHIBA:23017/?replicaSet=replicaDemo"));
//		DB db = mongoClient1.getDB("db_demo");
//		i=1;
//		DBCollection table = db.getCollection("collection_demo");
//		while(i<6) {
//			
//			BasicDBObject document = new BasicDBObject();
//			document.put("Nome",i);
//			try { table.insert(document);} catch (Exception e) {}
//			i++;
//			try{Thread.sleep(5000);} catch (InterruptedException  e) {Thread.currentThread().interrupt();}
//		}
//		mongoClient1.close();		
//	}
//}	
//
//
//}
