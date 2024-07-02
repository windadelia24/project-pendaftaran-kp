import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/ajukantempat.dart';
import 'package:myapp/daftarkp.dart';
import 'package:myapp/listkp.dart';
import 'package:myapp/navbar.dart';
import 'package:myapp/models/openinternship.dart';

class ListTawaran extends StatefulWidget {
  const ListTawaran({super.key});
  
  @override
  _ListTawaranState createState() => _ListTawaranState();
}

class _ListTawaranState extends State<ListTawaran> {
  late Future<List<Proposal>> futureProposals;

  @override
  void initState() {
    super.initState();
    futureProposals = fetchProposals();
  }

  Future<List<Proposal>> fetchProposals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('login_token') ?? '';
    final response = await http.get(
      Uri.parse('https://backend-pmp.unand.dev/api/open-internship-proposals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final proposalsJson = jsonResponse['proposals'] as List;
      return proposalsJson.map((proposal) => Proposal.fromJson(proposal)).toList();
    } else {
      throw Exception('Failed to load proposals');
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
      body: FutureBuilder<List<Proposal>>(
        future: futureProposals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No proposals found.'));
          } else {
            return CustomTawaran(proposals: snapshot.data!);
          }
        },
      ),
    );
  }
}

class CustomTawaran extends StatelessWidget {
  final List<Proposal> proposals;

  const CustomTawaran({super.key, required this.proposals});

  String _formatDate(DateTime date) {
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
        Container(
          padding: const EdgeInsets.all(24.0),
          child: const Text(
            'List Tawaran KP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        for (var proposal in proposals)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFFE1E9F0),
              child: ListTile(
                title: Text(proposal.companyName),
                subtitle: Text(proposal.jobDesc),
                trailing: Text('${_formatDate(proposal.startAt)} - ${_formatDate(proposal.endAt)}'),
                onTap: () {
                },
              ),
            ),
          ),
      ],
    );
  }
}
