package connections;

import java.util.ArrayList;


public class EmailSender {
	
	private ArrayList<String> emails;

	public EmailSender(ArrayList<String> emails) {
		super();
		this.emails = emails;
	}

	public ArrayList<String> getEmails() {
		return emails;
	}

}
