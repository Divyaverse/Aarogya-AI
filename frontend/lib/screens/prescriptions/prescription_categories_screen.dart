import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import 'doctor_history_screen.dart';

class PrescriptionCategoriesScreen extends StatelessWidget {
  const PrescriptionCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () {
            // Usually this would pop, but it's a bottom nav root item
          },
        ),
        title: const Text('Medical Records'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(LucideIcons.folder, color: Colors.white, size: 24),
                          SizedBox(height: 12),
                          Text('Total Records', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text('42', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(LucideIcons.history, color: AppColors.primary, size: 24),
                          SizedBox(height: 12),
                          Text('Last Updated', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text('2 days ago', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Specialties Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Specialties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Sort by recent', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Specialty List
              _buildSpecialtyCard(
                context,
                icon: LucideIcons.smile,
                iconColor: AppColors.primary,
                iconBg: AppColors.primary.withOpacity(0.1),
                title: 'Dermatologist',
                subtitle: '12 Records Stored',
              ),
              const SizedBox(height: 12),
              _buildSpecialtyCard(
                context,
                icon: LucideIcons.heart,
                iconColor: AppColors.danger,
                iconBg: AppColors.danger.withOpacity(0.1),
                title: 'Cardiologist',
                subtitle: '8 Records Stored',
              ),
              const SizedBox(height: 12),
              _buildSpecialtyCard(
                context,
                icon: LucideIcons.activity,
                iconColor: Colors.purple,
                iconBg: Colors.purple.withOpacity(0.1),
                title: 'Gynecologist',
                subtitle: '5 Records Stored',
              ),
              const SizedBox(height: 12),
              _buildSpecialtyCard(
                context,
                icon: LucideIcons.baby,
                iconColor: AppColors.warning,
                iconBg: AppColors.warning.withOpacity(0.1),
                title: 'Pediatrician',
                subtitle: '14 Records Stored',
              ),
              const SizedBox(height: 12),
              _buildSpecialtyCard(
                context,
                icon: LucideIcons.user,
                iconColor: AppColors.success,
                iconBg: AppColors.success.withOpacity(0.1),
                title: 'Orthopedic',
                subtitle: '3 Records Stored',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DoctorHistoryScreen(specialtyName: title),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('View\nHistory', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
