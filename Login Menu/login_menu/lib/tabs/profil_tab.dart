import 'package:flutter/material.dart';
import 'package:login_menu/pages/login_page.dart';
import 'package:login_menu/pages/profile_page.dart';

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // Tab Profile
        SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'RamanPreet Singh',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'snippetcoder@outlook.com',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const _ProfileMenuItem(
              icon: Icons.shopping_bag_outlined, title: 'Orders'),
          const _ProfileMenuItem(icon: Icons.credit_card, title: 'Profile'),
          const _ProfileMenuItem(
              icon: Icons.location_on_outlined, title: 'Addresses'),
          const _ProfileMenuItem(icon: Icons.info_outline, title: 'About'),
          const SizedBox(height: 30),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false, // Xóa hết các trang trước
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (title == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else if (title == "Orders") {
        } else if (title == "Addresses") {
        } else {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn vừa chọn "$title"')),
        );
      },
    );
  }
}
