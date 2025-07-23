import 'package:flutter/material.dart';
import 'package:study/pages/discovertab_page.dart';
import 'package:study/pages/home_page.dart';
import 'package:study/pages/mytab_page.dart';
import 'package:study/pages/travelTab_page.dart';

class MainNavigationPage extends StatefulWidget {
  final String userName;
  final String userAccount;
  const MainNavigationPage({
    super.key,
    required this.userName,
    required this.userAccount,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildHomePage(),
          _buildDiscoverPage(),
          _buildTravelPage(),
          _buildMyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: '旅行',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return HomePage(
      userName: widget.userName,
      userAccount: widget.userAccount,
    );
  }

  Widget _buildDiscoverPage() {
    return const DiscoverTabPage();
  }

  Widget _buildTravelPage() {
    return const TravelTabPage();
  }

  Widget _buildMyPage() {
    return MyTabPage(
      userName: widget.userName,
      userAccount: widget.userAccount,
    );
  }
}


