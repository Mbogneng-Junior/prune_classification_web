// lib/models/plum_result.dart

import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum PlumCategory {
  goodQuality,
  unripe,
  spotted,
  cracked,
  bruised,
  rotten,
}

class PlumResult {
  final PlumCategory category;
  final double confidence;
  final DateTime timestamp;

  PlumResult({
    required this.category,
    required this.confidence,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get categoryName {
    switch (category) {
      case PlumCategory.goodQuality:
        return 'Bonne qualité';
      case PlumCategory.unripe:
        return 'Non mûre';
      case PlumCategory.spotted:
        return 'Tachetée';
      case PlumCategory.cracked:
        return 'Fissurée';
      case PlumCategory.bruised:
        return 'Meurtrie';
      case PlumCategory.rotten:
        return 'Pourrie';
    }
  }

  String get advice {
    switch (category) {
      case PlumCategory.goodQuality:
        return 'Cette prune est de bonne qualité et prête à être consommée. Elle est riche en nutriments et vitamines.';
      case PlumCategory.unripe:
        return 'Cette prune n\'est pas encore mûre. Attendez quelques jours avant de la consommer. Vous pouvez la conserver à température ambiante pour accélérer le mûrissement.';
      case PlumCategory.spotted:
        return 'Cette prune présente des taches. Elle reste comestible mais moins appétissante. Vous pouvez retirer les parties tachetées avant de la consommer.';
      case PlumCategory.cracked:
        return 'Cette prune est fissurée, consommez-la rapidement pour éviter qu\'elle ne se détériore davantage. Idéale pour préparer des compotes ou des tartes.';
      case PlumCategory.bruised:
        return 'Cette prune est meurtrie, elle peut être utilisée pour des compotes, des confitures ou des smoothies. Retirez les parties meurtries avant utilisation.';
      case PlumCategory.rotten:
        return 'Cette prune est pourrie et ne devrait pas être consommée. Jetez-la pour éviter tout risque d\'intoxication alimentaire.';
    }
  }

  Color get color {
    switch (category) {
      case PlumCategory.goodQuality:
        return AppTheme.goodQualityColor;
      case PlumCategory.unripe:
        return AppTheme.unripeColor;
      case PlumCategory.spotted:
        return AppTheme.spottedColor;
      case PlumCategory.cracked:
        return AppTheme.crackedColor;
      case PlumCategory.bruised:
        return AppTheme.bruisedColor;
      case PlumCategory.rotten:
        return AppTheme.rottenColor;
    }
  }

  IconData get icon {
    switch (category) {
      case PlumCategory.goodQuality:
        return Icons.check_circle;
      case PlumCategory.unripe:
        return Icons.access_time;
      case PlumCategory.spotted:
        return Icons.blur_circular;
      case PlumCategory.cracked:
        return Icons.broken_image;
      case PlumCategory.bruised:
        return Icons.healing;
      case PlumCategory.rotten:
        return Icons.delete;
    }
  }

  // Convertir en Map pour stockage
  Map<String, dynamic> toMap() {
    return {
      'category': category.index,
      'confidence': confidence,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Construire à partir d'une Map
  factory PlumResult.fromMap(Map<String, dynamic> map) {
    return PlumResult(
      category: PlumCategory.values[map['category']],
      confidence: map['confidence'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}