import 'dart:convert';

class Profile {
  int id;
  String name;
  String email;

  Profile({this.id = 0, this.name, this.email});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        id: map["id"], name: map["name"], email: map["email"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, email: $email}';
  }

}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
