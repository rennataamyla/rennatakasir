import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/insert_user.dart';
import 'package:flutter_application_1/user/update_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexUser extends StatefulWidget {
  const IndexUser({super.key});

  @override
  State<IndexUser> createState() => _IndexUserState();
}

class _IndexUserState extends State<IndexUser> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> user = [];

  @override
  void initState() {
    super.initState();
    ambilUser();
  }

  Future<void> ambilUser() async {
    try {
      final data = await supabase.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> hapusUser(int id) async {
    await supabase.from('user').delete().eq('UserID', id);
    ambilUser(); // Refresh data setelah menghapus
  }

  void konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus user'),
        content: const Text('Apakah Anda yakin ingin menghapus data user ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              hapusUser(id);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(121, 255, 0, 128),
        title: const Text("Daftar User", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: user.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Pelanggan',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(121, 255, 0, 128)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: user.length,
                    itemBuilder: (context, index) {
                      final p = user[index];
                      return Card(
                        color: const Color.fromARGB(255, 255, 115, 185),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                              p['Username'] ?? 'Username tidak tersedia',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['Password'] ?? 'Tidak tersedia',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  shadows: [
                                    Shadow(
                                        color: Colors.white,
                                        blurRadius: 5,
                                        offset: Offset(2, 2))
                                  ],
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateUser(UserID: p['UserID'] ?? 0)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  shadows: [
                                    Shadow(
                                        color: Colors.white,
                                        blurRadius: 5,
                                        offset: Offset(2, 2))
                                  ],
                                ),
                                onPressed: () => konfirmasiHapus(p['UserID']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const InsertUser())),
        backgroundColor: const Color.fromARGB(121, 255, 0, 128),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}