// lib/screens/result_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/theme_provider.dart';
import '../utils/language_provider.dart';
import '../models/plum_result.dart';
import '../services/model_service.dart';
import '../services/database_service.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile;
  final PlumResult result;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  bool _isSaving = false;
  String _errorMessage = '';
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Enregistrer automatiquement dans l'historique
    _saveToHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await DatabaseService.saveAnalysisResult(
        widget.imageFile.path,
        widget.result,
      );
    } catch (e) {
      debugPrint('Erreur lors de l\'enregistrement dans l\'historique: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _reanalyzeImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final newResult = await ModelService.classifyImage(widget.imageFile);

      if (!mounted) return;

      // Créer un nouvel écran de résultat avec le nouveau résultat
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: widget.imageFile,
            result: newResult,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors de l\'analyse: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('results')),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image de la prune avec carte stylisée
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // Image
                          Hero(
                            tag: 'plum_image',
                            child: Image.file(
                              widget.imageFile,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Overlay pour un meilleur contraste avec le texte
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Indicateur d'analyse IA
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Analyse IA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bouton réanalyser
                          Positioned(
                            top: 12,
                            right: 12,
                            child: InkWell(
                              onTap: _isLoading ? null : _reanalyzeImage,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_errorMessage.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Résultat principal avec animation
                    _buildResultCard(context),

                    const SizedBox(height: 24),

                    // Conseils et recommandations
                    _buildSection(
                      context,
                      'recommandations',
                      Icons.tips_and_updates,
                      widget.result.advice,
                    ),

                    const SizedBox(height: 24),

                    // Informations supplémentaires (collapsible)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Informations supplémentaires',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _showDetails
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                            if (_showDetails) ...[
                              const SizedBox(height: 16),
                              _buildAdditionalInfo(context),
                              const SizedBox(height: 16),
                              Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.2)),
                              const SizedBox(height: 16),
                              _buildNutritionalInfo(context),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Actions avec boutons stylisés
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: Text('Nouvelle analyse'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _shareResult(context),
                            icon: const Icon(Icons.share),
                            label: Text('Partager'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppTheme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Note de bas de page
                    Center(
                      child: Text(
                        'Analysé le ${_formatDate(widget.result.timestamp)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Indicateur de sauvegarde
              if (_isSaving)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Enregistrement...',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.result.color.withOpacity(0.1),
              widget.result.color.withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: widget.result.color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Icône et étiquette de catégorie
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.result.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.result.icon,
                    color: widget.result.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RÉSULTAT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    Text(
                      widget.result.categoryName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.result.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Indicateur de confiance
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Niveau de confiance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(widget.result.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.result.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // Fond de la barre
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Barre de confiance animée
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                          begin: 0.0, end: widget.result.confidence),
                      builder: (context, value, child) {
                        return FractionallySizedBox(
                          widthFactor: value,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: widget.result.color,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.result.color.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Étiquette qualitative
            _buildQualityTag(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityTag(BuildContext context) {
    String qualityText;
    Color qualityColor;

    if (widget.result.confidence > 0.9) {
      qualityText = "Très fiable";
      qualityColor = Colors.green;
    } else if (widget.result.confidence > 0.75) {
      qualityText = "Fiable";
      qualityColor = Colors.lightGreen;
    } else if (widget.result.confidence > 0.6) {
      qualityText = "Assez fiable";
      qualityColor = Colors.amber;
    } else {
      qualityText = "Peu fiable";
      qualityColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: qualityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: qualityColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: qualityColor,
          ),
          SizedBox(width: 8),
          Text(
            qualityText,
            style: TextStyle(
              color: qualityColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    String content = '';

    switch (widget.result.category) {
      case PlumCategory.goodQuality:
        content =
            'Les prunes de bonne qualité sont riches en vitamines A, C et K, ainsi qu\'en fibres. Elles contribuent à une bonne digestion et à la santé des os.';
        break;
      case PlumCategory.unripe:
        content =
            'Les prunes non mûres contiennent plus d\'amidon et moins de sucre. Pour accélérer le mûrissement, conservez-les dans un sac en papier avec une banane mûre.';
        break;
      case PlumCategory.spotted:
        content =
            'Les taches sur les prunes sont souvent causées par des variations climatiques ou des champignons. Si les taches sont superficielles, la prune reste comestible.';
        break;
      case PlumCategory.cracked:
        content =
            'Les fissures apparaissent souvent en raison d\'un arrosage irrégulier pendant la croissance du fruit. Consommez ces prunes rapidement car elles peuvent se détériorer plus vite.';
        break;
      case PlumCategory.bruised:
        content =
            'Les meurtrissures sont causées par des chocs pendant la récolte ou le transport. Ces prunes sont parfaites pour la cuisine, car leur saveur reste intacte.';
        break;
      case PlumCategory.rotten:
        content =
            'La pourriture est généralement causée par des moisissures ou bactéries. Ne consommez jamais une prune pourrie, car elle peut contenir des mycotoxines dangereuses pour la santé.';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'À SAVOIR',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalInfo(BuildContext context) {
    // Seules les prunes de bonne qualité ont des informations nutritionnelles complètes
    if (widget.result.category != PlumCategory.goodQuality) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INFORMATION NUTRITIONNELLE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildNutrientItem('Calories', '30 kcal'),
            _buildNutrientItem('Fibres', '0.9g'),
            _buildNutrientItem('Vit. C', '10%'),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientItem(String name, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.goodQualityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.goodQualityColor,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return "aujourd'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (dateToCheck == yesterday) {
      return "hier à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      return "${date.day}/${date.month}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }

  void _shareResult(BuildContext context) async {
    final String message =
        'J\'ai analysé ma prune avec l\'app Tri Automatique des Prunes ! '
        'Résultat : ${widget.result.categoryName} (Confiance: ${(widget.result.confidence * 100).toStringAsFixed(1)}%)\n\n'
        'Conseil : ${widget.result.advice}\n\n'
        'Téléchargez l\'application pour analyser vos propres prunes !';

    await Share.share(message);
  }
}
