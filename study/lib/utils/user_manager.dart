import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  // 存储键名常量
  static const String _tokenKey = 'user_token';
  static const String _userInfoKey = 'user_info';
  static const String _accountKey = 'user_account';
  static const String _nameKey = 'user_name';

  // 保存登录状态
  static Future<void> saveLoginState({
    required String token,
    required Map<String, dynamic> userInfo,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 保存token
      await prefs.setString(_tokenKey, token);
      
      // 保存用户信息
      final userInfoJson = json.encode(userInfo);
      await prefs.setString(_userInfoKey, userInfoJson);
      
      // 分别保存账号和姓名（方便快速获取）
      await prefs.setString(_accountKey, userInfo['account'] ?? '');
      await prefs.setString(_nameKey, userInfo['name'] ?? '');
      
      print('✅ Login state saved successfully');
      print('Token: $token');
      print('User info: $userInfo');
      
    } catch (e) {
      print('❌ Failed to save login state: $e');
    }
  }

  // 检查是否已登录
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      
      bool loggedIn = token != null && token.isNotEmpty;
      print('🔍 Login status check: $loggedIn');
      
      return loggedIn;
    } catch (e) {
      print('❌ Failed to check login status: $e');
      return false;
    }
  }

  // 获取保存的Token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('❌ Failed to get token: $e');
      return null;
    }
  }

  // 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoJson = prefs.getString(_userInfoKey);
      
      if (userInfoJson != null && userInfoJson.isNotEmpty) {
        final userInfo = json.decode(userInfoJson) as Map<String, dynamic>;
        print('📋 Retrieved user info: $userInfo');
        return userInfo;
      }
      
      return null;
    } catch (e) {
      print('❌ Failed to get user info: $e');
      return null;
    }
  }

  // 获取用户名
  static Future<String> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_nameKey) ?? 'Unknown User';
    } catch (e) {
      print('❌ Failed to get user name: $e');
      return 'Unknown User';
    }
  }

  // 获取用户账号
  static Future<String> getUserAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accountKey) ?? 'Unknown Account';
    } catch (e) {
      print('❌ Failed to get user account: $e');
      return 'Unknown Account';
    }
  }

  // 清除登录状态
  static Future<void> clearLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 删除所有用户相关的数据
      await prefs.remove(_tokenKey);
      await prefs.remove(_userInfoKey);
      await prefs.remove(_accountKey);
      await prefs.remove(_nameKey);
      
      print('🗑️ Login state cleared successfully');
      
    } catch (e) {
      print('❌ Failed to clear login state: $e');
    }
  }

  // 更新用户信息（可选功能）
  static Future<void> updateUserInfo(Map<String, dynamic> newUserInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 更新用户信息
      final userInfoJson = json.encode(newUserInfo);
      await prefs.setString(_userInfoKey, userInfoJson);
      
      // 更新快速访问字段
      await prefs.setString(_accountKey, newUserInfo['account'] ?? '');
      await prefs.setString(_nameKey, newUserInfo['name'] ?? '');
      
      print('📝 User info updated successfully');
      
    } catch (e) {
      print('❌ Failed to update user info: $e');
    }
  }

  // 获取所有存储的数据（调试用）
  static Future<Map<String, String?>> getAllStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString(_tokenKey),
        'userInfo': prefs.getString(_userInfoKey),
        'account': prefs.getString(_accountKey),
        'name': prefs.getString(_nameKey),
      };
    } catch (e) {
      print('❌ Failed to get all stored data: $e');
      return {};
    }
  }
}