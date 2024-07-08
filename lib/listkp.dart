import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/ajukantempat.dart';
import 'package:myapp/daftarkp.dart';
import 'package:myapp/editkp.dart';
import 'package:myapp/listtawaran.dart';
import 'package:myapp/models/internship.dart';
import 'package:myapp/models/gempa.dart';
import 'package:myapp/navbar.dart';
import 'package:intl/intl.dart';

class ListKp extends StatefulWidget {
  const ListKp({Key? key}) : super(key: key);

  @override
  _ListKpState createState() => _ListKpState();
}

class _ListKpState extends State<ListKp> {
  Map<String, dynamic>? profile;
  List<InternshipElement> internships = [];
  List<GempaTerkini> earthquakes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadInternships();
    _loadEarthquakes();
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

  Future<void> _loadEarthquakes() async {
    final url = Uri.parse(
        'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime&limit=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      GempaTerkini earthquakeData = GempaTerkini.fromJson(jsonResponse);
      setState(() {
        earthquakes = [earthquakeData];
        isLoading = false;
      });
    } else {
      print('Failed to load earthquakes');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(int epochTime) {
    var date = DateTime.fromMillisecondsSinceEpoch(epochTime);
    var formatter = DateFormat('dd MMMM yyyy HH:mm:ss');
    return formatter.format(date);
  }

  Future<void> _loadInternships() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    if (token != null) {
      final url = Uri.parse('https://backend-pmp.unand.dev/api/my-internships');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Internship internshipData = Internship.fromJson(jsonResponse);
        setState(() {
          internships = internshipData.internships;
          isLoading = false;
        });
      } else {
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
              : CustomList(profile: profile!, internships: internships, earthquakes: earthquakes),
    );
  }
}

class CustomList extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<InternshipElement> internships;
  final List<GempaTerkini> earthquakes;

  const CustomList({Key? key, required this.profile, required this.internships, required this.earthquakes}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return "${date.day} ${_monthName(date.month)} ${date.year} ${DateFormat('HH:mm:ss a').format(date)}";
  }
  String _dateFormat(DateTime? date) {
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
          margin: const EdgeInsets.all(8.0),
          elevation: 5.0,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Informasi Gempa Terkini',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ...earthquakes.map((earthquake) => ListTile(
                title: Text(
                  earthquake.features[0].properties.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lokasi: ${earthquake.features[0].properties.place}'),
                    Text('Magnitude: ${earthquake.features[0].properties.mag.toStringAsFixed(1)}'),
                    Text('Potensi Tsunami: ${earthquake.features[0].properties.tsunami == 1 ? 'Berpotensi' : 'Tidak berpotensi'}'),
                    Text('Waktu: ${_formatDate(DateTime.fromMillisecondsSinceEpoch(earthquake.features[0].properties.time))}'),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 5.0,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'List KP Yang Diikuti',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ...internships.map((internship) => ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditKp(internshipId: internship.id)));
                },
                title: Text(
                  internship.company,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(internship.title ?? 'No title available'),
                trailing: Text(
                  '${_dateFormat(internship.startAt)} - ${_dateFormat(internship.endAt)}',
                ),
              )).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
