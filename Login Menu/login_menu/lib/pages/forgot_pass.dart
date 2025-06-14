import 'package:flutter/material.dart';
import 'package:login_menu/Components/new_pass_button.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});
  void NewPass() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text(
          'Forgot Password Page',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.key, size: 120),
                SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Username ",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New password ",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm new password ",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //Sign in button
                NewPassButton(onTap: NewPass),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
