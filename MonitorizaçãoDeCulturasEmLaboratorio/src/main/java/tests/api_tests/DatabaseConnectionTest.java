package tests.api_tests;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.*;
import java.util.*;

import api.DatabaseConnection;

class DatabaseConnectionTest {
	
	private DatabaseConnection dbconn;
		
	@AfterEach
	void tearDown() throws Exception {
	}

	@Test
	void testGetInstance() {
//		
		try {
			dbconn = DatabaseConnection.getInstance();
			dbconn.getInstance();
			assertNotNull(dbconn);
		} catch (Exception e) {
			fail(e.toString());
		}
		
	}
	
	@Test
	void testGetUserEmail() {
		try {

			dbconn.connect("", "");
			dbconn.getUserEmail();
			dbconn.connect(null, null);
			dbconn.getUserEmail();
			dbconn.connect("aa", "aa");
			assertNotNull(dbconn.getUserEmail());
			dbconn.connect("aaa", "aaa");
			assertNotNull(dbconn.getUserEmail());

			
			
		} catch (Exception e) {
			fail(e.toString());
		}
	}

	@Test
	void testIsConnected() {
		
		try {
			dbconn.connect("aa", "aa");
			assertNotNull(dbconn.isConnected());
			
		} catch (Exception e) {
			fail(e.toString());
		}
	}
		
	

	@Test
	void testConnect() {
		try {

			dbconn.connect("", "");
			dbconn.connect(null, null);
			dbconn.connect("aa", "aa");
			dbconn.connect("aaa", "aaa");
			
		} catch (Exception e) {
			fail(e.toString());
		}
		
		

		
	}
		
	

	@Test
	void testSelect() {
		try {
			dbconn.select("");
			dbconn.select("Select * from");
			dbconn.select("Insert into medicoes values 1");
			dbconn.select("SELECT email from mysql.user");
		} catch (Exception e) {
			fail(e.toString());
		}
		
		
	}

	@Test
	void testInsert() {
		fail("Not yet implemented");
	}

	@Test
	void testGetConnection() {
		try {
			dbconn.connect("aa", "aa");
			assertNotNull(dbconn.getConnection());
			
		} catch (Exception e) {
			fail(e.toString());
		}
	}

}
