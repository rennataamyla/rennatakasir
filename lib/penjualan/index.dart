import 'package:flutter/material.dart';
import 'package:rennatakasir/penjualan/insert.dart';
import 'package:rennatakasir/penjualan/update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanTab extends StatefulWidget {
  const PenjualanTab({super.key});

  @override
  State<PenjualanTab> createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('penjualan').select();
      if (response is List) {
        setState(() {
          penjualan = List<Map<String, dynamic>>.from(response);
        });
      } else {
        throw Exception('Data tidak valid');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: penjualan.isEmpty
          ? Center(
              child: Text(
                'Tidak ada penjualan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
              ),
              padding: EdgeInsets.all(8),
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final item = penjualan[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['NamaPenjualan'] ?? 'Penjualan tidak tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['Deskripsi'] ?? 'Deskripsi Tidak tersedia',
                          style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 16, color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item['Jumlah'] != null ? 'Jumlah: ${item['Jumlah']}' : 'Jumlah tidak tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                final penjualanID = item['PenjualanID'] ?? 0;
                                if (penjualanID != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPenjualan(PenjualanID: penjualanID),
                                    ),
                                  );
                                } else {
                                  print('ID penjualan tidak valid');
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Hapus Penjualan'),
                                      content: const Text('Apakah Anda yakin ingin menghapus penjualan ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            (item['PenjualanID']);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPenjualan()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
