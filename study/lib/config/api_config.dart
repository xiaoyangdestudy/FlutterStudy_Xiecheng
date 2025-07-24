/// API配置类 - 管理不同环境的后端连接设置
class ApiConfig {
  // 环境类型枚举
  static const String development = 'development';
  static const String production = 'production';
  static const String staging = 'staging';
  
  // 当前环境（可以通过构建参数或环境变量切换）
  static const String currentEnvironment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: development,
  );
  
  // 不同环境的API配置
  static const Map<String, Map<String, dynamic>> _configs = {
    development: {
      'baseUrl': 'http://10.0.2.2:3002/api',  // Android模拟器localhost
      'timeout': 10000,  // 10秒超时
      'enableLogging': true,
      'retryAttempts': 3,
    },
    staging: {
      'baseUrl': 'https://staging-api.xiecheng.com/api',
      'timeout': 15000,  // 15秒超时
      'enableLogging': true,
      'retryAttempts': 2,
    },
    production: {
      'baseUrl': 'https://api.xiecheng.com/api',
      'timeout': 20000,  // 20秒超时
      'enableLogging': false,
      'retryAttempts': 1,
    },
  };
  
  /// 获取当前环境的基础URL
  static String get baseUrl {
    return _configs[currentEnvironment]!['baseUrl'] as String;
  }
  
  /// 获取请求超时时间（毫秒）
  static int get timeout {
    return _configs[currentEnvironment]!['timeout'] as int;
  }
  
  /// 是否启用日志记录
  static bool get enableLogging {
    return _configs[currentEnvironment]!['enableLogging'] as bool;
  }
  
  /// 获取重试次数
  static int get retryAttempts {
    return _configs[currentEnvironment]!['retryAttempts'] as int;
  }
  
  /// 获取当前环境配置
  static Map<String, dynamic> get currentConfig {
    return _configs[currentEnvironment]!;
  }
  
  /// 检查是否为开发环境
  static bool get isDevelopment => currentEnvironment == development;
  
  /// 检查是否为生产环境
  static bool get isProduction => currentEnvironment == production;
  
  /// 检查是否为测试环境
  static bool get isStaging => currentEnvironment == staging;
}