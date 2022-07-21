import 'user.dart';

class Person {

  final User user;
  final String photoUrl;
  
  const Person(this.user, this.photoUrl);
}



/* class Person {
  final String id;
  final String name;
  final String email;
  final String password;
  //final String role;

  Person({required this.id, required this.name, required this.email, required this.password/* , required this.role */});

  factory Person.fromJson(Map<String, dynamic> json){
    String id = json['id'];
    String name = json['name'];
    String email = json['email'];
    String password = json['password'];
    //String role = json['role'];
    //String srcicon = json['srcicon'] != null ? json['srcicon'] : "";
    
    return Person(
      id: id,
      name: name,
      email: email,
      password: password,
      //role: role
    );
  }

  
  String toString() {
    return "Person(id: $id, name: $name, email: $email, password: $password)";
  }
} */
