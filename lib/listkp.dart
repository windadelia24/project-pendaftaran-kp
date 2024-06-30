import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/ajukantempat.dart';
import 'package:myapp/daftarkp.dart';
import 'package:myapp/editkp.dart';
import 'package:myapp/listtawaran.dart';
import 'package:myapp/models/internship.dart';
import 'package:myapp/navbar.dart';

class ListKp extends StatefulWidget {
  const ListKp({Key? key}) : super(key: key);

  @override
  _ListKpState createState() => _ListKpState();
}

class _ListKpState extends State<ListKp> {
  Map<String, dynamic>? profile;
  List<InternshipElement> internships = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadInternships();
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

  Future<void> _loadInternships() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    if (token != null) {
      final url = Uri.parse('https://backend-pmp.unand.dev/api/my-internships');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Internship internshipData = Internship.fromJson(jsonResponse);
        setState(() {
          internships = internshipData.internships;
          isLoading = false;
        });
      } else {
        // Handle API error
        print('Failed to load internships');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran KP', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFE1E9F0),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const NavBar(),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text("List KP"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListKp()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text("List Tawaran KP"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListTawaran()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload),
                title: const Text("Daftar KP"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKp()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text("Ajukan Tempat"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Ajukan()));
                },
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? const Center(child: Text('Profile data not available'))
              : CustomList(profile: profile!, internships: internships),
    );
  }
}

class CustomList extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<InternshipElement> internships;

  const CustomList({Key? key, required this.profile, required this.internships}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const monthNames = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 8.0),
          elevation: 10.0,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFFE1E9F0),
              image: DecorationImage(
                image: AssetImage('images/unand.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/profile.jpg'),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 39, 31, 31),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        profile['nim'] ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        profile['department_name'] ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          child: const Text(
            'List KP Yang Diikuti',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        ...internships.map((internship) => Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditKp(internshipId: internship.id))); // Navigates to EditKp with internshipId
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE1E9F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  internship.company,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(internship.title ?? 'No title available'),
                trailing: Text(
                  '${_formatDate(internship.startAt)} - ${_formatDate(internship.endAt)}',
                ),
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }
}
