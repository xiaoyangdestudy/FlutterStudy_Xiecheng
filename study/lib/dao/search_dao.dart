import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study/config/api_config.dart';
import 'package:study/models/search_model.dart';
import 'package:study/models/search_result.dart';

/// 搜索数据访问对象
/// 负责处理所有与搜索相关的API调用
class SearchDao {
  static String get _baseUrl => ApiConfig.baseUrl;

  /// 执行综合搜索
  /// 
  /// [params] 搜索参数
  /// 返回搜索响应结果
  static Future<SearchResponse> search(SearchParams params) async {
    try {
      final url = _buildSearchUrl(params);
      
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
        return SearchResponse.fromJson(responseData);
      } else {
        return SearchResponse(
          success: false,
          message: responseData['message'] ?? '搜索失败',
          results: [],
          pagination: const SearchPagination(
            page: 1,
            totalPages: 0,
            totalItems: 0,
            hasNext: false,
            hasPrevious: false,
          ),
        );
      }
    } catch (e) {
      print('Error during search: $e');
      return SearchResponse(
        success: false,
        message: '网络连接失败',
        results: [],
        pagination: const SearchPagination(
          page: 1,
          totalPages: 0,
          totalItems: 0,
          hasNext: false,
          hasPrevious: false,
        ),
      );
    }
  }

  /// 获取搜索建议
  /// 
  /// [query] 搜索关键词
  /// [limit] 返回数量限制，默认5个
  /// 返回搜索建议列表
  static Future<List<SearchSuggestion>> getSearchSuggestions(
    String query, {
    int limit = 5,
  }) async {
    try {
      final urlString = '$_baseUrl/search/suggestions?q=${Uri.encodeComponent(query)}&limit=$limit';
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
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => SearchSuggestion.fromJson(item)).toList();
      } else {
        print('Failed to get search suggestions: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      print('Error getting search suggestions: $e');
      return [];
    }
  }

  /// 获取热门搜索
  /// 
  /// [limit] 返回数量限制，默认10个
  /// 返回热门搜索列表
  static Future<List<HotSearchItem>> getHotSearches({int limit = 10}) async {
    try {
      final urlString = '$_baseUrl/search/hot?limit=$limit';
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
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => HotSearchItem.fromJson(item)).toList();
      } else {
        print('Failed to get hot searches: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      print('Error getting hot searches: $e');
      return [];
    }
  }

  /// 获取搜索历史（如果需要的话）
  /// 
  /// [userId] 用户ID
  /// [limit] 返回数量限制
  /// 返回搜索历史列表
  static Future<List<String>> getSearchHistory({
    String? userId,
    int limit = 10,
  }) async {
    try {
      String urlString = '$_baseUrl/search/history?limit=$limit';
      if (userId != null) {
        urlString += '&userId=$userId';
      }
      
      final url = Uri.parse(urlString);
      
      print('Sending search history request to: $url');
      
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
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => item['query'] as String).toList();
      } else {
        print('Failed to get search history: ${responseData['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      print('Error getting search history: $e');
      return [];
    }
  }

  /// 保存搜索历史
  /// 
  /// [query] 搜索关键词
  /// [userId] 用户ID（可选）
  /// 返回保存是否成功
  static Future<bool> saveSearchHistory(String query, {String? userId}) async {
    try {
      final url = Uri.parse('$_baseUrl/search/history');
      
      final requestData = {
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (userId != null) {
        requestData['userId'] = userId;
      }
      
      print('Sending save search history request to: $url');
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
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error saving search history: $e');
      return false;
    }
  }

  /// 清空搜索历史
  /// 
  /// [userId] 用户ID（可选）
  /// 返回清空是否成功
  static Future<bool> clearSearchHistory({String? userId}) async {
    try {
      String urlString = '$_baseUrl/search/history';
      if (userId != null) {
        urlString += '?userId=$userId';
      }
      
      final url = Uri.parse(urlString);
      
      print('Sending clear search history request to: $url');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing search history: $e');
      return false;
    }
  }

  /// 获取搜索筛选选项
  /// 
  /// 返回可用的筛选条件
  static Future<SearchFilters?> getSearchFilters() async {
    try {
      final url = Uri.parse('$_baseUrl/search/filters');
      
      print('Sending search filters request to: $url');
      
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
        return SearchFilters.fromJson(responseData['data'] ?? {});
      } else {
        print('Failed to get search filters: ${responseData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      print('Error getting search filters: $e');
      return null;
    }
  }

  /// 构建搜索URL
  /// 
  /// [params] 搜索参数
  /// 返回构建好的URL
  static Uri _buildSearchUrl(SearchParams params) {
    final List<String> queryParams = [
      'page=${params.page}',
      'limit=${params.limit}',
      'sortBy=${params.sortBy}',
      'order=${params.order}',
    ];
    
    if (params.query != null && params.query!.isNotEmpty) {
      queryParams.add('q=${Uri.encodeComponent(params.query!)}');
    }
    
    if (params.type != null && params.type != 'all') {
      queryParams.add('type=${params.type}');
    }
    
    if (params.city != null && params.city!.isNotEmpty) {
      queryParams.add('city=${Uri.encodeComponent(params.city!)}');
    }
    
    final urlString = '$_baseUrl/search?${queryParams.join('&')}';
    return Uri.parse(urlString);
  }

  /// 验证搜索参数
  /// 
  /// [params] 搜索参数
  /// 返回验证结果和错误信息
  static Map<String, dynamic> validateSearchParams(SearchParams params) {
    final errors = <String>[];
    
    // 验证查询关键词
    if (params.query != null && params.query!.trim().isEmpty) {
      errors.add('搜索关键词不能为空');
    }
    
    // 验证页码
    if (params.page < 1) {
      errors.add('页码必须大于0');
    }
    
    // 验证每页数量
    if (params.limit < 1 || params.limit > 100) {
      errors.add('每页数量必须在1-100之间');
    }
    
    // 验证排序字段
    final validSortFields = ['rating', 'price', 'name', 'distance', 'popularity'];
    if (!validSortFields.contains(params.sortBy)) {
      errors.add('无效的排序字段');
    }
    
    // 验证排序方向
    final validOrders = ['asc', 'desc'];
    if (!validOrders.contains(params.order)) {
      errors.add('无效的排序方向');
    }
    
    return {
      'isValid': errors.isEmpty,
      'errors': errors,
    };
  }

  /// 格式化搜索结果用于显示
  /// 
  /// [results] 搜索结果列表
  /// 返回格式化后的结果
  static List<Map<String, dynamic>> formatSearchResults(List<SearchResult> results) {
    return results.map((result) {
      return {
        'id': result.code,
        'title': result.word,
        'subtitle': result.fullAddress,
        'type': result.typeDisplayName,
        'typeIcon': result.typeIcon,
        'price': result.priceDisplay,
        'rating': result.rating,
        'star': result.star,
        'imageUrl': result.imageUrl,
        'url': result.url,
      };
    }).toList();
  }
}