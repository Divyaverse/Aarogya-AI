import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'stress_result_screen.dart';

class StressAssessmentScreen extends StatefulWidget {
  const StressAssessmentScreen({super.key});

  @override
  State<StressAssessmentScreen> createState() => _StressAssessmentScreenState();
}

class _StressAssessmentScreenState extends State<StressAssessmentScreen> {
  double _sleepHours = 7;
  double _workHours = 8;
  double _screenTime = 4;
  double _physicalActivity = 30;
  double _moodScore = 5;
  String _selectedPressure = '1 = Manageable';
  double _caffeineIntake = 1;

  final List<String> _pressureLevels = ['0 = Minimal', '1 = Manageable', '2 = High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Check-in'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('How are you feeling today?', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Answer a few questions to help us assess your stress levels.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 32),

              _buildSlider(
                title: 'Hours of Sleep',
                value: _sleepHours,
                min: 0,
                max: 12,
                divisions: 12,
                minLabel: '0h',
                maxLabel: '12h+',
                valueLabel: '${_sleepHours.toInt()} Hours',
                onChanged: (val) => setState(() => _sleepHours = val),
              ),

              _buildSlider(
                title: 'Work Hours',
                value: _workHours,
                min: 0,
                max: 16,
                divisions: 16,
                minLabel: '0h',
                maxLabel: '16h+',
                valueLabel: '${_workHours.toInt()} Hours',
                onChanged: (val) => setState(() => _workHours = val),
              ),

              _buildSlider(
                title: 'Screen Time',
                value: _screenTime,
                min: 0,
                max: 12,
                divisions: 12,
                minLabel: '0h',
                maxLabel: '12h+',
                valueLabel: '${_screenTime.toInt()} Hours',
                onChanged: (val) => setState(() => _screenTime = val),
              ),

              _buildSlider(
                title: 'Physical Activity',
                value: _physicalActivity,
                min: 0,
                max: 120,
                divisions: 12,
                minLabel: '0m',
                maxLabel: '120m+',
                valueLabel: '${_physicalActivity.toInt()} mins',
                onChanged: (val) => setState(() => _physicalActivity = val),
              ),

              _buildSlider(
                title: 'Mood Score (1-10)',
                value: _moodScore,
                min: 1,
                max: 10,
                divisions: 9,
                minLabel: '1',
                maxLabel: '10',
                valueLabel: '${_moodScore.toInt()}',
                onChanged: (val) => setState(() => _moodScore = val),
              ),

              _buildSlider(
                title: 'Caffeine Intake',
                value: _caffeineIntake,
                min: 0,
                max: 6,
                divisions: 6,
                minLabel: '0c',
                maxLabel: '6c+',
                valueLabel: '${_caffeineIntake.toInt()} cups',
                onChanged: (val) => setState(() => _caffeineIntake = val),
              ),

              const Text('Work / Academic Pressure', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedPressure,
                items: _pressureLevels,
                onChanged: (val) => setState(() => _selectedPressure = val!),
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StressResultScreen()),
                  );
                },
                child: const Text('Analyze Stress Level'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String minLabel,
    required String maxLabel,
    required String valueLabel,
    required void Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(minLabel, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.2),
                label: valueLabel,
                onChanged: onChanged,
              ),
            ),
            Text(maxLabel, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ],
        ),
        Center(
          child: Text(valueLabel, 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required void Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
          items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
