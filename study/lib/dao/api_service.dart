import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study/config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  
  // 获取轮播图数据
  static Future<List<dynamic>> getBanners() async {
    try {
      final url = Uri.parse('$baseUrl/banners');
      
      print('Sending getBanners request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to load banners: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error fetching banners: $e');
      return [];
    }
  }
  
  // 获取服务分类数据
  static Future<List<dynamic>> getServices() async {
    try {
      final url = Uri.parse('$baseUrl/services');
      
      print('Sending getServices request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to load services: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }
  
  // 获取促销活动数据
  static Future<List<dynamic>> getPromotions({int? limit, String? category}) async {
    try {
      String urlString = '$baseUrl/promotions';
      List<String> params = [];
      
      if (limit != null) params.add('limit=$limit');
      if (category != null) params.add('category=$category');
      
      if (params.isNotEmpty) {
        urlString += '?' + params.join('&');
      }
      
      final url = Uri.parse(urlString);
      
      print('Sending getPromotions request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to load promotions: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error fetching promotions: $e');
      return [];
    }
  }
  
  // 获取推荐内容数据（支持分页）
  static Future<Map<String, dynamic>> getContent({
    int page = 1,
    int limit = 10,
    String? type,
    String? destination,
    String sortBy = 'publishDate',
    String order = 'desc'
  }) async {
    try {
      List<String> params = [
        'page=$page',
        'limit=$limit',
        'sortBy=$sortBy',
        'order=$order'
      ];
      
      if (type != null) params.add('type=$type');
      if (destination != null) params.add('destination=$destination');
      
      final urlString = '$baseUrl/content?' + params.join('&');
      final url = Uri.parse(urlString);
      
      print('Sending getContent request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'data': responseData['data'] as List<dynamic>,
          'pagination': responseData['pagination'] as Map<String, dynamic>,
        };
      } else {
        print('Failed to load content: ${responseData['message'] ?? 'Unknown error'}');
        return {
          'data': <dynamic>[],
          'pagination': {'hasNext': false, 'page': page, 'totalPages': 0},
        };
      }
      
    } catch (e) {
      print('Error fetching content: $e');
      return {
        'data': <dynamic>[],
        'pagination': {'hasNext': false, 'page': page, 'totalPages': 0},
      };
    }
  }
  
  // 获取城市列表
  static Future<List<dynamic>> getCities({bool? popular, String? search, int? limit}) async {
    try {
      String urlString = '$baseUrl/cities';
      List<String> params = [];
      
      if (popular != null) params.add('popular=$popular');
      if (search != null) params.add('search=$search');
      if (limit != null) params.add('limit=$limit');
      
      if (params.isNotEmpty) {
        urlString += '?' + params.join('&');
      }
      
      final url = Uri.parse(urlString);
      
      print('Sending getCities request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to load cities: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }
  
  // 搜索城市
  static Future<List<dynamic>> searchCities(String searchTerm, {int limit = 10}) async {
    try {
      final urlString = '$baseUrl/cities/search/$searchTerm?limit=$limit';
      final url = Uri.parse(urlString);
      
      print('Sending searchCities request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to search cities: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error searching cities: $e');
      return [];
    }
  }
  
  // 获取热门城市
  static Future<List<dynamic>> getPopularCities() async {
    try {
      final url = Uri.parse('$baseUrl/cities/popular/list');
      
      print('Sending getPopularCities request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to load popular cities: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error fetching popular cities: $e');
      return [];
    }
  }
  
  // 获取用户信息（需要token）
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      
      print('Sending getUserProfile request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'] as Map<String, dynamic>,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to load user profile',
        };
      }
      
    } catch (e) {
      print('Error fetching user profile: $e');
      return {
        'success': false,
        'message': 'Network connection failed',
        'error': e.toString(),
      };
    }
  }
  
  // 更新用户信息
  static Future<Map<String, dynamic>> updateUserProfile(String token, Map<String, dynamic> updateData) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      
      print('Sending updateUserProfile request to: $url');
      print('Request data: $updateData');
      
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Profile updated successfully',
          'data': responseData['data'] as Map<String, dynamic>,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update user profile',
        };
      }
      
    } catch (e) {
      print('Error updating user profile: $e');
      return {
        'success': false,
        'message': 'Network connection failed',
        'error': e.toString(),
      };
    }
  }

  // 综合搜索
  static Future<Map<String, dynamic>> search({
    String? query,
    String? type,
    String? city,
    int page = 1,
    int limit = 10,
    String sortBy = 'rating',
    String order = 'desc'
  }) async {
    try {
      List<String> params = [
        'page=$page',
        'limit=$limit',
        'sortBy=$sortBy',
        'order=$order'
      ];
      
      if (query != null && query.isNotEmpty) params.add('q=${Uri.encodeComponent(query)}');
      if (type != null && type != 'all') params.add('type=$type');
      if (city != null && city.isNotEmpty) params.add('city=${Uri.encodeComponent(city)}');
      
      final urlString = '$baseUrl/search?' + params.join('&');
      final url = Uri.parse(urlString);
      
      print('Sending search request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'] as List<dynamic>,
          'pagination': responseData['pagination'] as Map<String, dynamic>,
          'filters': responseData['filters'] as Map<String, dynamic>,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Search failed',
          'data': <dynamic>[],
          'pagination': {'hasNext': false, 'page': page, 'totalPages': 0},
        };
      }
      
    } catch (e) {
      print('Error searching: $e');
      return {
        'success': false,
        'message': 'Network connection failed',
        'error': e.toString(),
        'data': <dynamic>[],
        'pagination': {'hasNext': false, 'page': page, 'totalPages': 0},
      };
    }
  }

  // 获取搜索建议
  static Future<List<dynamic>> getSearchSuggestions(String query, {int limit = 5}) async {
    try {
      final urlString = '$baseUrl/search/suggestions?q=${Uri.encodeComponent(query)}&limit=$limit';
      final url = Uri.parse(urlString);
      
      print('Sending search suggestions request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to get search suggestions: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error getting search suggestions: $e');
      return [];
    }
  }

  // 获取热门搜索
  static Future<List<dynamic>> getHotSearches({int limit = 10}) async {
    try {
      final urlString = '$baseUrl/search/hot?limit=$limit';
      final url = Uri.parse(urlString);
      
      print('Sending hot searches request to: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData['data'] as List<dynamic>;
      } else {
        print('Failed to get hot searches: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
      
    } catch (e) {
      print('Error getting hot searches: $e');
      return [];
    }
  }
}