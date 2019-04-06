package variaveis;

public class Variable {

    private Integer id;
    private String nome;

    public Variable(int id, String nome) {
        this.id = id;
        this.nome = nome;
    }

    public Variable(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        if(id == null) {
            return "(NULL, \"" + nome +"\")";
        } else {
            return "(" + id + ",\"" + nome +"\")";
        }

    }
}
