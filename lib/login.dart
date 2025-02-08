import 'package:flutter/material.dart'; // Mengimpor pustaka utama Flutter untuk UI.
import 'package:rennatakasir/homepage.dart'; // Mengimpor halaman utama setelah login.
// import 'package:rennakasir/homepage.dart'; // Baris duplikat yang bisa dihapus.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor pustaka Supabase untuk backend.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan widget binding telah diinisialisasi sebelum menjalankan kode async.
  await Supabase.initialize(
    url: 'https://njefwoyeuwuyehoksium.supabase.co', // URL proyek Supabase.
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZWZ3b3lldXd1eWVob2tzaXVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg3MDgsImV4cCI6MjA1MTg3NDcwOH0.gDqisRACn56V0WSSrRuYkYIbFwneJkUaS3RCCTS-KJw', // Kunci anonim untuk mengakses Supabase.
  );
  runApp(MyApp()); // Menjalankan aplikasi Flutter.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna utama aplikasi.
        scaffoldBackgroundColor: Colors.lightBlue[50], // Warna latar belakang aplikasi.
      ),
      home: LoginPage(), // Menetapkan halaman login sebagai halaman awal.
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState(); // Membuat state untuk halaman login.
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(); // Controller untuk input username.
  final _passwordController = TextEditingController(); // Controller untuk input password.
  final SupabaseClient supabase = Supabase.instance.client; // Mengambil instance Supabase.

  Future<void> _login() async {
    final username = _usernameController.text; // Mendapatkan nilai input username.
    final password = _passwordController.text; // Mendapatkan nilai input password.

    if (username.isEmpty || password.isEmpty) { // Mengecek apakah input kosong.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua field')), // Menampilkan pesan error jika kosong.
      );
      return;
    }

    try {
      // Mengambil data user dari Supabase berdasarkan username.
      final response = await supabase
        .from('user') // Nama tabel dalam database.
        .select('username, password') // Memilih kolom yang dibutuhkan.
        .eq('username', username) // Mencari username yang sesuai.
        .single(); // Mengambil satu data yang cocok.

      if (response != null && response['password'] == password) { // Memeriksa apakah password cocok.
        // Jika login berhasil, tampilkan pesan sukses.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')),
        );
        Navigator.pushReplacement( // Pindah ke halaman utama setelah login.
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password anda salah!')), // Pesan error jika login gagal.
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')), // Menangkap dan menampilkan error.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300], // Warna AppBar.
        title: Text('Login Page'), // Judul AppBar.
        centerTitle: true, // Memposisikan judul di tengah.
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Memberikan padding ke seluruh sisi.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memusatkan elemen di tengah.
          children: [
            Image.asset('assets/image/guitar.png', height: 120), // Menampilkan gambar logo/login.
            SizedBox(height: 24.0), // Spasi antar elemen.
            TextField(
              controller: _usernameController, // Menghubungkan dengan controller.
              decoration: InputDecoration(
                labelText: 'Username', // Label input.
                border: OutlineInputBorder(), // Menambahkan border di input.
                prefixIcon: Icon(Icons.person, color: Colors.blue[300]), // Ikon sebelum input.
                filled: true,
                fillColor: Colors.white, // Latar belakang input berwarna putih.
              ),
            ),
            SizedBox(height: 16.0), // Spasi antar elemen.
            TextField(
              controller: _passwordController, // Menghubungkan dengan controller.
              decoration: InputDecoration(
                labelText: 'Password', // Label input.
                border: OutlineInputBorder(), // Menambahkan border di input.
                prefixIcon: Icon(Icons.lock, color: Colors.blue[300]), // Ikon sebelum input.
                filled: true,
                fillColor: Colors.white, // Latar belakang input berwarna putih.
              ),
              obscureText: true, // Menyembunyikan teks password.
            ),
            SizedBox(height: 24.0), // Spasi antar elemen.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300], // Warna tombol.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Membuat sudut tombol melengkung.
                ),
              ),
              onPressed: _login, // Memanggil fungsi login saat tombol ditekan.
              child: Text('LOGIN', style: TextStyle(color: Colors.white)), // Teks tombol login.
            ),
            SizedBox(height: 16.0), // Spasi antar elemen.
            TextButton(
              onPressed: () {
                print('Forgot password pressed'); // Menampilkan log jika tombol ditekan.
              },
              child: Text(
                'Forgot Password?', // Teks tombol lupa password.
                style: TextStyle(color: Colors.blue[300]), // Warna teks.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
