// lib/services/model_service.dart

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/plum_result.dart';

class ModelService {
  static Interpreter? _interpreter;
  static const List<String> classNames = ['unripe', 'cracked', 'Rotten', 'spotted', 'bruised', 'unaffected'];
  static bool _modelLoaded = false;

  /// Charge le modèle ONNX au démarrage de l'application
  static Future<void> loadModel() async {
    if (_modelLoaded && _interpreter != null) return;
    
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/plums_rexnet150_mobile_quant_dynamic.onnx');
      debugPrint('Modèle chargé avec succès');
      _modelLoaded = true;
    } catch (e) {
      debugPrint('Erreur lors du chargement du modèle: $e');
      _modelLoaded = false;
    }
  }

  /// Classifie une image de prune
  static Future<PlumResult> classifyImage(File imageFile) async {
    try {
      if (!_modelLoaded || _interpreter == null) {
        await loadModel();
      }
      
      if (!_modelLoaded || _interpreter == null) {
        throw Exception("Impossible de charger le modèle");
      }
      
      // Pré-traitement de l'image
      final imageData = await _preprocessImage(imageFile);
      
      // Préparer les tenseurs d'entrée et de sortie
      var output = List<List<double>>.filled(1, List<double>.filled(6, 0));
      
      // Exécuter l'inférence
      _interpreter!.run(imageData, output);
      
      // Trouver l'index avec la valeur la plus élevée (argmax)
      int maxIndex = 0;
      double maxConfidence = output[0][0];
      
      for (int i = 1; i < output[0].length; i++) {
        if (output[0][i] > maxConfidence) {
          maxIndex = i;
          maxConfidence = output[0][i];
        }
      }
      
      // Convertir l'index en catégorie
      final category = _mapIndexToCategory(maxIndex);
      
      // Le score est normalisé entre 0 et 1
      final confidence = _softmax(output[0])[maxIndex];
      
      return PlumResult(
        category: category,
        confidence: confidence,
      );
    } catch (e) {
      debugPrint('Erreur lors de la classification: $e');
      // Retourner une valeur par défaut en cas d'erreur
      return PlumResult(
        category: PlumCategory.goodQuality,
        confidence: 0.5,
      );
    }
  }

  /// Convertit l'index en catégorie de prune
  static PlumCategory _mapIndexToCategory(int index) {
    if (index < 0 || index >= classNames.length) {
      debugPrint('Index hors limites: $index, utilisation de la valeur par défaut');
      return PlumCategory.goodQuality;
    }
    
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

  /// Prétraite l'image pour le modèle
  static Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      // Charger l'image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Impossible de décoder l\'image');
      }
      
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
          // Obtenir les composantes RGB en évitant les problèmes avec les types Pixel
          final pixel = resizedImage.getPixel(x, y);
          
          // Extraire les composantes RGB
          // Utilisation de la nouvelle API avec les getters r, g, b
          final r = pixel.r.toDouble() / 255.0;
          final g = pixel.g.toDouble() / 255.0;
          final b = pixel.b.toDouble() / 255.0;
          
          // Normalisation
          final normalizedR = (r - mean[0]) / std[0];
          final normalizedG = (g - mean[1]) / std[1];
          final normalizedB = (b - mean[2]) / std[2];
          
          // Assigner aux canaux (NCHW)
          inputData[0][0][y][x] = normalizedR;
          inputData[0][1][y][x] = normalizedG;
          inputData[0][2][y][x] = normalizedB;
        }
      }
      
      return inputData;
    } catch (e) {
      debugPrint('Erreur lors du prétraitement de l\'image: $e');
      
      // Retourner un tenseur rempli de zéros en cas d'erreur
      return List.generate(
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
    }
  }

  /// Applique la fonction softmax pour normaliser les scores
  static List<double> _softmax(List<double> inputs) {
    try {
      // Trouver le maximum pour stabilité numérique
      double max = inputs.reduce((a, b) => a > b ? a : b);
      
      // Calculer e^(x-max) pour chaque valeur
      List<double> expValues = [];
      for (double x in inputs) {
        expValues.add(math.exp(x - max));
      }
      
      // Calculer la somme pour normalisation
      double sum = 0;
      for (double val in expValues) {
        sum += val;
      }
      
      // Normaliser pour obtenir des probabilités
      List<double> result = [];
      for (double val in expValues) {
        result.add(val / sum);
      }
      
      return result;
    } catch (e) {
      debugPrint('Erreur lors du calcul de softmax: $e');
      // Retourner des valeurs uniformes en cas d'erreur
      return List.filled(inputs.length, 1.0 / inputs.length);
    }
  }
}