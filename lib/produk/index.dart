import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rennatakasir/homepage.dart';
import 'package:rennatakasir/produk/insert.dart';
import 'package:rennatakasir/produk/update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukTab extends StatefulWidget {
  const ProdukTab({super.key});

  @override
  State<ProdukTab> createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
 
 int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokakhir = 0;
  int stokawal = 0;
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      if (response is List) {
        setState(() {
          produk = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        throw Exception('Data tidak valid');
      }
    } catch (e) {
      print('error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      stokakhir = stokawal - delta;
      if (stokakhir < 0) stokakhir = 0; 
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0; // Tidak boleh negatif
      totalHarga = jumlahPesanan * harga;
      if (totalHarga < 0) totalHarga = 0; // Tidak boleh negatif
    });
  }
  

  Future<void> deleteProduk(int produkId) async {
    try {
      final response = await Supabase.instance.client.from('produk').delete().eq('ProdukID', produkId);
      if (response.error == null) {
        // Successfully deleted
        fetchProduk(); // Refresh product list
      } else {
        throw Exception('Gagal menghapus produk');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : produk.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final prd = produk[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdukDetailPage(produk: prd),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prd['NamaProduk'] ?? 'Nama Tidak Tersedia',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Harga: ${prd['Harga'] ?? 'Tidak Tersedia'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        final produkId = prd['ProdukID'] ?? 0;
                                        if (produkId != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => updateproduk(ProdukID: produkId),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        final produkId = prd['ProdukID'] ?? 0;
                                        if (produkId != 0) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Hapus Produk'),
                                              content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteProduk(produkId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Stok: ${prd['Stok'] ?? 'Tidak Tersedia'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => addproduk()),
          );
        }, 
        label: const Icon(Icons.add),
      ),
    );
  }
}

class ProdukDetailPage extends StatefulWidget {
  final Map<String, dynamic> produk;

  const ProdukDetailPage({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
   int jumlahPesanan = 0;
    int totalHarga = 0;
    int stokakhir = 0;
    int stokawal = 0;

    void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      stokakhir = stokawal - delta;
      if (stokakhir < 0) stokakhir = 0; 
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0; // Tidak boleh negatif
      totalHarga = jumlahPesanan * harga;
      if (totalHarga < 0) totalHarga = 0; // Tidak boleh negatif
    });
  }
   Future<bool> cekProdukAda(String namaProduk) async {
    final response = await Supabase.instance.client.from('produk').select().eq('NamaProduk', namaProduk);
    return response.isNotEmpty;
  }

  Future<void> tambahProduk(Map<String, dynamic> produkBaru) async {
    bool sudahAda = await cekProdukAda(produkBaru['NamaProduk']);
    if (sudahAda) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk sudah ada!')),
      );
      return;
    }
    
    try {
      await Supabase.instance.client.from('produk').insert(produkBaru);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan!')),
      );
    } catch (e) {
      print('Error menambahkan produk: $e');
    }
  }
 
  
Future<void> insertDetailPenjualan(int ProdukID, int PenjualanID, int jumlahPesanan, int totalHarga) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('detailpenjualan').insert({
        'ProdukID': ProdukID,
        'PenjualanID': PenjualanID,
        'JumlahProduk': jumlahPesanan,
        'Subtotal': totalHarga,
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan!')),
        );
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;
    final ProdukID = produk['ProdukID'] ?? 0;
    final PenjualanID = 1; // Contoh ID Penjualan (harus diganti sesuai logika Anda)

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk['NamaProduk'] ?? 'Detail Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.produk['NamaProduk'] ?? 'Nama Tidak Tersedia',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Harga: ${widget.produk['Harga'] ?? 'Tidak Tersedia'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Stok: ${widget.produk['Stok'] ?? 'Tidak Tersedia'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                      IconButton(
                        onPressed: () {
                          updateJumlahPesanan(harga, -1);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$jumlahPesanan',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          updateJumlahPesanan(harga, 1);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Masukkan Keranjang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (jumlahPesanan > 0) {
                      await insertDetailPenjualan(ProdukID, PenjualanID, jumlahPesanan, totalHarga);
                    }
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Beli Sekarang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddProdukPage extends StatelessWidget {
  const AddProdukPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk Baru'),
      ),
      body: const Center(
        child: Text('Form Tambah Produk'),
      ),
    );
  }
}
