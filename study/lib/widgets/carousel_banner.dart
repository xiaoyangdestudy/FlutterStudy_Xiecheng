import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselBanner extends StatefulWidget {
  final List<String> images;
  final double height;
  final double viewportFraction;
  final Duration autoPlayInterval;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final bool showIndicators;
  final Function(int)? onPageChanged;
  final Function(String)? onImageTap;

  const CarouselBanner({
    super.key,
    required this.images,
    this.height = 200,
    this.viewportFraction = 0.8,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlay = true,
    this.enlargeCenterPage = false,
    this.showIndicators = true,
    this.onPageChanged,
    this.onImageTap,
  });

  @override
  State<CarouselBanner> createState() => CarouselBannerState();
}

class CarouselBannerState extends State<CarouselBanner> {
  int _currentIndex = 0;
  late CarouselSliderController _carouselController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  void setVisibility(bool isVisible) {
    if (_isVisible != isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('No images to display'),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: widget.height,
              autoPlay: widget.autoPlay && _isVisible,
              autoPlayInterval: widget.autoPlayInterval,
              enlargeCenterPage: widget.enlargeCenterPage,
              viewportFraction: widget.viewportFraction,
              aspectRatio: 16/9,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
                widget.onPageChanged?.call(index);
              },
            ),
            items: widget.images.map(_buildCarouselItem).toList(),
          ),
          if (widget.showIndicators)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _buildIndicators(),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
        (index) => _buildIndicatorDot(index),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    return GestureDetector(
      onTap: () => _carouselController.animateToPage(index),
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.white : Colors.white.withOpacity(0.4),
          border: _currentIndex == index ? Border.all(color: Colors.blue, width: 1) : null,
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath) {
    return GestureDetector(
      onTap: () => widget.onImageTap?.call(imagePath),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(imagePath),
              _buildGradientOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    final isNetworkImage = imagePath.startsWith('http');
    
    return isNetworkImage
        ? Image.network(imagePath, fit: BoxFit.cover, errorBuilder: _buildErrorWidget)
        : Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: _buildErrorWidget);
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.broken_image,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}