package export;

public class AndroidAlert {

    private String variableName;
    private String cultureName = "todas";
    private String investigatorEmail = "todos";
    private String timestamp;
    private double variableLowerLimit;
    private double variableHigherLimit;
    private double value;
    private String description;

    public AndroidAlert(String variableName, String timestamp, double variableLowerLimit, double variableHigherLimit, double value, String description) {
        this.variableName = variableName;
        this.timestamp = timestamp;
        this.variableLowerLimit = variableLowerLimit;
        this.variableHigherLimit = variableHigherLimit;
        this.value = value;
        this.description = description;
    }

    @Override
    public String toString() {
        return "("
                + "NULL" + ","
                + "\"" + variableName + "\","
                + "\"" + cultureName + "\","
                + "\"" + investigatorEmail + "\","
                + "\"" + timestamp + "\","
                + variableLowerLimit + ","
                + variableHigherLimit + ","
                + value + ","
                + "\"" + description + "\""
                + ")";
    }
}
