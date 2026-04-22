import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/colors.dart';
import 'analysis_loading_screen.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() => _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  String _selectedSpecialty = 'Dermatologist';
  String? _uploadedFileName;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        setState(() {
          _uploadedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint("File picker error: $e");
    }
  }

  void _showOverlayMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.danger : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Upload Document'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Doctor Specialty', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSpecialty,
                    isExpanded: true,
                    icon: const Icon(LucideIcons.chevronDown, color: AppColors.textSecondary),
                    items: ['Dermatologist', 'Cardiologist', 'Gynecologist', 'Pediatrician', 'Orthopedic']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        if (val != null) _selectedSpecialty = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text('File Upload', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _uploadedFileName != null ? LucideIcons.checkCircle : LucideIcons.uploadCloud, 
                          color: AppColors.primary, 
                          size: 32
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _uploadedFileName ?? 'Tap to upload or drag and drop', 
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      if (_uploadedFileName == null) ...[
                        const SizedBox(height: 4),
                        const Text('PDF, JPG, PNG (max. 10MB)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Patient Notes (Optional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any specific symptoms or questions...',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  if (_uploadedFileName == null) {
                    _showOverlayMessage('Please upload a valid document', isError: true);
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AnalysisLoadingScreen()),
                  );
                },
                child: const Text('Analyze Prescription'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  if (_uploadedFileName == null) {
                    _showOverlayMessage('Please upload a valid document', isError: true);
                    return;
                  }
                  _showOverlayMessage('Prescription has been saved successfully');
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) Navigator.of(context).pop();
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Save Without Analysis'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  if (_uploadedFileName == null) {
                    _showOverlayMessage('Please upload a valid document', isError: true);
                    return;
                  }
                  _showOverlayMessage('Report has been saved successfully');
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) Navigator.of(context).pop();
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Upload Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
