import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'prescription_result_screen.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  final PlatformFile file;

  const AnalysisLoadingScreen({super.key, required this.file});

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _uploadFile();
  }

  Future<void> _uploadFile() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://paradeless-unfrowardly-tracy.ngrok-free.dev/upload'));
      
      if (widget.file.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes('file', widget.file.bytes!, filename: widget.file.name));
      } else if (widget.file.path != null) {
        request.files.add(await http.MultipartFile.fromPath('file', widget.file.path!));
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String extractedText = data['extracted_text'] ?? '';
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => PrescriptionResultScreen(extractedText: extractedText)),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            try {
               final data = jsonDecode(response.body);
               _errorText = data['error'] ?? 'Error analyzing prescription.';
            } catch(e) {
               _errorText = 'Error: ${response.statusCode} - ${response.body}';
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = 'Connection failed. Ensure app.py is running.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.autorenew, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Analyzing Prescription...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorText.isNotEmpty ? _errorText : 'Extracting medicines and doctor notes with AI',
              style: TextStyle(
                color: _errorText.isNotEmpty ? Colors.redAccent : Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
