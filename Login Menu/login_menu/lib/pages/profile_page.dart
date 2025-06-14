import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('user_name') ?? '';
      phoneController.text = prefs.getString('user_phone') ?? '';
      emailController.text = prefs.getString('user_email') ?? '';
    });
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[300],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  void _saveProfile() async {
    final name = nameController.text;
    final phone = phoneController.text;
    final email = emailController.text;

    if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_email', email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved: $name')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
                controller: nameController,
                decoration: customInputDecoration()),
            const SizedBox(height: 20),
            const Text('Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: customInputDecoration()),
            const SizedBox(height: 20),
            const Text('Email Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: customInputDecoration()),
            const SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: _saveProfile,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text("Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
