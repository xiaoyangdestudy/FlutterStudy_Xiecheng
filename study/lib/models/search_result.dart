/// 搜索结果数据模型
class SearchResult {
  final String code;        // 唯一标识码
  final String word;        // 显示名称
  final String type;        // 类型：hotel, attraction, food, etc.
  final String price;       // 价格信息
  final String zonename;    // 区域名称
  final String? star;       // 星级（可选）
  final String districtname; // 城市名称
  final String url;         // 详情页面链接
  final String? imageUrl;   // 图片链接（可选）
  final String? description; // 描述信息（可选）
  final double? rating;     // 评分（可选）

  const SearchResult({
    required this.code,
    required this.word,
    required this.type,
    required this.price,
    required this.zonename,
    this.star,
    required this.districtname,
    required this.url,
    this.imageUrl,
    this.description,
    this.rating,
  });

  /// 从JSON创建SearchResult对象
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      code: json['code'] as String,
      word: json['word'] as String,
      type: json['type'] as String,
      price: json['price'] as String,
      zonename: json['zonename'] as String,
      star: json['star'] as String?,
      districtname: json['districtname'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      rating: json['rating']?.toDouble(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'word': word,
      'type': type,
      'price': price,
      'zonename': zonename,
      'star': star,
      'districtname': districtname,
      'url': url,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
    };
  }

  /// 获取类型显示文本
  String get typeDisplayName {
    switch (type) {
      case 'hotel':
        return '酒店';
      case 'attraction':
        return '景点';
      case 'food':
        return '美食';
      case 'shopping':
        return '购物';
      case 'entertainment':
        return '娱乐';
      default:
        return '其他';
    }
  }

  /// 获取类型图标
  String get typeIcon {
    switch (type) {
      case 'hotel':
        return '🏨';
      case 'attraction':
        return '🎯';
      case 'food':
        return '🍴';
      case 'shopping':
        return '🛍️';
      case 'entertainment':
        return '🎪';
      default:
        return '📍';
    }
  }

  /// 获取价格显示文本
  String get priceDisplay {
    return price.isEmpty ? '价格面议' : price;
  }

  /// 获取完整地址
  String get fullAddress {
    return '$districtname $zonename';
  }

  @override
  String toString() {
    return 'SearchResult{code: $code, word: $word, type: $type, price: $price}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// 搜索结果类型枚举
enum SearchResultType {
  hotel('hotel', '酒店'),
  attraction('attraction', '景点'),
  food('food', '美食'),
  shopping('shopping', '购物'),
  entertainment('entertainment', '娱乐'),
  all('all', '全部');

  const SearchResultType(this.value, this.displayName);

  final String value;
  final String displayName;

  static SearchResultType fromString(String value) {
    return SearchResultType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SearchResultType.all,
    );
  }
}