 import 'package:flutter/material.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  class AddPenjualan extends StatefulWidget {
    const AddPenjualan({super.key});

    @override
    State<AddPenjualan> createState() => _AddPenjualanState();
  }

  class _AddPenjualanState extends State<AddPenjualan> {
    final _tglpnj = TextEditingController();
    final _totalhrg = TextEditingController();
    final _pelanggan = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    // Function to insert the pelanggan
    Future<void> langgan() async {
      if (_formKey.currentState!.validate()) {
        final String TanggalPenjualan= _tglpnj.text;
        final String TotalHarga = _totalhrg.text;
        final String PelangganID= _pelanggan.text;

        // Insert pelanggan data
        final response = await Supabase.instance.client.from('Penjualan').insert(
          {
            'TanggalPenjualan': TanggalPenjualan,
            'TotalHarga': TotalHarga,
            'Pelanggan': PelangganID,
          },
        );

        if (response.error == null) {
          // Navigate to Homepage on success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${response.error!.message}'),
          ));
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Penjualan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tglpnj,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Penjualan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalhrg,
                  decoration: const InputDecoration(
                    labelText: 'TotalHarga',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'TotalHarga tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pelanggan,
                  decoration: const InputDecoration(
                    labelText: 'PelangganID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'PelangganID tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: langgan,
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Dummy Homepage class for navigation
  class Homepage extends StatelessWidget {
    const Homepage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Homepage'),
        ),
        body: const Center(
          child: Text('Selamat Datang di Homepage!'),
        ),
      );
  
    }
  }
