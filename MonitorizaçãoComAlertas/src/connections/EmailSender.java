package connections;
 
import connections.LoggerControl;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Logger;
 
/**
 * Class that creates and sends an email from user given information
 */
public class EmailSender {
 
    private String email;
    private Properties props;
    private Session session;
    private Message message;
    private Logger logger = LoggerControl.setFileSave(Logger.getLogger(EmailSender.class.getName()));
    private ArrayList<String> emails;
 
    /**
     * Constructor called by user with the account credentials of the user's email account calls the necessary setup functions
     * @param config config manager received from gui
     */
    public EmailSender(ArrayList<String> emails, String email) {
        this.emails = emails;
        this.email= email;
 
        setProperties();
        makeSession(loadPassword());
    }
 
    /**
     * Fetches email from config
     * @return email as a string
     */
    @SuppressWarnings("unused")
	private String loadEmailAddress() {
        String addr = "";
        try {
            addr = "alertasestufa@outlook.com";
			logger.info("Email address from email: " + addr);
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        return addr;
    }
 
    /**
     * Fetches password from config
     * @return password as a string
     */
    private String loadPassword() {
        String pw = "";
        try {
            pw = "alertaestufa2019";
            logger.info("Password from email: " + pw.length() + " characters.");
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        return pw;
    }
 
    /**
     * Called by the user after starting the sender with the contents of the message
     * @param recipient email to send the message to
     * @param subject   email subject
     * @param content   email text
     */
    public void makeMessage(String recipient, String subject, String content) {
        try {
            System.out.println("makeMessage");
            message = new MimeMessage(session);
            message.setFrom(new InternetAddress(email));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(content);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
 
    /**
     * Called by the user when ready to send the mail
     */
    public void sendMail() {
        try {
            System.out.println("sendMail");
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
 
    /**
     * Creates the session using javax authenticator
     * @param password used to authenticate alongside the email
     */
    private void makeSession(String password) {
        session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(email, password);
                    }
                });
    }
 
    /**
     * Creates and sets the properties for the email session
     */
    private void setProperties() {
        props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "outlook.office365.com");
        props.put("mail.smtp.port", "587");
    }
    
    
    @SuppressWarnings("unused")
	public void send4All(String titulo, String causa) {
    	for(int i =0 ; i!= emails.size();i++) {
    		makeMessage(emails.get(i), titulo, causa);
    		sendMail();
    	}
    }
}