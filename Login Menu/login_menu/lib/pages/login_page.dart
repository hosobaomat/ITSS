import 'package:flutter/material.dart';
import 'package:login_menu/Components/button.dart';
import 'package:login_menu/pages/home_page.dart';
import 'package:login_menu/pages/register_page.dart';
import 'package:login_menu/pages/forgot_pass.dart';
import 'package:login_menu/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    bool success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      signInUser(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sai tài khoản hoặc mật khẩu")),
      );
    }
  }

  void signInUser(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),

                const Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),

                const SizedBox(height: 25),
                //username textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPass(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                //Sign in button
                MyButton(onTap: _login),

                const SizedBox(height: 20),

                //another login's
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                      Text('or continue with'),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/images/google.png', height: 50),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                //not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Register now!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
