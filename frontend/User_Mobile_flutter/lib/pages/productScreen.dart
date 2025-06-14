import 'package:flutter/material.dart';

class Productscreen extends StatelessWidget {
  final String ProductName;
  final List<String> items;

  const Productscreen({
    super.key,
    required this.ProductName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProductName),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.label),
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}
