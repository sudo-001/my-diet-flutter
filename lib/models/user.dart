class Users {
  String password;
  String email;
  // bool feeling;
  String name;
  // bool obese;
  // String image;
  // String disease;
  // bool diabete;
  // bool hiv;

  Users({
    required this.password,
    required this.email,
    required this.name,
  });

  factory Users.fromMap(Map user) {
    return Users(
      password: user["password"],
      email: user["email"],
      name: user["name"],
    );
  }

  Map toMap() {
    return {
      "password": password,
      "email": email,
      "name": name,
    };
  }
}
