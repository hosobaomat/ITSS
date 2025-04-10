import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 77, 104, 255),
              fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 189, 239, 210),
      ),
    );
  }
}
