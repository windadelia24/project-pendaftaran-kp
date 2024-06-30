import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/loginscreen.dart'; // Ganti dengan import yang sesuai

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? profileString = prefs.getString('user_profile');
    if (profileString != null) {
      setState(() {
        profile = json.decode(profileString);
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    if (token == null) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://backend-pmp.unand.dev/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful logout
        final responseData = json.decode(response.body);
        String message = responseData['message'];

        // Show popup with message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle other status codes if needed
        print('Failed to logout: ${response.statusCode}');
        // Show error message if needed
      }
    } catch (e) {
      print('Error during logout: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFFE1E9F0),
        image: DecorationImage(
          image: AssetImage('images/unand.jpg'), // Ganti dengan path gambar yang sesuai
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            height: 70.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('images/profile.jpg'), // Ganti dengan path gambar profil yang sesuai
              ),
            ),
          ),
          Text(
            profile?['name'] ?? 'Unknown',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            profile?['email'] ?? 'Unknown',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
