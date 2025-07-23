import 'package:flutter/material.dart';
import 'package:study/utils/user_manager.dart';
import 'package:study/pages/login_page.dart';

class LogoutWidget extends StatelessWidget {
  final String? buttonText;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Size? buttonSize;
  final bool useSearchBarStyle;

  const LogoutWidget({
    super.key,
    this.buttonText,
    this.icon,
    this.buttonStyle,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.buttonSize,
    this.useSearchBarStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showLogoutDialog(context),
      icon: Icon(icon ?? Icons.logout),
      label: Text(
        buttonText ?? '退出登录',
        style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
      style: buttonStyle ?? _defaultLogoutButtonStyle(),
    );
  }

  // 默认登出按钮样式
  ButtonStyle _defaultLogoutButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.red,
      foregroundColor: textColor ?? Colors.white,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      fixedSize: buttonSize,
      elevation: useSearchBarStyle ? 0 : 2,
      shadowColor: useSearchBarStyle ? Colors.transparent : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        side: useSearchBarStyle 
          ? BorderSide(color: const Color(0xFFE0E0E0), width: 0.5)
          : BorderSide.none,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.all(backgroundColor ?? Colors.red),
      foregroundColor: WidgetStateProperty.all(textColor ?? Colors.white),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return (textColor ?? Colors.white).withValues(alpha: 0.1);
        }
        return null;
      }),
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
    
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      
      _showLogoutSuccessMessage(context);
    }
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