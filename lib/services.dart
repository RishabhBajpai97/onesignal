import "dart:convert";

import "package:http/http.dart" as http;

class ApiService {
  String baseUri = "http://10.0.2.2:3000";
  Future Login(String email) async {
    var user = await http.post(
      Uri.parse("$baseUri/login"),
      body: json.encode({"email": email}),
    );
    return json.decode(user.body);
  }

  Future SignUp(String name, String email) async {
    var user = await http.post(
      Uri.parse("$baseUri/signup"),
      body: json.encode({"name": name, "email": email}),
    );
    return user.body;
  }

  Future getUsers() async {
    var users = await http.get(Uri.parse("$baseUri/user/getallusers"));
    print("printing");
    return json.decode(users.body);
  }

  Future sendNotification(String id) async {
    var response = await http.post(Uri.parse("$baseUri/user/notifications"),
        body: json.encode({"id": id}));
    return json.decode(response.body);
  }
}
