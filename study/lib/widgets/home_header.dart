import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:study/widgets/carousel_banner.dart';
import 'package:study/widgets/home_navigation_bar.dart';
import 'package:study/widgets/service_grid.dart';
import 'package:study/widgets/additional_services.dart';
import 'package:study/models/service_category.dart';

class HomeHeader extends StatefulWidget {
  final List<String> bannerImages;
  final List<NavigationItem> navigationItems;
  final List<ServiceRow> serviceRows;
  final List<AdditionalServiceItem> additionalServices;
  final Function(String)? onBannerImageTap;
  final Function(int)? onBannerPageChanged;

  const HomeHeader({
    super.key,
    required this.bannerImages,
    required this.navigationItems,
    required this.serviceRows,
    required this.additionalServices,
    this.onBannerImageTap,
    this.onBannerPageChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final GlobalKey<CarouselBannerState> _carouselKey = GlobalKey<CarouselBannerState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        _buildBannerCarousel(),
        const SizedBox(height: 20),
        HomeNavigationBar(items: widget.navigationItems),
        const SizedBox(height: 20),
        ServiceGrid(serviceRows: widget.serviceRows),
        const SizedBox(height: 20),
        AdditionalServices(services: widget.additionalServices),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return VisibilityDetector(
      key: const Key('carousel-banner'),
      onVisibilityChanged: (VisibilityInfo info) {
        // 当可见度小于50%时暂停轮播
        final isVisible = info.visibleFraction > 0.5;
        _carouselKey.currentState?.setVisibility(isVisible);
      },
      child: CarouselBanner(
        key: _carouselKey,
        images: widget.bannerImages,
        height: 200,
        onImageTap: widget.onBannerImageTap ?? (imagePath) {
          print('Tapped on image: $imagePath');
        },
        onPageChanged: widget.onBannerPageChanged ?? (index) {
          print('Current page: $index');
        },
      ),
    );
  }
}