import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/models/students.dart';
import 'package:myapp/models/company.dart';
import 'package:myapp/ajukantempat.dart';
import 'package:myapp/listkp.dart';
import 'package:myapp/listtawaran.dart';
import 'package:myapp/navbar.dart';

class DaftarKp extends StatefulWidget {
  const DaftarKp({Key? key}) : super(key: key);

  @override
  _DaftarKpState createState() => _DaftarKpState();
}

class _DaftarKpState extends State<DaftarKp> {
  List<Student> students = [];
  List<CompanyData> companies = [];
  String? selectedCompany;
  List<String> selectedStudents = [];
  final titleController = TextEditingController();
  final jobDescController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
    fetchCompanies();
  }

  Future<void> fetchStudents() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('https://backend-pmp.unand.dev/api/students'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = studentsFromJson(response.body);
        setState(() {
          students = data.data;
        });
      } else {
        print('Failed to load students');
      }
    }
  }

  Future<void> fetchCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('https://backend-pmp.unand.dev/api/internship-companies'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = companyFromJson(response.body);
        setState(() {
          companies = data.data;
        });
      } else {
        print('Failed to load companies');
      }
    }
  }

  Future<void> submitProposal() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    String? loggedInStudentId = prefs.getString('student_id');
    
    if (token != null && selectedCompany != null) {
      if (loggedInStudentId != null && !selectedStudents.contains(loggedInStudentId)) {
        selectedStudents.add(loggedInStudentId);
      }

      String formatStartDate(String date) {
        DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      String formatEndDate(String date) {
        DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      final response = await http.post(
        Uri.parse('https://backend-pmp.unand.dev/api/my-internship-proposals'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'company_id': selectedCompany,
          'title': titleController.text,
          'job_desc': jobDescController.text,
          'start_at': formatStartDate(startDateController.text), 
          'end_at': formatEndDate(endDateController.text),     
          'students': selectedStudents,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ListKp()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to submit proposal');
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
      body: Padding(
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
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Daftar KP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Instansi',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  items: companies.map((company) {
                    return DropdownMenuItem(
                      value: company.id,
                      child: Text(company.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCompany = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCompany,
                  hint: const Text('Pilih Instansi'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Judul KP',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan judul KP',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Deskripsi Pekerjaan',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: jobDescController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan deskripsi pekerjaan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal Mulai',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: startDateController,
                            decoration: const InputDecoration(
                              hintText: 'Ex: 01-01-2024',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal Selesai',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: endDateController,
                            decoration: const InputDecoration(
                              hintText: 'Ex: 01-02-2024',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Teman',
                  style: TextStyle(fontSize: 16),
                ),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      items: students.map((student) {
                        return DropdownMenuItem(
                          value: student.id,
                          child: Text(
                            student.name,
                            style: const TextStyle(fontSize: 14), // Ubah ukuran teks sesuai kebutuhan
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            if (selectedStudents.length > index) {
                              selectedStudents[index] = value;
                            } else {
                              selectedStudents.add(value);
                            }
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: selectedStudents.length > index ? selectedStudents[index] : null,
                      hint: Text('Pilih Teman ${index + 1}'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitProposal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B9EE1),
                  ),
                  child: const Text('Daftar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}