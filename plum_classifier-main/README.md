# 🍑 Plum Classifier - JCIA Hackathon 2025  
**Tri Automatique des Prunes avec IA**

Ce projet a été développé dans le cadre du JCIA Hackathon 2025 sur le thème "Intelligence Artificielle et Développement Économique : Innover pour transformer". Il s'agit d'un système de tri automatique des prunes en six catégories (bonne qualité, non mûre, tachetée, fissurée, meurtrie et pourrie) utilisant des techniques de vision par ordinateur et d'apprentissage profond.

## Table des matières
- [🍑 Plum Classifier - JCIA Hackathon 2025](#-plum-classifier---jcia-hackathon-2025)
  - [Table des matières](#table-des-matières)
  - [Description du projet](#description-du-projet)
  - [🧠 Technologies utilisées](#-technologies-utilisées)
    - [💻 Backend (IA / Classification) :](#-backend-ia--classification-)
    - [📱 Frontend (App Mobile) :](#-frontend-app-mobile-)
    - [🗂️ Autres :](#️-autres-)
  - [Structure du projet](#structure-du-projet)
  - [Installation](#installation)
    - [Prérequis](#prérequis)
    - [Cloner le dépôt](#cloner-le-dépôt)
    - [Installer les dépendances](#installer-les-dépendances)
  - [Utilisation](#utilisation)
    - [Exécuter l'application](#exécuter-lapplication)
    - [Tests](#tests)
    - [Build de l'application](#build-de-lapplication)
  - [Technologies utilisées](#technologies-utilisées)
  - [Modèle IA](#modèle-ia)
    - [Jeu de données](#jeu-de-données)
    - [Prétraitement](#prétraitement)
    - [Performances](#performances)
  - [👥 Équipe : \[Nom de l'équipe\]](#-équipe--nom-de-léquipe)
  - [Licence](#licence)
  - [🎥 Démonstration vidéo](#-démonstration-vidéo)

## Description du projet

Le but de ce projet est de développer un modèle d'intelligence artificielle capable de classer automatiquement des images de prunes en six catégories distinctes :
- Bonne qualité
- Non mûre
- Tachetée
- Fissurée
- Meurtrie
- Pourrie

Ce système peut être utilisé pour automatiser le processus de tri des prunes dans un contexte industriel ou agricole, améliorant ainsi l'efficacité et la précision du tri.

## 🧠 Technologies utilisées
### 💻 Backend (IA / Classification) :
- Python
- TensorFlow / Keras
- OpenCV
- Jupyter Notebook

### 📱 Frontend (App Mobile) :
- Flutter (Dart)

### 🗂️ Autres :
- Git & GitHub
- Android Studio / VS Code

---

## Structure du projet

```
plum_classifier/
│
├── .dart_tool/               # Outils Dart
├── .idea/                    # Configurations IDE
├── android/                  # Configuration Android
├── assets/                   # Ressources (images, etc.)
├── build/                    # Fichiers de build
├── ios/                      # Configuration iOS
├── lib/                      # Code source principal
│   ├── localization/         # Fichiers de traduction et localisation
│   ├── models/               # Modèles de données et modèles IA
│   ├── screens/              # Écrans de l'application
│   ├── services/             # Services (API, etc.)
│   ├── utils/                # Utilitaires
│   └── widgets/              # Widgets réutilisables
│   └── main.dart             # Point d'entrée de l'application
├── linux/                    # Configuration Linux
├── macos/                    # Configuration macOS
├── test/                     # Tests unitaires et d'intégration
├── web/                      # Configuration Web
├── windows/                  # Configuration Windows
├── .flutter-plugins          # Plugins Flutter
├── .flutter-plugins-dependencies  # Dépendances des plugins
├── .gitignore                # Fichiers à ignorer par Git
├── .metadata                 # Métadonnées Flutter
├── analysis_options.yaml     # Options d'analyse de code
├── plum_classifier.iml       # Fichier de configuration du module
├── pubspec.lock              # Versions verrouillées des dépendances
└── pubspec.yaml              # Configuration des dépendances
```

## Installation

### Prérequis
- Flutter SDK (dernière version stable)
- Dart SDK
- Git
- Android Studio / Xcode (pour le développement mobile)

### Cloner le dépôt

```bash
git clone https://github.com/neussi/plum_classifier.git
cd plum_classifier
```

### Installer les dépendances

```bash
flutter pub get
```

## Utilisation

### Exécuter l'application

Pour exécuter l'application sur un émulateur ou un appareil connecté :

```bash
flutter run
```

### Tests

Pour exécuter les tests :

```bash
flutter test
```

### Build de l'application

Pour générer une version release de l'application :

```bash
# Pour Android
flutter build apk --release

# Pour iOS
flutter build ios --release

# Pour Web
flutter build web --release
```

## Technologies utilisées

- **Flutter**: Framework UI multiplateforme
- **Dart**: Langage de programmation
- **TensorFlow Lite**: Pour l'inférence du modèle de classification
- **Camera Plugin**: Pour la capture d'images en temps réel

## Modèle IA

Notre modèle de classification des prunes est basé sur une architecture CNN (Convolutional Neural Network) optimisée pour la classification d'images. 

### Jeu de données
Nous avons utilisé le jeu de données "African Plums Dataset" disponible sur Kaggle pour l'entraînement et la validation du modèle.

### Prétraitement
Les images sont prétraitées (redimensionnement, normalisation, augmentation de données) avant d'être utilisées pour l'entraînement du modèle.

### Performances
Notre modèle atteint une précision de 80% sur l'ensemble de test.


## 👥 Équipe : [Nom de l'équipe]
**Chef d'équipe** : [Ton nom ici]  
**Membres** :
- Patrice Neussi – Développement Flutter (Front-end)
- djoumessi woumpe kevin – Modélisation IA & Machine Learning (Back-end)

## Licence

Ce projet est open-source et publié sous licence MIT.

## 🎥 Démonstration vidéo  
👉 La vidéo de démonstration est disponible ici : [https://www.youtube.com](https://www.youtube.com)




