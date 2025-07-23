import 'package:flutter/material.dart';

class PromotionalService {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final Color buttonColor;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;

  PromotionalService({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.buttonColor,
    this.icon,
    this.imagePath,
    required this.onTap,
  });
}

class PromotionalServices extends StatelessWidget {
  final List<PromotionalService> services;

  const PromotionalServices({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(
        children: [
          // Header with "获取更多福利"
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '热门活动',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF39D12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF69B4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '获取更多福利 >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 2x3 Grid of compact promotional items
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // First row
                Row(
                  children: [
                    Expanded(child: _buildCompactPromotionalItem(services[0])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCompactPromotionalItem(services[1])),
                  ],
                ),
                const SizedBox(height: 8),
                // Second row
                Row(
                  children: [
                    Expanded(child: _buildCompactPromotionalItem(services[2])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCompactPromotionalItem(services[3])),
                  ],
                ),
                const SizedBox(height: 8),
                // Third row
                Row(
                  children: [
                    Expanded(child: _buildCompactPromotionalItem(services[4])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCompactPromotionalItem(services[5])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPromotionalItem(PromotionalService service) {
    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: service.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Main content area
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Subtitle
                  Text(
                    service.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Action button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: service.buttonColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      service.buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Illustration/Icon on the right side
            if (service.icon != null)
              Positioned(
                right: 4,
                top: 4,
                bottom: 4,
                child: Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    service.icon,
                    color: service.buttonColor.withOpacity(0.8),
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}