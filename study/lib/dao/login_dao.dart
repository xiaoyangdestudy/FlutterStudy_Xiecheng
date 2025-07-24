import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study/config/api_config.dart';

class LoginDao {
  static String get baseUrl => ApiConfig.baseUrl;
  static Future<Map<String, dynamic>> login(String account, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final requestData = {
        'username': account,
        'password': password,
      };
      
      print('Sending login request to: $url');
      print('Request data: $requestData');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
          'token': responseData['data']['token'],
          'user': responseData['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
      
    } catch (e) {
      print('Login request error: $e');
      return {
        'success': false,
        'message': 'Network connection failed, please check if server is running',
        'error': e.toString(),
      };
    }
  }
  
  static Future<Map<String, dynamic>> register(String account, String password, String name) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');
      final requestData = {
        'username': account,
        'password': password,
        'nickname': name,
        'email': '$account@example.com',
      };
      
      print('Sending register request to: $url');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'],
          'user': responseData['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Register failed',
        };
      }
      
    } catch (e) {
      print('Register request error: $e');
      return {
        'success': false,
        'message': 'Network connection failed',
        'error': e.toString(),
      };
    }
  }
}