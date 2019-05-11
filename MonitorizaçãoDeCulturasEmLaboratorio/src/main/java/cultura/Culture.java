package cultura;

/**
 *Class that represents an culture and the respective attributes that define it.
 */

public class Culture {

    private Integer id;
    private String cultureName;
    private String cultureDescription;
    private String investigatorEmail;

    /**
     * Class constructer used mainly to deleted cultures in database.
     * @param id the identifier number of culture in the database.
     * @param cultureName the name of culture.
     * @param cultureDescription the description of culture.
     * @param investigatorEmail the email address of the investigator responsible for the culture.
     */

    public Culture (Integer id, String cultureName, String cultureDescription, String investigatorEmail) {

        this.id = id;
        this.cultureName = cultureName;
        this.cultureDescription = cultureDescription;
        this.investigatorEmail = investigatorEmail;
    }

    /**
     * Class constructer used mainly to resgister or update informations of the culture in database.
     * @param cultureName the new name of culture.
     * @param cultureDescription the new description of culture.
     * @param investigatorEmail the new email address of the investigator responsible for the culture.
     */

    public Culture (String cultureName, String cultureDescription, String investigatorEmail) {

        this.cultureName = cultureName;
        this.cultureDescription = cultureDescription;
        this.investigatorEmail = investigatorEmail;
    }

    /**
     * Returns the identifier number of the culture.
     * @return the id number.
     */

    public Integer getId() {
        return id;
    }

    /**
     * Returns the culture name.
     * @return the name.
     */

    public String getCultureName() {
        return cultureName;
    }

    /**
     * Returns the text relating to the description of a culture.
     * @return the description.
     */

    public String getCultureDescription() {
        return cultureDescription;
    }


    /**
     * Returns the email of the investigator responsible for the culture.
     * @return the email.
     */

    public String getInvestigatorEmail(){
        return investigatorEmail;
    }

    /**
     * A method that returns a part of the query that is responsable by inserted a culture into the database.
     * @return Returns the query with or without the id of the culture. If return with id a culture  is inserted into the database with the id specified by the user . If returned without id, the field in the database destined for this value is automatically attributed.
     */

    @Override
    public String toString() {

        if(id == null) {
            return "(NULL, '" + cultureName + "', '" + cultureDescription + "', '" + investigatorEmail + "')";
        } else {
            return "(" + id + ", '" + cultureName + "', '" + cultureDescription + "', '" + investigatorEmail + "')";
        }
    }


}
