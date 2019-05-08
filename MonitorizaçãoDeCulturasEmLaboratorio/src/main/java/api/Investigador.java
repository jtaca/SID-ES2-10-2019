package api;

public class Investigador {

    private String password;
    private String name;
    private String email;
    private String category;
    private String user_type;

    public Investigador(String password, String name, String email, String category, String user_type) {
        this.password = password;
        this.name = name;
        this.email = email;
        this.category = category;
        this.user_type = user_type;
    }

    public Investigador(String name, String email, String category, String user_type) {
        this.name = name;
        this.email = email;
        this.category = category;
        this.user_type = user_type;
    }

    public String getPassword(){
        return password;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getCategory() {
        return category;
    }

    public String getUser_type() {
        return user_type;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
