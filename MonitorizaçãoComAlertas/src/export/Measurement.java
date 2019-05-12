package export;

public class Measurement {
    private MeasurementType type;
    private String timestamp;
    private double value;
    private String reason;
    private boolean error;

    public Measurement(MeasurementType type, String timestamp, double value, String reason, boolean error) {
        this.type = type;
        this.timestamp = timestamp;
        this.value = value;
        this.reason = reason;
        this.error = error;
    }

    public MeasurementType getType() {
        return type;
    }

    public String getReason() {
        return reason;
    }

    public boolean isError() {
        return error;
    }

    @Override
    public String toString() {
        return "(\"" + timestamp + "\","
                + value + ","
                + "NULL" +
                ")";
    }

    public enum MeasurementType {
        LIGHT,
        TEMP
    }
}
