import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  // 登录按钮相关属性值
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  const LoginButton(this.text,{super.key,  required this.onPressed, this.enabled=false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: enabled ? Colors.blue : Colors.grey,
      // 根据enabled的值来决定按钮是否可点击
      onPressed: enabled ? onPressed : null,
      child: Text(text),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      disabledColor: Colors.grey,
      
    );
  }
}