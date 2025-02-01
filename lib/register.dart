import 'package:flutter/material.dart';
import 'package:rennatakasir/homepage.dart';
import 'package:rennatakasir/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://njefwoyeuwuyehoksium.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZWZ3b3lldXd1eWVob2tzaXVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg3MDgsImV4cCI6MjA1MTg3NDcwOH0.gDqisRACn56V0WSSrRuYkYIbFwneJkUaS3RCCTS-KJw',
  );
  runApp(MyApp());
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _role = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if(_formKey.currentState!.validate()){
      final String username = _emailController.text;
      final String password = _confirmPasswordController.text;
      final String role = _role.text;
      final user = await Supabase.instance.client.from('user').insert({
        'username': username,
        'password': password,
        'role': role
      });
      if(user == null || user.isEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } else {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    }

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi password tidak cocok')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan verifikasi email Anda.')),
        );
        Navigator.pop(context);
      } else if (response.user != null) {
        throw response.user!;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password harus lebih dari 6 karakter';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _role,
                decoration: const InputDecoration(labelText: 'role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
