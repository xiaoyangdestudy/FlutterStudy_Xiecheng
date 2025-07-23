
import 'package:flutter/material.dart';
import 'package:study/widgets/logout_widget.dart';

class MyTabPage extends StatelessWidget {
  final String userName;
  final String userAccount;

  const MyTabPage({
    super.key,
    required this.userName,
    required this.userAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            Text(
              '用户: $userName',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '账号: $userAccount',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            const LogoutWidget(),
          ],
        ),
      ),
    );
  }
}
