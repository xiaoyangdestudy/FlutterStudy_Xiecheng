import 'package:flutter/material.dart';
import 'package:study/models/service_category.dart';

class ServiceGrid extends StatelessWidget {
  final List<ServiceRow> serviceRows;

  const ServiceGrid({
    super.key,
    required this.serviceRows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
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
          for (int i = 0; i < serviceRows.length; i++) ...[
            _buildServiceRow(
              serviceRows[i], 
              i == 0, 
              i == serviceRows.length - 1
            ),
            // 添加行间分割线，除了最后一行
            if (i < serviceRows.length - 1)
              Container(
                height: 1,
                color: Colors.white24,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceRow(ServiceRow row, bool isFirst, bool isLast) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: row.gradientColors,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
          topRight: isFirst ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          // 左侧图标区域 (1/3宽度)
          Expanded(
            flex: 1,
            child: _buildIconSection(row.services[0]),
          ),
          // 右侧2x2网格区域 (2/3宽度)
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.white24, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // 上排两个服务
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildTextService(row.services[1])),
                        Container(
                          width: 0.5,
                          color: Colors.white24,
                        ),
                        Expanded(child: _buildTextService(row.services[2])),
                      ],
                    ),
                  ),
                  // 分隔线
                  Container(
                    height: 0.5,
                    color: Colors.white24,
                  ),
                  // 下排两个服务
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildTextService(row.services[3])),
                        Container(
                          width: 0.5,
                          color: Colors.white24,
                        ),
                        Expanded(child: _buildTextService(row.services[4])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSection(ServiceCategory service) {
    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (service.icon != null)
              Icon(
                service.icon,
                color: Colors.white,
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              service.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextService(ServiceCategory service) {
    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        height: double.infinity,
        child: Center(
          child: Text(
            service.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}