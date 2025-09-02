import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile + Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _shimmerBox(height: 60, width: 60, shape: BoxShape.circle),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(height: 16, width: 120),
                        const SizedBox(height: 8),
                        _shimmerBox(height: 14, width: 80),
                      ],
                    ),
                  ],
                ),
              ),

              // Pie chart placeholder
              Center(
                child: _shimmerBox(
                  height: 200,
                  width: 200,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 20),

              // Legend placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  alignment: WrapAlignment.center, // Center horizontally
                  runAlignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(
                    6,
                    (index) => _shimmerBox(height: 16, width: 80),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Stats cards shimmer
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: List.generate(
                    4,
                    (index) => _shimmerBox(height: 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // reusable shimmer widget
  Widget _shimmerBox({
    double? height,
    double? width,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(12)
              : null,
        ),
      ),
    );
  }
}
