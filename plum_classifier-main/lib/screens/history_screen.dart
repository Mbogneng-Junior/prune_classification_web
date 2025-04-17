// lib/screens/history_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/language_provider.dart';
import '../models/plum_result.dart';
import '../services/database_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _historyItems = [];
  bool _isLoading = true;
  bool _isDeleting = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  List<PlumCategory> _filterCategories = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final history = await DatabaseService.getAnalysisHistory();

      setState(() {
        _historyItems = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Erreur lors du chargement de l\'historique. Veuillez réessayer.';
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors du chargement de l\'historique : ${e.toString()}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Réessayer',
            onPressed: _loadHistory,
            textColor: Colors.white,
          ),
        ),
      );
    }
  }

  Future<void> _clearHistory() async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Effacer l\'historique'),
          content: Text(
              'Êtes-vous sûr de vouloir effacer tout l\'historique des analyses ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Effacer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isDeleting = true;
      });

      try {
        await DatabaseService.clearAnalysisHistory();

        setState(() {
          _historyItems = [];
          _isDeleting = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Historique effacé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() {
          _isDeleting = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de l\'effacement de l\'historique : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(int analysisId, int index) async {
    try {
      await DatabaseService.deleteAnalysis(analysisId);

      setState(() {
        _historyItems.removeAt(index);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyse supprimée'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression : ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _filteredHistoryItems {
    if (_filterCategories.isEmpty) {
      return _historyItems;
    }

    return _historyItems.where((item) {
      final category = PlumCategory.values[item['category']];
      return _filterCategories.contains(category);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Removed unused themeProvider variable

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('history')),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_historyItems.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
            IconButton(
              icon: _isDeleting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.delete_outline),
              onPressed: _isDeleting ? null : _clearHistory,
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? _buildErrorView()
                  : _historyItems.isEmpty
                      ? _buildEmptyHistory()
                      : _buildHistoryList(),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrer par catégorie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PlumCategory.values.map((category) {
                      final isSelected = _filterCategories.contains(category);
                      PlumResult dummyResult = PlumResult(
                        category: category,
                        confidence: 0.8,
                      );

                      return FilterChip(
                        selected: isSelected,
                        label: Text(
                          dummyResult.categoryName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        avatar: Icon(
                          dummyResult.icon,
                          size: 16,
                          color: isSelected ? Colors.white : dummyResult.color,
                        ),
                        backgroundColor: dummyResult.color.withOpacity(0.1),
                        selectedColor: dummyResult.color,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _filterCategories.add(category);
                            } else {
                              _filterCategories.remove(category);
                            }
                          });

                          // Mettre à jour l'état du widget parent
                          this.setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterCategories.clear();
                          });
                          this.setState(() {});
                        },
                        child: Text('Réinitialiser'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Appliquer'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadHistory,
            icon: Icon(Icons.refresh),
            label: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr('noHistory'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Analysez des prunes pour les voir apparaître ici',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Naviguer vers l'écran d'accueil (index 0)
              if (context.findAncestorStateOfType<State>() != null) {
                // Cela dépend de la structure de votre application
                // Vous devrez peut-être ajuster cette logique
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.camera_alt),
            label: Text('Analyser une prune'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final filteredItems = _filteredHistoryItems;

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat pour ce filtre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterCategories.clear();
                });
              },
              child: Text('Supprimer les filtres'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // En-tête avec statistiques
        if (_historyItems.isNotEmpty) _buildHistoryStats(),

        // Liste des éléments
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              final category = PlumCategory.values[item['category']];
              final confidence = item['confidence'] as double;
              final timestamp =
                  DateTime.fromMillisecondsSinceEpoch(item['timestamp']);
              final imagePath = item['image_path'];
              final id = item['id'] as int;

              // Créer un objet PlumResult à partir des données
              final result = PlumResult(
                category: category,
                confidence: confidence,
                timestamp: timestamp,
              );

              return Dismissible(
                key: Key('history_item_${id}'),
                background: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteItem(id, index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildHistoryCard(
                    context,
                    result: result,
                    imagePath: imagePath,
                    id: id,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryStats() {
    // Compter les différentes catégories
    Map<PlumCategory, int> categoryCounts = {};
    for (var item in _historyItems) {
      final category = PlumCategory.values[item['category']];
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    // Trouver la catégorie la plus fréquente
    PlumCategory? mostFrequentCategory;
    int maxCount = 0;
    categoryCounts.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequentCategory = category;
      }
    });

    if (mostFrequentCategory == null) return SizedBox.shrink();

    // Créer un résultat factice pour la catégorie la plus fréquente
    final dummyResult = PlumResult(
      category: mostFrequentCategory!,
      confidence: 1.0,
    );

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dummyResult.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dummyResult.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                title: 'Total',
                value: '${_historyItems.length}',
                icon: Icons.analytics,
              ),
              _buildStatItem(
                title: 'Catégorie fréquente',
                value: dummyResult.categoryName,
                icon: dummyResult.icon,
                color: dummyResult.color,
              ),
              _buildStatItem(
                title: 'Dernier scan',
                value: _formatTimeAgo(_historyItems.first['timestamp']),
                icon: Icons.access_time,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? Colors.grey,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required PlumResult result,
    required String imagePath,
    required int id,
  }) {
    final file = File(imagePath);
    final dateFormat = DateFormat.yMMMd().add_Hm();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (file.existsSync()) {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => ResultScreen(
                  imageFile: file,
                  result: result,
                ),
              ),
            )
                .then((_) {
              // Recharger l'historique après retour de l'écran de résultat
              _loadHistory();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image non disponible'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Supprimer',
                  textColor: Colors.white,
                  onPressed: () {
                    _deleteItem(id,
                        _historyItems.indexWhere((item) => item['id'] == id));
                  },
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Miniature de l'image avec badge de catégorie
              Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: file.existsSync()
                        ? Hero(
                            tag: 'history_image_$id',
                            child: Image.file(
                              file,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey.withOpacity(0.3),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                  ),

                  // Badge de catégorie
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: result.color.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            result.icon,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            result.categoryName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Détails de l'analyse
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date et heure avec icône
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          SizedBox(width: 4),
                          Text(
                            dateFormat.format(result.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Catégorie
                      Text(
                        _getShortAdvice(result.category),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Niveau de confiance
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                // Background
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                // Progress
                                FractionallySizedBox(
                                  widthFactor: result.confidence,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: result.color,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: result.color.withOpacity(0.3),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: result.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: result.color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${(result.confidence * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: result.color,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Détails',
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            _formatTimeAgo(
                                result.timestamp.millisecondsSinceEpoch),
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
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

  String _getShortAdvice(PlumCategory category) {
    switch (category) {
      case PlumCategory.goodQuality:
        return 'Prune de qualité optimale, prête à être consommée';
      case PlumCategory.unripe:
        return 'Prune non mûre, à laisser mûrir quelques jours';
      case PlumCategory.spotted:
        return 'Prune avec taches, comestible mais moins appétissante';
      case PlumCategory.cracked:
        return 'Prune fissurée, à consommer rapidement';
      case PlumCategory.bruised:
        return 'Prune meurtrie, idéale pour les compotes';
      case PlumCategory.rotten:
        return 'Prune pourrie, non comestible';
    }
  }

  String _formatTimeAgo(int timestamp) {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return 'Il y a ${(difference.inDays / 365).floor()} an(s)';
    } else if (difference.inDays > 30) {
      return 'Il y a ${(difference.inDays / 30).floor()} mois';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour(s)';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure(s)';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute(s)';
    } else {
      return 'À l\'instant';
    }
  }
}
