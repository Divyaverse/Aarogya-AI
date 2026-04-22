import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import 'stress_history_screen.dart';

class StressResultScreen extends StatelessWidget {
  final String stressLevel;
  final double percentage;

  const StressResultScreen({
    super.key,
    required this.stressLevel,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Analysis Result'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Circular Indicator
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: percentage / 100.0,
                        strokeWidth: 16,
                        backgroundColor: AppColors.border,
                        color: stressLevel == 'High'
                            ? AppColors.danger
                            : (stressLevel == 'Medium'
                                ? AppColors.warning
                                : AppColors.success),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toInt()}%',
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$stressLevel Stress',
                          style: TextStyle(
                            fontSize: 16,
                            color: stressLevel == 'High'
                                ? AppColors.danger
                                : (stressLevel == 'Medium'
                                    ? AppColors.warning
                                    : AppColors.success),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              const Text(
                'Recommendations',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),

              _buildRecommendationCard(
                icon: LucideIcons.moon,
                title: 'Maintain Sleep Schedule',
                desc:
                    'Your 7 hours of sleep is optimal. Try to keep this consistency.',
              ),
              const SizedBox(height: 12),

              _buildRecommendationCard(
                icon: LucideIcons.wind,
                title: 'Breathing Exercises',
                desc:
                    'Take 5 minutes during work peaks for deep breathing to maintain this low stress level.',
              ),

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Done'),
              ),

              const SizedBox(height: 16),

              // ✅ ONLY CHANGE APPLIED HERE
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => StressHistoryScreen(
                        historyData: [
                          {
                            'stressLevel': stressLevel,
                            'percentage': percentage,
                            'date': 'Now',
                          }
                        ],
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('View Stress History'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}