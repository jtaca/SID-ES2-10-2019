package variaveis;

import java.util.ArrayList;

/**
 * Class representing all the variables the administrator has created.
 * Has methods to add, edit and remove variables.
 */
public class VariableManager {

    private ArrayList<Variable> variables = new ArrayList<Variable>();

    public ArrayList<Variable> getVariables() {
        return variables;
    }

    public void addVariable(Variable variable){
        variables.add(variable);
    }

}
