import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/login.dart';

class Repository {
  final String baseUrl = "https://backend-pmp.unand.dev/";

  Future<Login> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    // Log the response from the server

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var login = Login.fromJson(data);
      await _saveToken(login.token); // Access the token directly
      return login;
    } else {
      final data = json.decode(response.body);
      throw Exception(data['message']);
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_token', token);
  }
}
