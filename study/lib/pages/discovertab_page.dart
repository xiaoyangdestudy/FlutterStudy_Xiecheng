import 'package:flutter/material.dart';

class DiscoverTabPage extends StatelessWidget {
  const DiscoverTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              '发现页面',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}