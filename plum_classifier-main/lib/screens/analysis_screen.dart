// lib/screens/analysis_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/language_provider.dart';
import '../models/plum_result.dart';
import '../services/analysis_service.dart';
import 'result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final File imageFile;

  const AnalysisScreen({
    super.key,
    required this.imageFile,
  });

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnalyzing = true;
  PlumResult? _result;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animationController.repeat();
    
    _analyzeImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeImage() async {
    try {
      // Simulation d'analyse avec un délai
      await Future.delayed(const Duration(seconds: 3));
      
      // Ici, vous intégreriez le modèle IA pour l'analyse réelle
      final result = await AnalysisService.analyzeImage(widget.imageFile);
      
      setState(() {
        _result = result;
        _isAnalyzing = false;
      });

      if (!mounted) return;
      
      // Naviguer vers l'écran de résultat après un court délai
      await Future.delayed(const Duration(milliseconds: 500));
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: widget.imageFile,
            result: _result!,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'analyse : ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('analyzing')),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Image à analyser
                      Hero(
                        tag: 'plum_image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            widget.imageFile,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Animation de chargement
                      if (_isAnalyzing) ...[
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.primaryColor,
                                      width: 3,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                    gradient: SweepGradient(
                                      colors: [
                                        AppTheme.primaryColor.withOpacity(0),
                                        AppTheme.primaryColor,
                                      ],
                                      stops: const [0.75, 1.0],
                                      transform: GradientRotation(
                                        _animationController.value * 6.28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          context.tr('analyzing'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          'Veuillez patienter pendant que nous analysons votre prune...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ] else ...[
                        // Résultat de l'analyse (affichage transitoire avant navigation)
                        if (_result != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _result!.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _result!.icon,
                                  color: _result!.color,
                                  size: 30,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _result!.categoryName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _result!.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}