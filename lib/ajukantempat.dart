import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:myapp/daftarkp.dart';
import 'package:myapp/listkp.dart';
import 'package:myapp/listtawaran.dart';
import 'package:myapp/navbar.dart';

class Ajukan extends StatelessWidget {
  const Ajukan({super.key});

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
      body: const CustomAjukan(),
    );
  }
}

class CustomAjukan extends StatefulWidget {
  const CustomAjukan({super.key});

  @override
  _CustomAjukanState createState() => _CustomAjukanState();
}

class _CustomAjukanState extends State<CustomAjukan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  Future<void> submitCompany() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('login_token') ?? '';

    final response = await http.post(
      Uri.parse('https://backend-pmp.unand.dev/api/internship-companies'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'address': _addressController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mengajukan tempat KP')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ListKp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan tempat KP: ${response.body}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE1E9F0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                child: const Text(
                  'Ajukan Tempat KP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nama Instansi',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama instansi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Alamat',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat instansi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        submitCompany();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9EE1),
                      ),
                      child: const Text('Ajukan', style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
