import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganTab extends StatefulWidget {
  const PelangganTab({Key? key}) : super(key: key);

  @override
  State<PelangganTab> createState() => _PelangganTabState();
}

class _PelangganTabState extends State<PelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  // Fetch data pelanggan
  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('Pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
      _showErrorDialog('Gagal memuat data pelanggan.');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Tambahkan data pelanggan
  Future<void> addPelanggan(String nama, String alamat, String telepon) async {
    if (nama.isEmpty || alamat.isEmpty || telepon.isEmpty) {
      _showErrorDialog('Semua field harus diisi!');
      return;
    }

    try {
      final response = await Supabase.instance.client.from('Pelanggan').insert({
        'NamaPelanggan': nama,
        'Alamat': alamat,
        'NomorTelepon': telepon,
      });
      if (response != null) {
        fetchPelanggan();
      } else {
        _showErrorDialog('Gagal menambahkan pelanggan.');
      }
    } catch (e) {
      print('Error adding pelanggan: $e');
      _showErrorDialog('Gagal menambahkan pelanggan.');
    }
  }

  // Update data pelanggan
  Future<void> updatePelanggan(
      int id, String nama, String alamat, String telepon) async {
    if (nama.isEmpty || alamat.isEmpty || telepon.isEmpty) {
      _showErrorDialog('Semua field harus diisi!');
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('Pelanggan')
          .update({
            'NamaPelanggan': nama,
            'Alamat': alamat,
            'NomorTelepon': telepon,
          })
          .eq('PelangganID', id);

      if (response != null) {
        fetchPelanggan();
      } else {
        _showErrorDialog('Gagal memperbarui pelanggan.');
      }
    } catch (e) {
      print('Error updating pelanggan: $e');
      _showErrorDialog('Gagal memperbarui pelanggan.');
    }
  }

  // Delete data pelanggan dengan konfirmasi
  Future<void> deletePelanggan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final response = await Supabase.instance.client
            .from('Pelanggan')
            .delete()
            .eq('PelangganID', id);

        if (response != null) {
          fetchPelanggan();
        } else {
          _showErrorDialog('Gagal menghapus pelanggan.');
        }
      } catch (e) {
        print('Error deleting pelanggan: $e');
        _showErrorDialog('Terjadi kesalahan saat menghapus pelanggan.');
      }
    }
  }

  // Show dialog untuk tambah atau edit pelanggan
  void showPelangganDialog({Map<String, dynamic>? pelanggan}) {
    final TextEditingController namaController =
        TextEditingController(text: pelanggan?['NamaPelanggan']);
    final TextEditingController alamatController =
        TextEditingController(text: pelanggan?['Alamat']);
    final TextEditingController teleponController =
        TextEditingController(text: pelanggan?['NomorTelepon']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pelanggan == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
              ),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (pelanggan == null) {
                  addPelanggan(
                    namaController.text.trim(),
                    alamatController.text.trim(),
                    teleponController.text.trim(),
                  );
                } else {
                  updatePelanggan(
                    pelanggan['PelangganID'],
                    namaController.text.trim(),
                    alamatController.text.trim(),
                    teleponController.text.trim(),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pelanggan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pelanggan.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada pelanggan tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: pelanggan.length,
                  itemBuilder: (context, index) {
                    final data = pelanggan[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['NamaPelanggan']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alamat: ${data['Alamat']}'),
                            Text('Telepon: ${data['NomorTelepon']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showPelangganDialog(
                                pelanggan: data,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () =>
                                  deletePelanggan(data['PelangganID']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPelangganDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
