import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NavBar extends StatefulWidget {  
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFFE1E9F0),
        image: DecorationImage(
          image: AssetImage('images/unand.jpg'), // Replace with your image path
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
                image: AssetImage('images/profile.jpg'), // Replace with your profile image path
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
        ],
      ),
    );
  }
}
