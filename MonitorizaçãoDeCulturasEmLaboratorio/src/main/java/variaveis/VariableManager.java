package main.java.variaveis;

import java.util.ArrayList;

/**
 * Class representing all the variables the administrator has created.
 * Has methods to add, edit and remove variables.
 */
public class VariableManager {

    private ArrayList<Variable> variaveis = new ArrayList<Variable>();

    public void addVariavel(Variable variable){
        variaveis.add(variable);
    }

}
