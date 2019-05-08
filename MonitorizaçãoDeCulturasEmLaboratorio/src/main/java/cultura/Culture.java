package cultura;

public class Culture {


    private Integer id;
    private String cultureName;
    private String cultureDescription;
    private String investigatorEmail;


    public Culture (Integer id, String cultureName, String cultureDescription, String investigatorEmail) {

        this.id = id;
        this.cultureName = cultureName;
        this.cultureDescription = cultureDescription;
        this.investigatorEmail = investigatorEmail;
    }


    public Culture (String cultureName, String cultureDescription, String investigatorEmail) {

        this.cultureName = cultureName;
        this.cultureDescription = cultureDescription;
        this.investigatorEmail = investigatorEmail;
    }

    public Integer getId() {
        return id;
    }

    public String getCultureName() {
        return cultureName;
    }

    public String getCultureDescription() {
        return cultureDescription;
    }

    public String getInvestigatorEmail(){
        return investigatorEmail;
    }

    @Override
    public String toString() {

        if(id == null) {
            return "(NULL, '" + cultureName + "', '" + cultureDescription + "', '" + investigatorEmail + "')";
        } else {
            return "(" + id + ", '" + cultureName + "', '" + cultureDescription + "', '" + investigatorEmail + "')";
        }
    }


}
