import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUser extends StatefulWidget {
  final int UserID;

  const UpdateUser({super.key, required this.UserID});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();
  final user = TextEditingController();
  final pass = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    dataUser();
  }

  Future<void> dataUser() async {
    final data = await supabase
        .from('user')
        .select()
        .eq('UserID', widget.UserID)
        .single();

    setState(() {
      user.text = (data['Username'] ?? '').toString();
      pass.text = (data['Password'] ?? '').toString();
    });
  }

  Future<void> updatePelanggan() async {
    if (formKey.currentState!.validate()) {
      await supabase.from('user').update({
        'Username': user.text,
        'Password': pass.text,
      }).eq('UserID', widget.UserID.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(121, 255, 0, 128),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(user, 'Username'),
              const SizedBox(height: 10),
              _buildTextField(pass, 'Password'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: updatePelanggan,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(121, 255, 0, 128)),
                child:
                    const Text('Update', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }
}