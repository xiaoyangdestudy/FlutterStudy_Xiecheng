import 'package:flutter/material.dart';

class AdditionalServiceItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  AdditionalServiceItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class AdditionalServices extends StatelessWidget {
  final List<AdditionalServiceItem> services;

  const AdditionalServices({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          // 第一行 - 5个服务
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: services.take(5).map((service) => _buildServiceItem(service)).toList(),
          ),
          const SizedBox(height: 24),
          // 第二行 - 5个服务
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: services.skip(5).take(5).map((service) => _buildServiceItem(service)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(AdditionalServiceItem service) {
    return GestureDetector(
      onTap: service.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            child: Icon(
              service.icon,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}