class User {
  final int id;
  final String email;
  final String password;
  final String username;
  final String firstname;
  final String lastname;
  String profilePictureUrl;
  String profilePictureName;

  User(this.id, this.email, this.password, this.username, this.firstname, this.lastname, this.profilePictureUrl, this.profilePictureName);

factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['email'],
      json['password'],
      json['username'],
      json['firstname'],
      json['lastname'],
      json['profilePictureUrl'],
      json['profilePictureName'],
    );
  }
 @override
  String toString() {
    return "{id: $id, email: $email, password: $password, username: $username, firstname: $firstname, lastname: $lastname, url: $profilePictureUrl}";
  }
}