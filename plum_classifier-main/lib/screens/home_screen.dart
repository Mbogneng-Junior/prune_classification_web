// lib/screens/home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/language_provider.dart';
import '../utils/theme_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/model_service.dart';
import 'analysis_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const HistoryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  bool _modelLoaded = false;
  bool _isLoading = false;
  String _modelStatus = "Chargement du modèle...";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Vérifier si le modèle est chargé
    _checkModelStatus();
  }

  Future<void> _checkModelStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ModelService.loadModel();
      setState(() {
        _modelLoaded = true;
        _modelStatus = "Modèle prêt";
      });
    } catch (e) {
      setState(() {
        _modelLoaded = false;
        _modelStatus = "Erreur: Impossible de charger le modèle";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Le modèle n'est pas encore chargé. Veuillez réessayer."),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null && mounted) {
      _navigateToAnalysis(File(photo.path));
    }
  }

  Future<void> _pickImage() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Le modèle n'est pas encore chargé. Veuillez réessayer."),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null && mounted) {
      _navigateToAnalysis(File(image.path));
    }
  }

  void _navigateToAnalysis(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnalysisScreen(imageFile: imageFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar personnalisée
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: isDarkMode
                  ? AppTheme.backgroundColorDark
                  : AppTheme.backgroundColorLight,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                title: Text(
                  'Tri Automatique des Prunes',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDarkMode
                          ? [
                              AppTheme.primaryColor.withOpacity(0.3),
                              AppTheme.backgroundColorDark.withOpacity(0.8)
                            ]
                          : [
                              AppTheme.primaryColor.withOpacity(0.2),
                              AppTheme.backgroundColorLight.withOpacity(0.2)
                            ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -40,
                        right: -40,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor:
                              AppTheme.accentColor.withOpacity(0.1),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            ClipOval(
                              child: Container(
                                width: 70,
                                height: 70,
                                color: Colors.white,
                                padding: const EdgeInsets.all(5),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Contenu principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Indicateur d'état du modèle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _modelLoaded
                            ? AppTheme.goodQualityColor.withOpacity(0.1)
                            : _isLoading
                                ? AppTheme.crackedColor.withOpacity(0.1)
                                : AppTheme.rottenColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _modelLoaded
                              ? AppTheme.goodQualityColor
                              : _isLoading
                                  ? AppTheme.crackedColor
                                  : AppTheme.rottenColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _modelLoaded
                                            ? AppTheme.goodQualityColor
                                            : AppTheme.crackedColor),
                                  ),
                                )
                              : Icon(
                                  _modelLoaded
                                      ? Icons.check_circle
                                      : Icons.warning_amber_rounded,
                                  color: _modelLoaded
                                      ? AppTheme.goodQualityColor
                                      : AppTheme.rottenColor,
                                  size: 20,
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _modelStatus,
                              style: TextStyle(
                                fontSize: 14,
                                color: _modelLoaded
                                    ? AppTheme.goodQualityColor
                                    : AppTheme.rottenColor,
                              ),
                            ),
                          ),
                          if (!_modelLoaded && !_isLoading)
                            TextButton(
                              onPressed: _checkModelStatus,
                              child: Text(
                                'Réessayer',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Carte "Analyser une prune"
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Analyser une prune',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Obtenez des résultats instantanés sur la qualité de vos prunes',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _takePicture,
                                    icon: Icon(Icons.camera_alt),
                                    label: Text(context.tr('takePhoto')),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: Icon(Icons.photo_library),
                                    label:
                                        Text(context.tr('chooseFromGallery')),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Titre Catégories
                    Text(
                      'Catégories de prunes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Catégories de prunes
                    _buildCategoriesSection(context),

                    const SizedBox(height: 30),

                    // Conseils et astuces avec icône d'ampoule
                    _buildTipsCard(context),

                    const SizedBox(height: 30),

                    // À propos du projet
                    _buildAboutCard(context),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {
        'name': context.tr('goodQuality'),
        'color': AppTheme.goodQualityColor,
        'icon': Icons.check_circle,
        'description': 'Prunes parfaitement mûres et saines',
      },
      {
        'name': context.tr('unripe'),
        'color': AppTheme.unripeColor,
        'icon': Icons.access_time,
        'description': 'Prunes pas encore mûres',
      },
      {
        'name': context.tr('spotted'),
        'color': AppTheme.spottedColor,
        'icon': Icons.blur_circular,
        'description': 'Prunes avec des taches',
      },
      {
        'name': context.tr('cracked'),
        'color': AppTheme.crackedColor,
        'icon': Icons.broken_image,
        'description': 'Prunes avec des fissures',
      },
      {
        'name': context.tr('bruised'),
        'color': AppTheme.bruisedColor,
        'icon': Icons.healing,
        'description': 'Prunes meurtries',
      },
      {
        'name': context.tr('rotten'),
        'color': AppTheme.rottenColor,
        'icon': Icons.delete,
        'description': 'Prunes pourries',
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 140,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: (category['color'] as Color).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category['name'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    category['description'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.crackedColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.crackedColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Conseils d\'analyses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              context,
              'Éclairage optimal',
              'Prenez vos photos dans un environnement bien éclairé',
              Icons.wb_sunny_outlined,
            ),
            const SizedBox(height: 10),
            _buildTipItem(
              context,
              'Angle approprié',
              'Capturez la prune entière et évitez les ombres',
              Icons.camera_alt_outlined,
            ),
            const SizedBox(height: 10),
            _buildTipItem(
              context,
              'Arrière-plan neutre',
              'Utilisez un fond uni pour de meilleurs résultats',
              Icons.panorama_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
      BuildContext context, String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.accentColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'À propos du projet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Cette application a été développée dans le cadre du JCIA Hackathon 2025 au Cameroun pour le tri automatique des prunes en six catégories en utilisant l\'intelligence artificielle.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  size: 14,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(width: 5),
                Text(
                  'JCIA Hackathon 2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
