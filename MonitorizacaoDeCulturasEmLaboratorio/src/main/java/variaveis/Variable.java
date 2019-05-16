package variaveis;

/**
 *Class that represents an variable and the respective attributes that define it.
 */

public class Variable {

    private Integer id;
    private String name;

    /**
     * Class constructer used mainly to deleted variables in database.
     * @param id the identifier number of variable in the database.
     * @param name the name of variable.
     */

    public Variable(int id, String name) {
        this.id = id;
        this.name = name;
    }

    /**
     * Class constructer used mainly to register of the variables in database.
     * @param name the new name of culture.
     */

    public Variable(String name) {
        this.name = name;
    }

    /**
     * Returns the variable name.
     * @return the name.
     */

    public String getName() {
        return name;
    }

    /**
     * Returns the identifier number of the variable.
     * @return the id number.
     */

    public Integer getId() {
        return id;
    }

    /**
     * A method that returns a part of the query that is responsible by inserted a variable into the database.
     * @return Returns the query with or without the id of the variable. If return with id a variable is inserted into the database with the id specified by the user . If returned without id, the field in the database destined for this value is automatically attributed.
     */

    public String stringToInsert() {
        if(id == null) {
            return "(NULL, \"" + name +"\")";
        } else {
            return "(" + id + ",\"" + name +"\")";
        }

    }

    @Override
    public String toString() {
        return name;
    }
}
