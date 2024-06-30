import 'package:flutter/material.dart';

class EditKp extends StatelessWidget {
  const EditKp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text('Edit Proposal KP'),
      ),
      body: const CustomEdit(),
    );
  }
}

class CustomEdit extends StatefulWidget {
  const CustomEdit({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomEditState createState() => _CustomEditState();
}

class _CustomEditState extends State<CustomEdit> {

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
              const SizedBox(height: 20),
              const Text(
                'Instansi',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'BPS Padang',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tanggal Mulai',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: '2 Januari 2024',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tanggal Selesai',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: '2 Maret 2024',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nama Teman 1',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Intan Aulia',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NIM Teman 1',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: '2111521003',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nama Teman 2',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Aulia Lestari',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NIM Teman 2',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: '2111521004',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nama Teman 3',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Lestari Intan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NIM Teman 3',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: '2111521005',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aksi ketika tombol Lanjut diklik
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9EE1), // Ubah warna latar belakang tombol
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}