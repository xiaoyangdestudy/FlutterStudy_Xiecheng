import 'package:flutter/material.dart';
import 'package:study/widgets/carousel_banner.dart';
import 'package:study/widgets/refreshable_list_view.dart';

// 内容数据模型
class ContentItem {
  final int id;
  final String title;
  final String description;

  ContentItem({
    required this.id,
    required this.title,
    required this.description,
  });
}

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
  late ScrollController _scrollController;
  double _appBarOpacity = 0.0;
  List<ContentItem> _contentItems = [];

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

  void _initializeData() {
    // 初始化20条数据
    _contentItems = List.generate(20, (index) => ContentItem(
      id: index + 1,
      title: '内容标题 ${index + 1}',
      description: '这里是内容描述，用于展示滚动效果和AppBar透明度渐变...',
    ));
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxOffset = 150.0;
    
    setState(() {
      _appBarOpacity = (offset / maxOffset).clamp(0.0, 1.0);
    });
  }

  /// 下拉刷新
  Future<List<ContentItem>> _onRefresh() async {
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 2));
    
    // 生成新的数据
    final newData = List.generate(20, (index) => ContentItem(
      id: index + 1,
      title: '刷新内容 ${index + 1}',
      description: '这是刷新后的数据内容...',
    ));
    
    setState(() {
      _contentItems = newData;
    });
    
    return newData;
  }

  /// 上拉加载更多
  Future<List<ContentItem>> _onLoadMore(int page) async {
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 1));
    
    // 生成更多数据
    final startIndex = _contentItems.length;
    final newData = List.generate(10, (index) => ContentItem(
      id: startIndex + index + 1,
      title: '加载更多 ${startIndex + index + 1}',
      description: '这是加载更多的数据内容...',
    ));
    
    setState(() {
      _contentItems.addAll(newData);
    });
    
    return newData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blue.withOpacity(_appBarOpacity),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),        
        ),
      ),
      body: RefreshableListView<ContentItem>(
        items: _contentItems,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        header: _buildHeader(),
        itemBuilder: (context, item, index) {
          if (index == 0) {
            // 第一个项目前显示推荐内容标题
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '推荐内容',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildContentCard(item),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildContentCard(item),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 50),
        _buildBannerCarousel(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContentCard(ContentItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image,
              color: Colors.blue,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final List<String> bannerImages = [
      'images/bg.png',
      'images/bg.png', 
      'images/bg.png',
      'images/bg.png',
      'images/bg.png',  
    ];

    return CarouselBanner(
      images: bannerImages,
      height: 200,
      onImageTap: (imagePath) {
        print('Tapped on image: $imagePath');
      },
      onPageChanged: (index) {
        print('Current page: $index');
      },
    );
  }
}