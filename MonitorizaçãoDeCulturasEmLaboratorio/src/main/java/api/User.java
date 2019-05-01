package api;

public class User {

    private int id;
    private String name;
    private String email;
    private String category;
    private String user_type;

    public User(int id, String name, String email, String category, String user_type) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.category = category;
        this.user_type = user_type;
    }

    public User(String name, String email, String category, String user_type) {
        this.name = name;
        this.email = email;
        this.category = category;
        this.user_type = user_type;
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
