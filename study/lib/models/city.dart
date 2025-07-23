class City {
  final String id;
  final String name;
  final String code;

  const City({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static const List<City> defaultCities = [
    City(id: '1', name: '北京', code: 'BJ'),
    City(id: '2', name: '上海', code: 'SH'),
    City(id: '3', name: '广州', code: 'GZ'),
    City(id: '4', name: '深圳', code: 'SZ'),
    City(id: '5', name: '杭州', code: 'HZ'),
    City(id: '6', name: '成都', code: 'CD'),
    City(id: '7', name: '西安', code: 'XA'),
    City(id: '8', name: '南京', code: 'NJ'),
  ];
}