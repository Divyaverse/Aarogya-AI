import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';

class StressHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;

  const StressHistoryScreen({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Stress History'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: historyData.length, // ✅ dynamic
          itemBuilder: (context, index) {

            final item = historyData[index];

            final String stressLevel = item['stressLevel'];
            final double percentage = item['percentage'];

            bool isLow = stressLevel == 'Low';
            bool isMedium = stressLevel == 'Medium';

            Color color = isLow
                ? AppColors.success
                : (isMedium ? AppColors.warning : AppColors.danger);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        '${percentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$stressLevel Stress', // ✅ dynamic
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // optional date (if available)
                        Text(
                          item['date'] ?? 'No date',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(LucideIcons.chevronRight,
                      color: AppColors.border, size: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}