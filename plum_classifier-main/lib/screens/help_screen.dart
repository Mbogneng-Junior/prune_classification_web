// lib/screens/help_screen.dart

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/language_provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('help')),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              context,
              title: context.tr('howToUse'),
              icon: Icons.help_outline,
              content: _buildHowToUseContent(context),
            ),
            
            const SizedBox(height: 24),
            
            _buildHelpSection(
              context,
              title: context.tr('aboutApp'),
              icon: Icons.info_outline,
              content: _buildAboutAppContent(context),
            ),
            
            const SizedBox(height: 24),
            
            _buildHelpSection(
              context,
              title: 'Catégories',
              icon: Icons.category_outlined,
              content: _buildCategoriesContent(context),
            ),
            
            const SizedBox(height: 24),
            
            _buildHelpSection(
              context,
              title: context.tr('contactUs'),
              icon: Icons.contact_support_outlined,
              content: _buildContactContent(context),
            ),
            
            const SizedBox(height: 40),
            
            // Termes et conditions
            Center(
              child: TextButton(
                onPressed: () {
                  _showTermsDialog(context);
                },
                child: Text(
                  context.tr('termsOfService'),
                  style: TextStyle(
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
            ),
            
            // Politique de confidentialité
            Center(
              child: TextButton(
                onPressed: () {
                  _showPrivacyDialog(context);
                },
                child: Text(
                  context.tr('privacyPolicy'),
                  style: TextStyle(
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Version de l'application
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
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
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep(
          context,
          number: '1',
          title: 'Analyser une prune',
          description: 'Depuis l\'écran d\'accueil, choisissez "Prendre une photo" pour photographier une prune ou "Choisir depuis la galerie" pour utiliser une image existante.',
        ),
        _buildStep(
          context,
          number: '2',
          title: 'Pendant l\'analyse',
          description: 'Attendez quelques secondes que notre modèle IA analyse votre image et classifie la prune.',
        ),
        _buildStep(
          context,
          number: '3',
          title: 'Consulter les résultats',
          description: 'Vous verrez la catégorie de votre prune (bonne qualité, non mûre, tachetée, etc.) ainsi que des conseils adaptés.',
        ),
        _buildStep(
          context,
          number: '4',
          title: 'Accéder à l\'historique',
          description: 'Retrouvez toutes vos analyses précédentes dans l\'onglet "Historique".',
        ),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutAppContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'L\'application Tri Automatique des Prunes a été développée dans le cadre du JCIA Hackathon 2025 au Cameroun.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Cette application utilise l\'intelligence artificielle pour classifier automatiquement les prunes en six catégories : bonne qualité, non mûre, tachetée, fissurée, meurtrie et pourrie.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Notre modèle a été entraîné sur le dataset "African Plums" disponible sur Kaggle, avec des techniques avancées de vision par ordinateur et d\'apprentissage profond.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(
          context,
          title: 'Bonne qualité',
          color: AppTheme.goodQualityColor,
          description: 'Prune parfaitement mûre et sans défaut, idéale pour la consommation immédiate.',
        ),
        _buildCategory(
          context,
          title: 'Non mûre',
          color: AppTheme.unripeColor,
          description: 'Prune qui n\'a pas encore atteint sa maturité optimale, nécessite quelques jours pour mûrir.',
        ),
        _buildCategory(
          context,
          title: 'Tachetée',
          color: AppTheme.spottedColor,
          description: 'Prune présentant des taches sur sa peau, généralement comestible mais moins esthétique.',
        ),
        _buildCategory(
          context,
          title: 'Fissurée',
          color: AppTheme.crackedColor,
          description: 'Prune présentant des fissures dans sa peau, à consommer rapidement.',
        ),
        _buildCategory(
          context,
          title: 'Meurtrie',
          color: AppTheme.bruisedColor,
          description: 'Prune ayant subi des chocs, idéale pour la préparation de compotes ou confitures.',
        ),
        _buildCategory(
          context,
          title: 'Pourrie',
          color: AppTheme.rottenColor,
          description: 'Prune en décomposition, non comestible et à jeter.',
        ),
      ],
    );
  }

  Widget _buildCategory(
    BuildContext context, {
    required String title,
    required Color color,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pour toute question ou suggestion concernant l\'application, vous pouvez nous contacter :',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              size: 20,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              'contact@plumclassifier.com',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.language,
              size: 20,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              'www.plumclassifier.com',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              size: 20,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              '+237 650 970 526',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('termsOfService')),
          content: SingleChildScrollView(
            child: Text(
              'En utilisant cette application, vous acceptez les conditions d\'utilisation suivantes :\n\n'
              '1. L\'application est fournie "telle quelle" sans garantie d\'aucune sorte.\n\n'
              '2. Les résultats d\'analyse sont fournis à titre indicatif seulement.\n\n'
              '3. Nous ne sommes pas responsables des décisions prises sur la base des résultats fournis par l\'application.\n\n'
              '4. Vous acceptez de ne pas utiliser l\'application à des fins illégales.\n\n'
              '5. Nous nous réservons le droit de modifier ces conditions à tout moment.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('privacyPolicy')),
          content: SingleChildScrollView(
            child: Text(
              'Protection des données :\n\n'
              '1. Nous collectons uniquement les données nécessaires au fonctionnement de l\'application.\n\n'
              '2. Les images des prunes que vous analysez sont stockées localement sur votre appareil.\n\n'
              '3. Vos informations personnelles ne sont pas partagées avec des tiers.\n\n'
              '4. Vous pouvez demander la suppression de toutes vos données en supprimant votre compte.\n\n'
              '5. Nous utilisons des cookies et des technologies similaires pour améliorer votre expérience.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}