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

    public void setPassword(String password) {
        this.password = password;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "Investigador{" +
                "password='" + password + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", category='" + category + '\'' +
                '}';
    }
}
