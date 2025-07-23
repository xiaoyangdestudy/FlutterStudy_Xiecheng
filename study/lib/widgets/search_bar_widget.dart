import 'package:flutter/material.dart';
import 'package:study/models/city.dart';
import 'package:study/widgets/logout_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final City selectedCity;
  final List<City> cities;
  final String searchPlaceholder;
  final Function(City)? onCityChanged;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchTap;
  final double? backgroundOpacity; // 新增：背景透明度参数

  const SearchBarWidget({
    super.key,
    this.selectedCity = const City(id: '1', name: '北京', code: 'BJ'),
    this.cities = City.defaultCities,
    this.searchPlaceholder = '网红打卡地 景点 酒店 美食',
    this.onCityChanged,
    this.onSearchChanged,
    this.onSearchTap,
    this.backgroundOpacity,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> with SingleTickerProviderStateMixin {
  late City _selectedCity;
  final TextEditingController _searchController = TextEditingController();
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _searchController.addListener(() {
      widget.onSearchChanged?.call(_searchController.text);
    });

    // 初始化动画控制器
    _initializeAnimation();
  }

  void _initializeAnimation() {
    try {
      _pulseController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.08,
      ).animate(CurvedAnimation(
        parent: _pulseController!,
        curve: Curves.easeInOut,
      ));
      
      _pulseController?.repeat(reverse: true);
    } catch (e) {
      // 如果动画初始化失败，我们仍然可以正常显示UI
      print('Animation initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 城市选择器
          _buildLocationDropdown(),
          const SizedBox(width: 8),
          // 搜索框 - 占主要空间
          Expanded(child: _buildSearchField()),
          const SizedBox(width: 8),

          LogoutWidget(
            buttonText: '登出',
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            textColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            borderRadius: 20,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            buttonSize: const Size(60, 40),
            useSearchBarStyle: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
    final opacity = widget.backgroundOpacity ?? 0.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showCityPicker(),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9 + (opacity * 0.1)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.lerp(const Color(0xFFE0E0E0), Colors.grey[400]!, opacity)!,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04 + (opacity * 0.06)),
                blurRadius: 6 + (opacity * 2),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                _selectedCity.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final opacity = widget.backgroundOpacity ?? 0.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onSearchTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9 + (opacity * 0.1)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.lerp(const Color(0xFFE0E0E0), Colors.grey[400]!, opacity)!,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04 + (opacity * 0.06)),
                blurRadius: 6 + (opacity * 2),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 搜索图标
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: _buildSearchIcon(),
              ),
              // 搜索文本
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    widget.searchPlaceholder,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.lerp(Colors.grey[500]!, Colors.grey[600]!, opacity),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchIcon() {
    // 如果动画可用，使用动画版本；否则使用静态版本
    if (_pulseAnimation != null && _pulseController != null) {
      return AnimatedBuilder(
        animation: _pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation!.value,
            child: _buildIconContainer(),
          );
        },
      );
    } else {
      return _buildIconContainer();
    }
  }

  Widget _buildIconContainer() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.search,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部指示器
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // 标题
              Text(
                '选择城市',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              // 城市列表
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.cities.map((city) {
                      final isSelected = city.id == _selectedCity.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCity = city;
                          });
                          widget.onCityChanged?.call(city);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Text(
                            city.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected 
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}