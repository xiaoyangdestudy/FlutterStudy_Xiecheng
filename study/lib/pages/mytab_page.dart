
import 'package:flutter/material.dart';
import 'package:study/utils/user_manager.dart';
import 'package:study/pages/login_page.dart';

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
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  // 构建登出按钮
  Widget _buildLogoutButton() {
    return Builder(
      builder: (context) => ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout),
        label: const Text('退出登录'),
        style: _logoutButtonStyle(),
      ),
    );
  }

  // 登出按钮样式
  ButtonStyle _logoutButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // 显示登出确认对话框
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          _buildCancelButton(context),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  // 取消按钮
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('取消'),
    );
  }

  // 确认登出按钮
  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _performLogout(context),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('退出登录'),
    );
  }

  // 执行登出操作
  void _performLogout(BuildContext context) async {
    Navigator.of(context).pop();
    
    await UserManager.clearLoginState();
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
    
    _showLogoutSuccessMessage(context);
  }

  // 显示登出成功消息
  void _showLogoutSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已退出登录'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
