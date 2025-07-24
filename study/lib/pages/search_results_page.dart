import 'package:flutter/material.dart';
import 'package:study/dao/search_dao.dart';
import 'package:study/models/search_model.dart';
import 'package:study/models/search_result.dart';
import 'package:study/models/city.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResultsPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialType;
  final City? selectedCity;

  const SearchResultsPage({
    super.key,
    this.initialQuery,
    this.initialType,
    this.selectedCity,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // 使用新的模型类型
  SearchResponse? _searchResponse;
  List<HotSearchItem> _hotSearches = [];
  SearchState _searchState = SearchState.initial;
  SearchParams _searchParams = const SearchParams();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    
    // 初始化搜索参数
    _searchParams = SearchParams(
      query: widget.initialQuery,
      type: widget.initialType ?? 'all',
      city: widget.selectedCity?.name,
    );
    
    _scrollController.addListener(_onScroll);
    
    if (_searchParams.query?.isNotEmpty == true) {
      _performSearch();
    } else {
      _loadHotSearches();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _performSearch({bool isNewSearch = true}) async {
    if (isNewSearch) {
      setState(() {
        _searchState = SearchState.loading;
        _searchParams = _searchParams.copyWith(page: 1);
      });
    }

    try {
      final response = await SearchDao.search(_searchParams);

      setState(() {
        if (isNewSearch) {
          _searchResponse = response;
        } else {
          // 加载更多时合并结果
          if (_searchResponse != null && response.success) {
            final existingResults = _searchResponse!.results;
            final newResults = response.results;
            _searchResponse = response.copyWith(
              results: [...existingResults, ...newResults],
            );
          }
        }
        
        _searchState = response.success 
            ? (response.results.isEmpty ? SearchState.empty : SearchState.loaded)
            : SearchState.error;
      });
    } catch (e) {
      setState(() {
        _searchState = SearchState.error;
      });
      _showError('网络连接失败');
    }
  }

  Future<void> _loadMore() async {
    if (_searchState == SearchState.loadingMore || 
        _searchResponse?.pagination.hasNext != true || 
        _searchParams.query?.isEmpty != false) {
      return;
    }

    setState(() {
      _searchState = SearchState.loadingMore;
      _searchParams = _searchParams.copyWith(
        page: _searchParams.page + 1,
      );
    });

    await _performSearch(isNewSearch: false);
  }

  Future<void> _loadHotSearches() async {
    try {
      final hotSearches = await SearchDao.getHotSearches();
      setState(() {
        _hotSearches = hotSearches;
      });
    } catch (e) {
      // Error loading hot searches
      debugPrint('Failed to load hot searches: $e');
    }
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _searchParams = _searchParams.copyWith(query: query.trim());
    });
    if (_searchParams.query?.isNotEmpty == true) {
      _performSearch();
    }
  }

  void _onTypeFilterChanged(String type) {
    setState(() {
      _searchParams = _searchParams.copyWith(type: type);
    });
    if (_searchParams.query?.isNotEmpty == true) {
      _performSearch();
    }
  }

  void _onSortChanged(String sortBy, String order) {
    setState(() {
      _searchParams = _searchParams.copyWith(sortBy: sortBy, order: order);
    });
    if (_searchParams.query?.isNotEmpty == true) {
      _performSearch();
    }
  }

  void _showError(String message) {
    setState(() {
      _searchState = SearchState.error;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _searchParams.query?.isEmpty != false ? _buildHotSearches() : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _onSearchSubmitted,
          decoration: InputDecoration(
            hintText: '搜索酒店、景点、美食...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchParams = _searchParams.copyWith(query: '');
                        _searchResponse = null;
                      });
                      _loadHotSearches();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _onSearchSubmitted(_searchController.text),
          child: Text(
            '搜索',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    if (_searchParams.query?.isEmpty != false) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // 类型筛选
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('全部', 'all'),
                _buildFilterChip('酒店', 'hotel'),
                _buildFilterChip('景点', 'attraction'),
                _buildFilterChip('美食', 'food'),
                _buildFilterChip('购物', 'shopping'),
                _buildFilterChip('娱乐', 'entertainment'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 排序选项
          Row(
            children: [
              _buildSortButton('评分', 'rating'),
              const SizedBox(width: 12),
              _buildSortButton('价格', 'price'),
              const SizedBox(width: 12),
              _buildSortButton('名称', 'name'),
              const Spacer(),
              Text(
                '共找到 ${_searchResponse?.results.length ?? 0} 个结果',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _searchParams.type == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _onTypeFilterChanged(value),
        backgroundColor: Colors.grey[100],
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSortButton(String label, String sortBy) {
    final isSelected = _searchParams.sortBy == sortBy;
    return GestureDetector(
      onTap: () {
        final newOrder = isSelected && _searchParams.order == 'desc' ? 'asc' : 'desc';
        _onSortChanged(sortBy, newOrder);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                _searchParams.order == 'desc' ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHotSearches() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热门搜索',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _hotSearches.map((hotSearch) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = hotSearch.text;
                  _onSearchSubmitted(hotSearch.text);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    hotSearch.text,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchState == SearchState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchState == SearchState.empty || _searchResponse?.results.isEmpty == true) {
      return _buildEmptyState();
    }

    if (_searchState == SearchState.error) {
      return _buildErrorState();
    }

    final results = _searchResponse?.results ?? [];
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: results.length + (_searchState == SearchState.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildSearchResultCard(results[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '没有找到相关结果',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '尝试更换关键词或筛选条件',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '搜索出错了',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _searchResponse?.message ?? '请检查网络连接后重试',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _performSearch(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(SearchResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openUrl(result.url),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: result.imageUrl != null
                      ? Image.network(
                          result.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              _buildPlaceholderImage(result.typeIcon),
                        )
                      : _buildPlaceholderImage(result.typeIcon),
                ),
              ),
              const SizedBox(width: 12),
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题和类型
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            result.word,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            result.typeDisplayName,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 地址
                    Text(
                      result.fullAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (result.star != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        result.star!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // 价格和评分
                    Row(
                      children: [
                        Text(
                          result.priceDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (result.rating != null) ...[
                          Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            result.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(String emoji) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('无法打开链接');
      }
    } catch (e) {
      _showError('打开链接失败');
    }
  }
}