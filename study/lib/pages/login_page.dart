import 'package:flutter/material.dart';
import 'package:study/pages/main_navigation_page.dart';
import 'package:study/utils/view_tuil.dart';
import 'package:study/widgets/login_widget.dart';
import 'package:study/dao/login_dao.dart';
import 'package:study/utils/user_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_updateLoginButtonState);
    _passwordController.addListener(_updateLoginButtonState);
  }

  void _updateLoginButtonState() {
    setState(() {
      _isLoginEnabled = _accountController.text.isNotEmpty && 
                       _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildOverlay(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset('images/bg.png', fit: BoxFit.cover),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }

  Widget _buildLoginForm() {
    return  Column(
          children: [
            buildSizedBox(height: 100),
            _buildTitle(),
            buildSizedBox(height: 20),
            _buildAccountField(),
            buildSizedBox(height: 20),
            _buildPasswordField(),
            buildSizedBox(height: 20),
            LoginButton('登录', onPressed: _handleLogin, enabled: _isLoginEnabled),
            buildSizedBox(height: 5),
            _buildRegisterLink(),
          ],
        );
  }
  // 标题
  Widget _buildTitle() {
    return const Text(
      '账号密码登录',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  // 账号输入框
  Widget _buildAccountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
      controller: _accountController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '请输入账号',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ));
  }
  // 密码输入框
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
      controller: _passwordController,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '请输入密码',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ));
  }
  // 注册链接
  Widget _buildRegisterLink() {
    // 右边添加一定的边距
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
      child: TextButton(
      onPressed: _handleRegister,
      child: Text(
        '注册账号',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
        ),
      ),
    ))       
    );    
  }
  // 登录按钮点击事件
  void _handleLogin() async {
    final String account = _accountController.text.trim();
    final String password = _passwordController.text.trim();
    
    // 显示加载提示
    _showLoadingDialog();
    
    try {
      // 调用LoginDao的login方法发送登录请求
      final result = await LoginDao.login(account, password);
      
      // 关闭加载提示
      Navigator.of(context).pop();
      
      if (result['success']) {
        // 登录成功 - 保存登录状态
        await UserManager.saveLoginState(
          token: result['token'],
          userInfo: result['user'],
        );
        
        _showSuccessMessage('登录成功！欢迎 ${result['user']['nickname'] ?? result['user']['username']}');
        print('✅ 登录成功！');
        print('🎫 Token: ${result['token']}');
        print('👤 用户信息: ${result['user']}');
        
        // 跳转到主页
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainNavigationPage(
              userName: result['user']['nickname'] ?? result['user']['username'] ?? '用户',
              userAccount: result['user']['username'] ?? '',
            ),
          ),
        );
        
      } else {
        // 登录失败
        _showErrorMessage(result['message']);
        print('❌ 登录失败: ${result['message']}');
      }
      
    } catch (e) {
      // 关闭加载提示
      Navigator.of(context).pop();
      _showErrorMessage('登录请求失败: $e');
      print('💥 登录异常: $e');
    }
  }

  // 跳转注册页面
  void _handleRegister() async {
    const String registerUrl = 'https://www.baidu.com'; // 使用HTTPS协议
    final Uri uri = Uri.parse(registerUrl);
    try {
      // 检查是否可以启动URL
      bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // 在外部浏览器中打开
        );
        if (!launched) {
          _showErrorMessage('启动浏览器失败');
        }
      } else {
        // 尝试使用不同的启动模式
        try {
          bool launched = await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );
          if (!launched) {
            _showErrorMessage('无法打开注册页面，请检查网络连接');
          }
        } catch (e2) {
          _showErrorMessage('无法打开注册页面');
        }
      }
    } catch (e) {
      _showErrorMessage('打开页面失败: $e');
    }
  }

  // 显示加载对话框
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 不能通过点击外部关闭
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('登录中...'),
            ],
          ),
        );
      },
    );
  }

  // 显示成功消息
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // 显示错误消息的辅助方法
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  // 释放资源
  @override
  void dispose() {
    _accountController.removeListener(_updateLoginButtonState);
    _passwordController.removeListener(_updateLoginButtonState);
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}