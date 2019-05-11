package api;

/**
 *Class that represents an investigator and the respective attributes that define it.
 */

public class Investigador {

    private String password;
    private String name;
    private String email;
    private String category;

    /**
     * Class constructer used mainly to register investigators in database.
     * @param password the password of the database access investigator.
     * @param name the name of investigator.
     * @param email the email of investigator.
     * @param category the professional category in which the investigator is inserted.
     */

    public Investigador(String password, String name, String email, String category) {
        this.password = password;
        this.name = name;
        this.email = email;
        this.category = category;
    }

    /**
     * Returns the investigator's password.
     * @return the password.
     */

    public String getPassword(){
        return password;
    }

    /**
     * Returns the investigator's name.
     * @return the name.
     */

    public String getName() {
        return name;
    }

    /**
     * Returns the investigator's email.
     * @return the email.
     */

    public String getEmail() {
        return email;
    }

    /**
     * Returns the investigator's professional category.
     * @return the password.
     */

    public String getCategory() {
        return category;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
