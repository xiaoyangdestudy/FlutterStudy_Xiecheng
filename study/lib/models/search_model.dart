import 'search_result.dart';

/// 搜索请求参数模型
class SearchParams {
  final String? query;
  final String? type;
  final String? city;
  final int page;
  final int limit;
  final String sortBy;
  final String order;

  const SearchParams({
    this.query,
    this.type,
    this.city,
    this.page = 1,
    this.limit = 10,
    this.sortBy = 'rating',
    this.order = 'desc',
  });

  SearchParams copyWith({
    String? query,
    String? type,
    String? city,
    int? page,
    int? limit,
    String? sortBy,
    String? order,
  }) {
    return SearchParams(
      query: query ?? this.query,
      type: type ?? this.type,
      city: city ?? this.city,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'type': type,
      'city': city,
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'order': order,
    };
  }

  @override
  String toString() {
    return 'SearchParams{query: $query, type: $type, city: $city, page: $page}';
  }
}

/// 搜索响应模型
class SearchResponse {
  final bool success;
  final String? message;
  final List<SearchResult> results;
  final SearchPagination pagination;
  final SearchFilters? filters;

  const SearchResponse({
    required this.success,
    this.message,
    required this.results,
    required this.pagination,
    this.filters,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      success: json['success'] ?? false,
      message: json['message'] as String?,
      results: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SearchResult.fromJson(item))
          .toList(),
      pagination: SearchPagination.fromJson(json['pagination'] ?? {}),
      filters: json['filters'] != null 
          ? SearchFilters.fromJson(json['filters'])
          : null,
    );
  }

  SearchResponse copyWith({
    bool? success,
    String? message,
    List<SearchResult>? results,
    SearchPagination? pagination,
    SearchFilters? filters,
  }) {
    return SearchResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      results: results ?? this.results,
      pagination: pagination ?? this.pagination,
      filters: filters ?? this.filters,
    );
  }

  @override
  String toString() {
    return 'SearchResponse{success: $success, results: ${results.length}}';
  }
}

/// 搜索分页信息模型
class SearchPagination {
  final int page;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;

  const SearchPagination({
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory SearchPagination.fromJson(Map<String, dynamic> json) {
    return SearchPagination(
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }

  @override
  String toString() {
    return 'SearchPagination{page: $page, totalPages: $totalPages, hasNext: $hasNext}';
  }
}

/// 搜索筛选条件模型
class SearchFilters {
  final List<String> availableTypes;
  final List<String> availableCities;
  final List<String> availableSortOptions;

  const SearchFilters({
    required this.availableTypes,
    required this.availableCities,
    required this.availableSortOptions,
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    return SearchFilters(
      availableTypes: List<String>.from(json['types'] ?? []),
      availableCities: List<String>.from(json['cities'] ?? []),
      availableSortOptions: List<String>.from(json['sortOptions'] ?? []),
    );
  }

  @override
  String toString() {
    return 'SearchFilters{types: ${availableTypes.length}, cities: ${availableCities.length}}';
  }
}

/// 热门搜索项模型
class HotSearchItem {
  final String text;
  final int count;
  final String? category;

  const HotSearchItem({
    required this.text,
    required this.count,
    this.category,
  });

  factory HotSearchItem.fromJson(Map<String, dynamic> json) {
    return HotSearchItem(
      text: json['text'] as String,
      count: json['count'] ?? 0,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'count': count,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'HotSearchItem{text: $text, count: $count}';
  }
}

/// 搜索建议项模型
class SearchSuggestion {
  final String text;
  final String? type;
  final String? description;

  const SearchSuggestion({
    required this.text,
    this.type,
    this.description,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      text: json['text'] as String,
      type: json['type'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'SearchSuggestion{text: $text, type: $type}';
  }
}

/// 搜索状态枚举
enum SearchState {
  initial,    // 初始状态
  loading,    // 搜索中
  loaded,     // 搜索完成
  loadingMore,// 加载更多中
  error,      // 错误状态
  empty,      // 无结果
}

/// 搜索排序选项枚举
enum SearchSortOption {
  rating('rating', '评分'),
  price('price', '价格'),
  name('name', '名称'),
  distance('distance', '距离'),
  popularity('popularity', '热度');

  const SearchSortOption(this.value, this.displayName);

  final String value;
  final String displayName;

  static SearchSortOption fromString(String value) {
    return SearchSortOption.values.firstWhere(
      (option) => option.value == value,
      orElse: () => SearchSortOption.rating,
    );
  }
}

/// 搜索排序方向枚举
enum SearchSortOrder {
  asc('asc', '升序'),
  desc('desc', '降序');

  const SearchSortOrder(this.value, this.displayName);

  final String value;
  final String displayName;

  static SearchSortOrder fromString(String value) {
    return SearchSortOrder.values.firstWhere(
      (order) => order.value == value,
      orElse: () => SearchSortOrder.desc,
    );
  }
}