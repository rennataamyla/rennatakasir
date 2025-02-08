import 'package:flutter/material.dart';
import 'package:rennatakasir/dataregister/index.dart';
import 'package:rennatakasir/dataregister/insert.dart';
import 'package:rennatakasir/detailpenjualan.dart';
import 'package:rennatakasir/produk/index.dart';
import 'package:rennatakasir/dataregister/register.dart';
import 'package:rennatakasir/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rennatakasir/pelanggan/index.dart';
import 'package:rennatakasir/penjualan/index.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Fungsi logout menggunakan Supabase
  void _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login'); // Navigasi ke halaman login setelah logout
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Homepage'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Produk'),
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
              Tab(icon: Icon(Icons.drafts), text: 'Detai Penjualan'), 
              Tab(icon: Icon(Icons.dataset_linked), text: 'Data Register'), 
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Navigasi Cepat',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Produk'),
                onTap: () {
                  Navigator.pop(context);
                  // Logika navigasi atau aksi lainnya
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Pelanggan'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PelangganTab())
                    );
                  // Logika navigasi atau aksi lainnya
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Penjualan'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PenjualanTab())
                    );
                  // Logika navigasi atau aksi lainnya
                },
              ),
               ListTile(
                leading: const Icon(Icons.app_registration_rounded),
                title: const Text('Register'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage())
                    );
                  // Logika navigasi atau aksi lainnya
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context, 
                   MaterialPageRoute(builder: (context) => const SplashScreen()),
                  );// Panggil fungsi logout
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProdukTab(),
            PelangganTab(),
            PenjualanTab(),
            DetailPenjualanTab(),
            RegisterSuccessPage(),
          ],
        ),
      ),
    );
  }
}
