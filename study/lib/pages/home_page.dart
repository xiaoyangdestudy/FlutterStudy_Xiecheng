import 'package:flutter/material.dart';
import 'package:study/models/content_item.dart';
import 'package:study/models/service_category.dart';
import 'package:study/models/city.dart';
import 'package:study/widgets/home_header.dart';
import 'package:study/widgets/home_navigation_bar.dart';
import 'package:study/widgets/content_card.dart';
import 'package:study/widgets/additional_services.dart';
import 'package:study/widgets/promotional_services.dart';
import 'package:study/widgets/search_bar_widget.dart';
import 'package:study/utils/view_tuil.dart';
import 'package:study/dao/api_service.dart';
import 'package:study/pages/search_results_page.dart';

/// 首页组件 - 携程App主界面
/// 功能包括：轮播图、服务导航、促销活动、内容推荐列表
/// 支持下拉刷新、上滑加载更多、AppBar透明度渐变等交互效果
class HomePage extends StatefulWidget {
  final String userName;
  final String userAccount;

  const HomePage({
    super.key,
    required this.userName,
    required this.userAccount,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ========== 控制器和状态变量 ==========
  late ScrollController _scrollController;
  double _appBarOpacity = 0.0; // AppBar透明度，随滚动变化
  List<ContentItem> _contentItems = [];
  bool _isLoading = false; // 是否正在加载更多数据
  bool _hasMoreData = true; // 是否还有更多数据可加载
  City _selectedCity = const City(id: '1', name: '北京', code: 'BJ'); // 当前选中的城市
  
  // API数据
  List<dynamic> _banners = [];
  List<dynamic> _services = [];
  List<dynamic> _promotions = [];
  List<dynamic> _cities = [];
  int _currentPage = 1;
  bool _isLoadingData = false;

  // ========== 生命周期方法 ==========
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ========== 数据初始化和管理 ==========
  /// 初始化页面数据
  void _initializeData() async {
    setState(() {
      _isLoadingData = true;
    });
    
    try {
      // 并行加载多个接口数据
      await Future.wait([
        _loadBanners(),
        _loadServices(), 
        _loadPromotions(),
        _loadCities(),
        _loadContent(),
      ]);
    } catch (e) {
      print('Error loading initial data: $e');
      // 如果API加载失败，使用默认数据
      _loadDefaultData();
    } finally {
      setState(() {
        _isLoadingData = false;
      });
    }
  }
  
  /// 加载轮播图数据
  Future<void> _loadBanners() async {
    try {
      final banners = await ApiService.getBanners();
      setState(() {
        _banners = banners;
      });
    } catch (e) {
      print('Error loading banners: $e');
    }
  }
  
  /// 加载服务分类数据
  Future<void> _loadServices() async {
    try {
      final services = await ApiService.getServices();
      setState(() {
        _services = services;
      });
    } catch (e) {
      print('Error loading services: $e');
    }
  }
  
  /// 加载促销活动数据
  Future<void> _loadPromotions() async {
    try {
      final promotions = await ApiService.getPromotions(limit: 6);
      setState(() {
        _promotions = promotions;
      });
    } catch (e) {
      print('Error loading promotions: $e');
    }
  }
  
  /// 加载城市数据
  Future<void> _loadCities() async {
    try {
      final cities = await ApiService.getPopularCities();
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      print('Error loading cities: $e');
    }
  }
  
  /// 加载推荐内容数据
  Future<void> _loadContent({bool loadMore = false}) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await ApiService.getContent(
        page: loadMore ? _currentPage + 1 : 1,
        limit: 10,
      );
      
      final newItems = (result['data'] as List).map((item) => ContentItem(
        id: int.parse(item['id']),
        title: item['title'],
        description: item['description'] ?? item['subtitle'],
      )).toList();
      
      setState(() {
        if (loadMore) {
          _contentItems.addAll(newItems);
          _currentPage++;
        } else {
          _contentItems = newItems;
          _currentPage = 1;
        }
        
        final pagination = result['pagination'] as Map<String, dynamic>;
        _hasMoreData = pagination['hasNext'] ?? false;
      });
    } catch (e) {
      print('Error loading content: $e');
      if (!loadMore) {
        _loadDefaultData();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  /// 加载默认数据（API失败时的备用方案）
  void _loadDefaultData() {
    _contentItems = List.generate(20, (index) => ContentItem(
      id: index + 1,
      title: '内容标题 ${index + 1}',
      description: '这里是内容描述，用于展示滚动效果和AppBar透明度渐变...',
    ));
  }

  // ========== 静态数据构建方法 ==========
  /// 构建促销服务数据
  List<PromotionalService> _buildPromotionalServices() {
    return [
      PromotionalService(
        title: '携程超级会员',
        subtitle: '享酒店无理由取消',
        buttonText: '即刻开启',
        backgroundColor: const Color(0xFFF0F8FF),
        buttonColor: const Color(0xFFFF6B6B),
        icon: Icons.hotel,
        onTap: () => print('点击了携程超级会员'),
      ),
      PromotionalService(
        title: '爆款酒店',
        subtitle: '折上立减25%',
        buttonText: '限时抢购',
        backgroundColor: const Color(0xFFFFF8DC),
        buttonColor: const Color(0xFFFF8C00),
        icon: Icons.local_hotel,
        onTap: () => print('点击了爆款酒店'),
      ),
      PromotionalService(
        title: '球迷卡限时秒',
        subtitle: '精选NBA',
        buttonText: '精选好货',
        backgroundColor: const Color(0xFFF5F5F5),
        buttonColor: const Color(0xFF4169E1),
        icon: Icons.sports_basketball,
        onTap: () => print('点击了球迷卡限时秒'),
      ),
      PromotionalService(
        title: '领券中心',
        subtitle: '精选好货',
        buttonText: '精选好货',
        backgroundColor: const Color(0xFFFFF0F5),
        buttonColor: const Color(0xFFFF1493),
        icon: Icons.card_giftcard,
        onTap: () => print('点击了领券中心'),
      ),
      PromotionalService(
        title: '会员福利',
        subtitle: '免费领取',
        buttonText: '免费领取',
        backgroundColor: const Color(0xFFFFF8DC),
        buttonColor: const Color(0xFFFF4500),
        icon: Icons.redeem,
        onTap: () => print('点击了会员福利'),
      ),
      PromotionalService(
        title: '携程优品商城',
        subtitle: '超值特价',
        buttonText: '超值特价',
        backgroundColor: const Color(0xFFF0FFF0),
        buttonColor: const Color(0xFF32CD32),
        icon: Icons.shopping_cart,
        onTap: () => print('点击了携程优品商城'),
      ),
    ];
  }

  /// 构建附加服务数据
  List<AdditionalServiceItem> _buildAdditionalServices() {
    return [
      AdditionalServiceItem(
        icon: Icons.wifi,
        title: 'WiFi电话卡',
        onTap: () => print('点击了WiFi电话卡'),
      ),
      AdditionalServiceItem(
        icon: Icons.security,
        title: '保险·签证',
        onTap: () => print('点击了保险签证'),
      ),
      AdditionalServiceItem(
        icon: Icons.currency_exchange,
        title: '外币兑换',
        onTap: () => print('点击了外币兑换'),
      ),
      AdditionalServiceItem(
        icon: Icons.shopping_bag,
        title: '购物',
        onTap: () => print('点击了购物'),
      ),
      AdditionalServiceItem(
        icon: Icons.explore,
        title: '当地向导',
        onTap: () => print('点击了当地向导'),
      ),
      AdditionalServiceItem(
        icon: Icons.directions_walk,
        title: '自由行',
        onTap: () => print('点击了自由行'),
      ),
      AdditionalServiceItem(
        icon: Icons.sports_esports,
        title: '境外玩乐',
        onTap: () => print('点击了境外玩乐'),
      ),
      AdditionalServiceItem(
        icon: Icons.card_giftcard,
        title: '礼品卡',
        onTap: () => print('点击了礼品卡'),
      ),
      AdditionalServiceItem(
        icon: Icons.credit_card,
        title: '信用卡',
        onTap: () => print('点击了信用卡'),
      ),
      AdditionalServiceItem(
        icon: Icons.more_horiz,
        title: '更多',
        onTap: () => print('点击了更多'),
      ),
    ];
  }

  /// 构建服务分类行数据
  List<ServiceRow> _buildServiceRows() {
    return [
      ServiceRow(
        gradientColors: [
          const Color(0xFFFF6B6B),
          const Color(0xFFFF8E53),
        ],
        services: [
          ServiceCategory(
            title: '酒店',
            icon: Icons.hotel,
            onTap: () => print('点击了酒店'),
          ),
          ServiceCategory(
            title: '海外酒店',
            onTap: () => print('点击了海外酒店'),
          ),
          ServiceCategory(
            title: '贷款',
            onTap: () => print('点击了贷款'),
          ),
          ServiceCategory(
            title: '特价酒店',
            onTap: () => print('点击了特价酒店'),
          ),
          ServiceCategory(
            title: '民宿 客栈',
            onTap: () => print('点击了民宿客栈'),
          ),
        ],
      ),
      ServiceRow(
        gradientColors: [
          const Color(0xFF4E9AF9),
          const Color(0xFF5BB7FF),
        ],
        services: [
          ServiceCategory(
            title: '机票',
            icon: Icons.flight,
            onTap: () => print('点击了机票'),
          ),
          ServiceCategory(
            title: '火车票',
            onTap: () => print('点击了火车票'),
          ),
          ServiceCategory(
            title: '汽车票·船票',
            onTap: () => print('点击了汽车票船票'),
          ),
          ServiceCategory(
            title: '特价机票',
            onTap: () => print('点击了特价机票'),
          ),
          ServiceCategory(
            title: '专车·租车',
            onTap: () => print('点击了专车租车'),
          ),
        ],
      ),
      ServiceRow(
        gradientColors: [
          const Color(0xFF4CAF50),
          const Color(0xFF66BB6A),
        ],
        services: [
          ServiceCategory(
            title: '旅游',
            icon: Icons.landscape,
            onTap: () => print('点击了旅游'),
          ),
          ServiceCategory(
            title: '门票',
            onTap: () => print('点击了门票'),
          ),
          ServiceCategory(
            title: '私家团',
            onTap: () => print('点击了私家团'),
          ),
          ServiceCategory(
            title: '目的地攻略',
            onTap: () => print('点击了目的地攻略'),
          ),
          ServiceCategory(
            title: '定制旅行',
            onTap: () => print('点击了定制旅行'),
          ),
        ],
      ),
    ];
  }

  /// 构建导航项数据
  List<NavigationItem> _buildNavigationItems() {
    return [
      NavigationItem(
        icon: Icons.location_on,
        label: '攻略·景点',
        color: Colors.blue,
        onTap: () => print('点击了攻略·景点'),
      ),
      NavigationItem(
        icon: Icons.landscape,
        label: '周边游',
        color: Colors.green,
        onTap: () => print('点击了周边游'),
      ),
      NavigationItem(
        icon: Icons.restaurant,
        label: '美食林',
        color: Colors.deepOrange,
        onTap: () => print('点击了美食林'),
      ),
      NavigationItem(
        icon: Icons.wb_sunny,
        label: '一日游',
        color: Colors.orange,
        onTap: () => print('点击了一日游'),
      ),
      NavigationItem(
        icon: Icons.person,
        label: '当地攻略',
        color: Colors.amber,
        onTap: () => print('点击了当地攻略'),
      ),
    ];
  }

  /// 构建轮播图数据
  List<String> _buildBannerImages() {
    return [
      'images/bg.png',
      'images/bg.png', 
      'images/bg.png',
      'images/bg.png',
      'images/bg.png',  
    ];
  }

  /// 从服务器数据构建服务分类行
  List<ServiceRow> _buildServiceRowsFromData(List<dynamic> servicesData) {
    if (servicesData.isEmpty) return _buildServiceRows();
    
    List<ServiceRow> rows = [];
    
    // 遍历每个服务分类
    for (int i = 0; i < servicesData.length; i++) {
      final serviceGroup = servicesData[i];
      List<ServiceCategory> services = [];
      
      // 添加主服务（第一个位置，带图标）
      services.add(ServiceCategory(
        title: serviceGroup['title'] ?? '服务',
        icon: _getIconFromString(serviceGroup['icon']),
        onTap: () => print('点击了${serviceGroup['title']}'),
      ));
      
      // 添加子服务到后续位置
      if (serviceGroup['services'] != null) {
        final subServices = serviceGroup['services'] as List;
        for (int j = 0; j < 4 && j < subServices.length; j++) {
          services.add(ServiceCategory(
            title: subServices[j]['name'] ?? '子服务',
            onTap: () => print('点击了${subServices[j]['name']}'),
          ));
        }
      }
      
      // 如果服务数量不足5个，用默认服务填充
      while (services.length < 5) {
        services.add(ServiceCategory(
          title: '更多服务',
          onTap: () => print('点击了更多服务'),
        ));
      }
      
      rows.add(ServiceRow(
        gradientColors: _getGradientColors(i),
        services: services,
      ));
    }
    
    return rows.isNotEmpty ? rows : _buildServiceRows();
  }

  /// 从服务器数据构建促销服务
  List<PromotionalService> _buildPromotionalServicesFromData(List<dynamic> promotionsData) {
    return promotionsData.map((promo) => PromotionalService(
      title: promo['title'] ?? '促销服务',
      subtitle: promo['subtitle'] ?? promo['description'] ?? '优惠活动',
      buttonText: promo['buttonText'] ?? '立即查看',
      backgroundColor: _getColorFromString(promo['backgroundColor']) ?? const Color(0xFFF0F8FF),
      buttonColor: _getColorFromString(promo['buttonColor']) ?? const Color(0xFFFF6B6B),
      icon: _getIconFromString(promo['icon']) ?? Icons.local_offer,
      onTap: () => print('点击了${promo['title']}'),
    )).toList();
  }

  /// 根据字符串获取图标
  IconData? _getIconFromString(String? iconName) {
    if (iconName == null) return Icons.star;
    
    // 如果是emoji，返回默认图标（因为Flutter Icon不直接支持emoji）
    if (iconName.contains('🏨') || iconName.toLowerCase().contains('hotel')) return Icons.hotel;
    if (iconName.contains('✈️') || iconName.toLowerCase().contains('flight')) return Icons.flight;
    if (iconName.contains('🧳') || iconName.toLowerCase().contains('travel')) return Icons.luggage;
    
    // 传统的图标名称映射
    switch (iconName.toLowerCase()) {
      case 'hotel': return Icons.hotel;
      case 'flight': return Icons.flight;
      case 'landscape': return Icons.landscape;
      case 'travel': case 'luggage': return Icons.luggage;
      case 'local_hotel': return Icons.local_hotel;
      case 'sports_basketball': return Icons.sports_basketball;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'redeem': return Icons.redeem;
      case 'shopping_cart': return Icons.shopping_cart;
      default: return Icons.star;
    }
  }

  /// 根据字符串获取颜色
  Color? _getColorFromString(String? colorString) {
    if (colorString == null) return null;
    
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  /// 根据行索引获取渐变色
  List<Color> _getGradientColors(int rowIndex) {
    switch (rowIndex % 3) {
      case 0:
        return [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];
      case 1:
        return [const Color(0xFF4E9AF9), const Color(0xFF5BB7FF)];
      default:
        return [const Color(0xFF4CAF50), const Color(0xFF66BB6A)];
    }
  }

  // ========== 滚动和交互逻辑 ==========
  /// 滚动监听器 - 处理AppBar透明度变化和加载更多逻辑
  void _onScroll() {
    final offset = _scrollController.offset;
    final maxOffset = 150.0;
    
    // 更新AppBar透明度
    setState(() {
      _appBarOpacity = (offset / maxOffset).clamp(0.0, 1.0);
    });

    // 检查是否需要加载更多数据
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  /// 下拉刷新 - 重新加载首页数据
  Future<void> _onRefresh() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 2));
    
    // 生成新的数据
    final newData = List.generate(20, (index) => ContentItem(
      id: index + 1,
      title: '刷新内容 ${index + 1}',
      description: '这是刷新后的数据内容...',
    ));
    
    setState(() {
      _contentItems = newData;
      _hasMoreData = true; // 重置加载更多状态
    });
  }

  /// 加载更多数据 - 上滑时自动触发
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;
    
    // 使用统一的内容加载方法
    await _loadContent(loadMore: true);
  }

  // ========== 事件回调方法 ==========
  /// 城市选择回调
  void _onCityChanged(City city) {
    setState(() {
      _selectedCity = city;
    });
    print('选择了城市: ${city.name}');
    // TODO: 实现城市切换逻辑
  }

  /// 搜索内容变化回调
  void _onSearchChanged(String searchText) {
    print('搜索内容: $searchText');
    // TODO: 实现搜索逻辑
  }

  /// 搜索框点击回调
  void _onSearchTap() {
    print('点击了搜索框');
    // 跳转到搜索结果页面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          selectedCity: _selectedCity,
        ),
      ),
    );
  }


  // ========== UI构建方法 ==========
  /// 构建主界面
  /// 包含透明AppBar和可滚动的主体内容
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 让内容延伸到AppBar后面
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// 构建自定义AppBar
  /// 支持滚动时透明度渐变效果
  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        decoration: BoxDecoration(
          // 渐变背景，透明度根据滚动位置变化
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withValues(alpha: 0.2 + (_appBarOpacity * 0.8)),
              Colors.green.withValues(alpha: 0.1 + (_appBarOpacity * 0.6)),
            ],
          ),
          // 白色背景，透明度平滑过渡
          color: Colors.white.withValues(alpha: _appBarOpacity * 0.95),
        ),
        child: SafeArea(
          child: Column(
            children: [
              buildSizedBox(height: 8),
              SearchBarWidget(
                selectedCity: _selectedCity,
                backgroundOpacity: _appBarOpacity,
                onCityChanged: _onCityChanged,
                onSearchChanged: _onSearchChanged,
                onSearchTap: _onSearchTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建主体内容
  /// 包含下拉刷新和自定义滚动视图
  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _onRefresh, // 下拉刷新回调
      child: CustomScrollView(
        controller: _scrollController, // 滚动控制器，用于监听滚动事件
        slivers: _buildSlivers(),
      ),
    );
  }

  /// 构建所有滚动区域组件
  /// 返回有序的sliver组件列表
  List<Widget> _buildSlivers() {
    return [
      _buildHomeHeaderSliver(),            // 顶部轮播图和服务导航
      _buildPromotionalServicesSliver(),   // 促销服务区域
      _buildRecommendedContentTitleSliver(), // 推荐内容标题
      _buildContentListSliver(),           // 动态内容列表
    ];
  }

  // ========== Sliver组件构建方法 ==========
  /// 构建首页头部区域
  /// 包含轮播图、导航栏、服务网格和附加服务
  Widget _buildHomeHeaderSliver() {
    return SliverToBoxAdapter(
      child: HomeHeader(
        bannerImages: _banners.isNotEmpty 
          ? _banners.map((banner) => banner['imageUrl'] as String? ?? 'images/bg.png').toList()
          : _buildBannerImages(),
        navigationItems: _buildNavigationItems(),
        serviceRows: _services.isNotEmpty 
          ? _buildServiceRowsFromData(_services)
          : _buildServiceRows(),
        additionalServices: _buildAdditionalServices(),
      ),
    );
  }

  /// 构建促销服务区域
  /// 展示各种优惠活动和会员服务
  Widget _buildPromotionalServicesSliver() {
    return SliverToBoxAdapter(
      child: PromotionalServices(
        services: _promotions.isNotEmpty 
          ? _buildPromotionalServicesFromData(_promotions)
          : _buildPromotionalServices(),
      ),
    );
  }

  /// 构建推荐内容标题区域
  /// 显示"推荐内容"文字标题
  Widget _buildRecommendedContentTitleSliver() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          buildSizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '推荐内容',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          buildSizedBox(height: 8),
        ],
      ),
    );
  }

  /// 构建内容列表区域
  /// 支持无限滚动加载更多数据
  Widget _buildContentListSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        _buildContentListItem,
        childCount: _contentItems.length + 1, // +1 用于显示加载状态
      ),
    );
  }

  /// 构建内容列表项
  /// 处理普通内容、加载状态和无更多数据状态
  Widget _buildContentListItem(BuildContext context, int index) {
    // 显示普通内容项
    if (index < _contentItems.length) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ContentCard(item: _contentItems[index]),
          ),
          buildSizedBox(height: 8),
        ],
      );
    } 
    // 显示加载中指示器
    else if (_isLoading) {
      return Column(
        children: [
          buildSizedBox(height: 16),
          const Center(
            child: CircularProgressIndicator(),
          ),
          buildSizedBox(height: 16),
        ],
      );
    } 
    // 显示无更多数据提示
    else if (!_hasMoreData) {
      return Column(
        children: [
          buildSizedBox(height: 16),
          Center(
            child: Text(
              '没有更多数据了',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          buildSizedBox(height: 16),
        ],
      );
    }
    // 默认返回空组件
    return const SizedBox.shrink();
  }
}