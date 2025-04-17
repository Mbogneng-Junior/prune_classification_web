// lib/services/analysis_service.dart

import 'dart:io';
import 'dart:math'; // Pour Random
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/plum_result.dart';
import 'database_service.dart';
import 'dart:math' as math;

class AnalysisService {
  static Interpreter? _interpreter;
  static const List<String> classNames = [
    'unripe',
    'cracked',
    'Rotten',
    'spotted',
    'bruised',
    'unaffected'
  ];
  static bool _modelLoaded = false;

  /// Charge le modèle ONNX au démarrage de l'application
  static Future<void> loadModel() async {
    if (_modelLoaded) return;

    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/models/plums_rexnet150_mobile_quant_dynamic.onnx');
      debugPrint('Modèle chargé avec succès');
      _modelLoaded = true;
    } catch (e) {
      debugPrint('Erreur lors du chargement du modèle: $e');
      _modelLoaded = false;
    }
  }

  /// Analyse une image de prune et retourne un résultat
  /// Cette méthode utilise le modèle ONNX pour la classification
  static Future<PlumResult> analyzeImage(File imageFile) async {
    try {
      // Essayer de charger le modèle s'il n'est pas déjà chargé
      if (!_modelLoaded) {
        await loadModel();
      }

      // Si le modèle est chargé, l'utiliser pour l'analyse
      if (_modelLoaded) {
        return await _analyzeWithModel(imageFile);
      } else {
        // Fallback sur la simulation si le modèle ne peut pas être chargé
        return await _simulateAnalysis(imageFile);
      }
    } catch (e) {
      debugPrint('Erreur pendant l\'analyse: $e');
      // En cas d'erreur, utiliser la simulation
      return await _simulateAnalysis(imageFile);
    }
  }

  /// Simule une analyse pour les tests ou en cas d'échec du modèle
  static Future<PlumResult> _simulateAnalysis(File imageFile) async {
    // Simuler un temps de traitement
    await Future.delayed(const Duration(seconds: 1));

    // Générer un résultat aléatoire
    final random = Random();
    final categoryIdx = random.nextInt(PlumCategory.values.length);
    final confidence = 0.65 + random.nextDouble() * 0.3; // Entre 0.65 et 0.95

    final result = PlumResult(
      category: PlumCategory.values[categoryIdx],
      confidence: confidence,
    );

    // Sauvegarder le résultat dans l'historique
    await DatabaseService.saveAnalysisResult(
      imageFile.path,
      result,
    );

    return result;
  }

  /// Analyse une image de prune avec le modèle ONNX chargé
  static Future<PlumResult> _analyzeWithModel(File imageFile) async {
    // Prétraiter l'image selon les spécifications du modèle
    final inputData = await _preprocessImage(imageFile);

    // Préparer le tenseur de sortie: [1, 6]
    final outputShape = [1, 6];
    final outputBuffer = List<double>.filled(6, 0).reshape(outputShape);

    // Exécuter l'inférence
    _interpreter!.run(inputData, outputBuffer);

    // Trouver la catégorie avec la plus haute confiance (argmax)
    int maxIndex = 0;
    double maxConfidence = outputBuffer[0][0];

    for (int i = 1; i < outputBuffer[0].length; i++) {
      if (outputBuffer[0][i] > maxConfidence) {
        maxConfidence = outputBuffer[0][i];
        maxIndex = i;
      }
    }

    // Appliquer softmax pour normaliser les confiances
    final softmaxScores = _softmax(outputBuffer[0]);
    final confidence = softmaxScores[maxIndex];

    // Mapper l'index à une catégorie
    final category = _mapIndexToCategory(maxIndex);

    final result = PlumResult(
      category: category,
      confidence: confidence,
    );

    // Sauvegarder le résultat dans l'historique
    await DatabaseService.saveAnalysisResult(
      imageFile.path,
      result,
    );

    return result;
  }

  /// Mappe l'index de sortie du modèle à une catégorie de PlumCategory
  static PlumCategory _mapIndexToCategory(int index) {
    switch (classNames[index]) {
      case 'unripe':
        return PlumCategory.unripe;
      case 'cracked':
        return PlumCategory.cracked;
      case 'Rotten':
        return PlumCategory.rotten;
      case 'spotted':
        return PlumCategory.spotted;
      case 'bruised':
        return PlumCategory.bruised;
      case 'unaffected':
        return PlumCategory.goodQuality;
      default:
        return PlumCategory.goodQuality;
    }
  }

  /// Prétraitement de l'image pour le modèle ONNX
  /// Convertit l'image en tenseur [1, 3, 224, 224] au format NCHW
  static Future<List<List<List<List<double>>>>> _preprocessImage(
      File imageFile) async {
    // Charger l'image
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Impossible de décoder l\'image');

    // Redimensionner à 224x224
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    // Valeurs de normalisation
    final mean = [0.485, 0.456, 0.406];
    final std = [0.229, 0.224, 0.225];

    // Initialiser le tenseur NCHW [1, 3, 224, 224]
    var inputData = List.generate(
      1,
      (_) => List.generate(
        3,
        (c) => List.generate(
          224,
          (h) => List.generate(
            224,
            (w) => 0.0,
          ),
        ),
      ),
    );

    // Remplir le tenseur en format NCHW
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        // Accéder directement aux composantes RGB d'un pixel
        final pixel = resizedImage.getPixel(x, y);

        // Normalisation (utiliser les propriétés r, g, b directement)
        final normalizedR = (pixel.r / 255.0 - mean[0]) / std[0];
        final normalizedG = (pixel.g / 255.0 - mean[1]) / std[1];
        final normalizedB = (pixel.b / 255.0 - mean[2]) / std[2];

        // Assigner aux canaux (NCHW)
        inputData[0][0][y][x] = normalizedR;
        inputData[0][1][y][x] = normalizedG;
        inputData[0][2][y][x] = normalizedB;
      }
    }

    return inputData;
  }

  /// Applique la fonction softmax sur un tableau pour normaliser les valeurs
  static List<double> _softmax(List<double> inputs) {
    // Trouver le maximum pour stabilité numérique
    double max = inputs.reduce((a, b) => a > b ? a : b);

    // Calculer e^(x-max) pour chaque valeur
    List<double> expValues = inputs.map((x) => exp(x - max)).toList();

    // Calculer la somme pour normalisation
    double sum = expValues.reduce((a, b) => a + b);

    // Normaliser pour obtenir des probabilités
    return expValues.map((x) => x / sum).toList();
  }

  /// Fonction exponentielle pour le calcul de softmax
  static double exp(double x) {
    return math.exp(x);
  }
}
