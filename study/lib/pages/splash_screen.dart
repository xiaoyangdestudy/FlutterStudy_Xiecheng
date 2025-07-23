import 'package:flutter/material.dart';
import 'package:study/pages/main_navigation_page.dart';
import 'package:study/utils/user_manager.dart';
import 'package:study/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 检查登录状态并跳转相应页面
  Future<void> _checkLoginStatus() async {
    // 显示启动画面至少1秒（用户体验）
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // 检查是否已登录
      bool isLoggedIn = await UserManager.isLoggedIn();
      
      if (!mounted) return; // 检查Widget是否仍在树中
      
      if (isLoggedIn) {
        // 已登录，获取用户信息并跳转到主页
        await _navigateToHomePage();
      } else {
        // 未登录，跳转到登录页
        await _navigateToLoginPage();
      }
      
    } catch (e) {
      print('Error checking login status: $e');
      // 发生错误时默认跳转到登录页
      await _navigateToLoginPage();
    }
  }

  // 跳转到主页
  Future<void> _navigateToHomePage() async {
    try {
      // 获取用户信息
      final userName = await UserManager.getUserName();
      final userAccount = await UserManager.getUserAccount();
      
      print('Navigating to HomePage for user: $userName ($userAccount)');
      
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationPage(
            userName: userName,
            userAccount: userAccount,
          ),
        ),
      );
      
    } catch (e) {
      await _navigateToLoginPage();
    }
  }

  // 跳转到登录页
  Future<void> _navigateToLoginPage() async {
    print('Navigating to LoginPage');
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _buildSplashContent(),
    );
  }

  // 构建启动页面内容
  Widget _buildSplashContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 应用图标
          _buildAppIcon(),
          const SizedBox(height: 30),
          // 应用名称
          _buildAppTitle(),
          const SizedBox(height: 50),
          // 加载指示器
          _buildLoadingIndicator(),
          const SizedBox(height: 20),
          // 加载文本
          _buildLoadingText(),
        ],
      ),
    );
  }

  // 应用图标
  Widget _buildAppIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.school,
        size: 80,
        color: Colors.blue,
      ),
    );
  }

  // 应用标题
  Widget _buildAppTitle() {
    return const Text(
      'Study App',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }

  // 加载指示器
  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      strokeWidth: 3,
    );
  }

  // 加载文本
  Widget _buildLoadingText() {
    return const Text(
      'Loading...',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    );
  }
}