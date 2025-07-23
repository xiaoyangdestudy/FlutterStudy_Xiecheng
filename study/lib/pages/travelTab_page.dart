
import 'package:flutter/material.dart';

class TravelTabPage extends StatelessWidget {
  const TravelTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('旅行'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flight,
              size: 80,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              '旅行页面',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}