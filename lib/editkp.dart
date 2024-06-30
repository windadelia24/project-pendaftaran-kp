import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/listkp.dart';
import 'package:myapp/models/detail.dart';
import 'package:myapp/models/company.dart';
import 'package:myapp/models/students.dart';

class EditKp extends StatelessWidget {
  final String internshipId;

  const EditKp({Key? key, required this.internshipId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Proposal KP'),
      ),
      body: CustomEdit(internshipId: internshipId),
    );
  }
}

class CustomEdit extends StatefulWidget {
  final String internshipId;

  const CustomEdit({Key? key, required this.internshipId}) : super(key: key);

  @override
  _CustomEditState createState() => _CustomEditState();
}

class _CustomEditState extends State<CustomEdit> {
  Detail? internshipDetail;
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
    fetchInternshipDetails();
    fetchStudents();
    fetchCompanies();
  }

  Future<void> fetchInternshipDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('https://backend-pmp.unand.dev/api/my-internships/${widget.internshipId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = detailFromJson(response.body);
        setState(() {
          internshipDetail = data;
          titleController.text = internshipDetail?.proposal.title ?? '';
          jobDescController.text = internshipDetail?.proposal.jobDesc ?? '';
          startDateController.text = DateFormat('dd-MM-yyyy').format(internshipDetail?.proposal.startAt ?? DateTime.now());
          endDateController.text = DateFormat('dd-MM-yyyy').format(internshipDetail?.proposal.endAt ?? DateTime.now());
          selectedCompany = internshipDetail?.proposal.company.id;
          // Assuming you need to preselect students, handle that logic here
        });
      } else {
        print('Failed to load internship details');
      }
    }
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
    String? loggedInStudentId = prefs.getString('student_id'); // Assume you save this when logging in
    
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

      final response = await http.put(
        Uri.parse('https://backend-pmp.unand.dev/api/my-internships/${widget.internshipId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'company_id': selectedCompany,
          'title': titleController.text,
          'job_desc': jobDescController.text,
          'start_at': formatStartDate(startDateController.text), // Format "yyyy-MM-dd"
          'end_at': formatEndDate(endDateController.text),     // Format "yyyy-MM-dd"
          'students': selectedStudents,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'];

        // Show popup with message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
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
        print('Failed to update proposal');
      }
    }
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
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Edit Proposal KP',
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
              ElevatedButton(
                onPressed: () {
                  submitProposal();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9EE1),
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
