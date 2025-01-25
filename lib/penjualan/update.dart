import 'package:flutter/material.dart';
import 'package:rennatakasir/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

  class EditPenjualan extends StatefulWidget {
    final int PenjualanID;

    const EditPenjualan({super.key, required this.PenjualanID});

    @override
    State<EditPenjualan> createState() => _EditPelangganState();
  }

  class _EditPelangganState extends State<EditPenjualan> {
    final _nmplg = TextEditingController();
    final _alamat = TextEditingController();
    final _notlp = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
      super.initState();
      _loadPelangganData();
    }

    // Fungsi untuk memuat data pelanggan berdasarkan ID
    Future<void> _loadPelangganData() async {
      final data = await Supabase.instance.client
          .from('Pelanggan')
          .select()
          .eq('PelangganID', widget.PenjualanID)
          .single();

      setState(() {
        _nmplg.text = data['NamaPelanggan'] ?? '';
        _alamat.text = data['Alamat'] ?? '';
        _notlp.text = data['NomorTelepon'] ?? '';
      });
    }

  // EditPelanggan.dart
  Future<void> updatePelanggan() async {
    if (_formKey.currentState!.validate()) {
      // Melakukan update data pelanggan ke database
      await Supabase.instance.client.from('Pelanggan').update({
        'NamaPelanggan': _nmplg.text,
        'Alamat': _alamat.text,
        'NomorTelepon': _notlp.text,
      }).eq('PelangganID', widget.PenjualanID);

      // Navigasi ke PelangganTab setelah update, dengan menghapus semua halaman sebelumnya dari stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
        (route) => false, // Hapus semua halaman sebelumnya
      );
    }
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Pelanggan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nmplg,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pelanggan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alamat,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notlp,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: updatePelanggan,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }