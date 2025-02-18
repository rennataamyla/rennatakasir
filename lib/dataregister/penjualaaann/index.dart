import 'package:flutter/material.dart';
import 'package:flutter_application_1/struk/struk_penjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class IndexPenjualan extends StatefulWidget {
  final int? PenjualanID;
  final int? PelangganID;
  final int? TotalHarga;
  final String? TanggalPenjualan;

  const IndexPenjualan(
      {super.key,
      this.PelangganID,
      this.PenjualanID,
      this.TanggalPenjualan,
      this.TotalHarga});

  @override
  State<IndexPenjualan> createState() => _IndexPenjualanState();
}

class _IndexPenjualanState extends State<IndexPenjualan> {

  final supabase = Supabase.instance.client;
  final TextEditingController cari = TextEditingController();
  List<bool> dipilihItem = [];
  List<Map<String, dynamic>> penjualanList = [];
  List<Map<String, dynamic>> mencariPenjualan = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final result = ModalRoute.of(context)?.settings.arguments as bool?;
    if (result == true) {
      ambilPenjualan();
    }
  }

  @override
  void initState() {
    super.initState();
    ambilPenjualan();
    cari.addListener(pencarianPenjualan);
  }

  Future<void> ambilPenjualan() async {
    try {
      final data = await Supabase.instance.client.from('penjualan').select();
      setState(() {
        penjualanList = List<Map<String, dynamic>>.from(data);
        dipilihItem = List.generate(penjualanList.length, (_) => false);
        mencariPenjualan = penjualanList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Digunakan untuk melakukan pencarian pelanggan berdasarkan input pengguna di Search Bar
  void pencarianPenjualan() {
    setState(() {
      mencariPenjualan = penjualanList
          .where((penjualan) => penjualan['PelangganID']
              .toLowerCase()
              .contains(cari.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: cari,
              decoration: InputDecoration(
                labelText: "Cari Penjualan...",
                labelStyle:
                    const TextStyle(color: Color.fromARGB(121, 255, 0, 128)),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(121, 255, 0, 128)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: mencariPenjualan.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Penjualan',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(121, 255, 0, 128)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: mencariPenjualan.length,
                    itemBuilder: (context, index) {
                      final pen = mencariPenjualan[index];
                      return Card(
                        color: const Color.fromARGB(255, 255, 115, 185),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: dipilihItem[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    dipilihItem[index] = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Tanggal: ${pen['TanggalPenjualan'] ?? 'Tidak tersedia'}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Total Harga: ${pen['TotalHarga'] != null ? pen['TotalHarga'].toString() : 0}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Pelanggan ID: ${pen['PelangganID']?.toString() ?? 'Tidak tersedia'}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (dipilihItem.contains(
              true)) // Hanya tampilkan tombol checkout jika ada yang dipilih
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  final selectedPenjualan = <Map<String, dynamic>>[];
                  int totalHarga = 0;

                  // Mengumpulkan item yang dipilih
                  for (int i = 0; i < penjualanList.length; i++) {
                    if (dipilihItem[i]) {
                      selectedPenjualan.add(penjualanList[i]);
                      totalHarga =
                          penjualanList[i]['TotalHarga']; // Total harga
                    }
                  }

                  if (selectedPenjualan.isNotEmpty) {
                    // Arahkan ke halaman Struk dengan data yang dipilih
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Struk(
                          selectedPenjualan: selectedPenjualan,
                          tanggalPesanan:
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          totalHarga: totalHarga,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Tidak ada penjualan yang dipilih')));
                  }
                },
                child: const Text('Checkout',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(121, 255, 0, 128))),
              ),
            ),
        ],
      ),
    );
  }
}