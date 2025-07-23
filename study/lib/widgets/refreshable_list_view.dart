import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 可复用的刷新加载列表组件
class RefreshableListView<T> extends StatefulWidget {
  /// 数据列表
  final List<T> items;
  
  /// 列表项构建器
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  
  /// 下拉刷新回调
  final Future<List<T>> Function() onRefresh;
  
  /// 上拉加载更多回调
  final Future<List<T>> Function(int page) onLoadMore;
  
  /// 固定头部组件（如轮播图）
  final Widget? header;
  
  /// 列表为空时显示的组件
  final Widget? emptyWidget;
  
  /// 是否启用下拉刷新
  final bool enablePullDown;
  
  /// 是否启用上拉加载
  final bool enablePullUp;
  
  /// 滚动控制器（用于外部控制）
  final ScrollController? scrollController;
  
  /// 每页加载数量
  final int pageSize;

  const RefreshableListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.header,
    this.emptyWidget,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.scrollController,
    this.pageSize = 20,
  });

  @override
  State<RefreshableListView<T>> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> {
  late RefreshController _refreshController;
  int _currentPage = 1;
  bool _hasMoreData = true;
  
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    try {
      final newData = await widget.onRefresh();
      _currentPage = 1;
      _hasMoreData = newData.length >= widget.pageSize;
      
      if (mounted) {
        _refreshController.refreshCompleted();
      }
    } catch (e) {
      if (mounted) {
        _refreshController.refreshFailed();
      }
      _showErrorSnackBar('刷新失败: ${e.toString()}');
    }
  }

  /// 上拉加载更多
  Future<void> _onLoadMore() async {
    if (!_hasMoreData) {
      _refreshController.loadNoData();
      return;
    }
    
    try {
      final newData = await widget.onLoadMore(_currentPage + 1);
      
      if (newData.isEmpty || newData.length < widget.pageSize) {
        _hasMoreData = false;
      }
      
      _currentPage++;
      
      if (mounted) {
        if (_hasMoreData) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      }
    } catch (e) {
      if (mounted) {
        _refreshController.loadFailed();
      }
      _showErrorSnackBar('加载失败: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      onRefresh: _onRefresh,
      onLoading: _onLoadMore,
      header: const WaterDropHeader(
        complete: Text('刷新完成'),
        failed: Text('刷新失败'),
        refresh: Text('正在刷新...'),
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          switch (mode) {
            case LoadStatus.idle:
              body = const Text('上拉加载更多');
              break;
            case LoadStatus.loading:
              body = const CircularProgressIndicator(strokeWidth: 2);
              break;
            case LoadStatus.failed:
              body = const Text('加载失败！点击重试');
              break;
            case LoadStatus.canLoading:
              body = const Text('释放加载更多');
              break;
            case LoadStatus.noMore:
              body = const Text('没有更多数据了');
              break;
            default:
              body = const Text('');
          }
          return SizedBox(
            height: 55,
            child: Center(child: body),
          );
        },
      ),
      child: _buildListView(),
    );
  }

  Widget _buildListView() {
    if (widget.items.isEmpty && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    final hasHeader = widget.header != null;
    final totalItemCount = widget.items.length + (hasHeader ? 1 : 0);

    return ListView.builder(
      controller: widget.scrollController,
      itemCount: totalItemCount,
      itemBuilder: (context, index) {
        if (hasHeader && index == 0) {
          return widget.header!;
        }
        
        final dataIndex = hasHeader ? index - 1 : index;
        return widget.itemBuilder(context, widget.items[dataIndex], dataIndex);
      },
    );
  }
}