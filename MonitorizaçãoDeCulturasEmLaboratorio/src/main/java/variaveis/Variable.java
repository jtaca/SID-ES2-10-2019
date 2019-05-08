package variaveis;

public class Variable {

    private Integer id;
    private String name;

    public Variable(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Variable(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        if(id == null) {
            return "(NULL, \"" + name +"\")";
        } else {
            return "(" + id + ",\"" + name +"\")";
        }

    }
}
