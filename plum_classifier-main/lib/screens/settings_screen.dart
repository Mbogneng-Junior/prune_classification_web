// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/theme.dart';
import '../utils/language_provider.dart';
import 'help_screen.dart';
import 'profile_screen.dart';
import '../utils/theme_provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('settings')),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Apparence
              _buildSectionHeader(context, 'Apparence'),
              const SizedBox(height: 16),
              
              // Mode sombre
              _buildSettingTile(
                context,
                icon: Icons.dark_mode,
                title: context.tr('darkMode'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              
              // Sélection de la langue
              _buildSettingTile(
                context,
                icon: Icons.language,
                title: context.tr('language'),
                trailing: DropdownButton<String>(
                  value: languageProvider.languageCode,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'fr',
                      child: Text(context.tr('french')),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(context.tr('english')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      languageProvider.changeLanguage(value);
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Section Partage
              _buildSectionHeader(context, 'Partage et téléchargement'),
              const SizedBox(height: 16),
              
              // Partager l'application
              _buildSettingTile(
                context,
                icon: Icons.share,
                title: context.tr('shareApp'),
                onTap: () {
                  Share.share(
                    'Découvrez l\'application Tri Automatique des Prunes ! Analysez vos prunes et obtenez des conseils adaptés. Téléchargez-la maintenant !',
                  );
                },
              ),
              
              // QR Code
              _buildSettingTile(
                context,
                icon: Icons.qr_code,
                title: context.tr('qrCode'),
                onTap: () {
                  _showQrCodeDialog(context);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Section Compte et Aide
              _buildSectionHeader(context, 'Compte et Aide'),
              const SizedBox(height: 16),
              
              // Profil
              _buildSettingTile(
                context,
                icon: Icons.person,
                title: context.tr('profile'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              
              // Aide
              _buildSettingTile(
                context,
                icon: Icons.help_outline,
                title: context.tr('help'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Section À propos
              _buildSectionHeader(context, 'À propos'),
              const SizedBox(height: 16),
              
              // Version de l'application
              _buildSettingTile(
                context,
                icon: Icons.info_outline,
                title: context.tr('version'),
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Hackathon
              _buildSettingTile(
                context,
                icon: Icons.event,
                title: 'JCIA Hackathon 2025',
                trailing: null,
              ),
              
              const SizedBox(height: 40),
              
              // Crédits
              Center(
                child: Column(
                  children: [
                    const Text(
                      '© 2025 Tri Automatique des Prunes',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Développé pour le JCIA Hackathon 2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('qrCode')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: 'https://example.com/download/plum-classifier',
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('scanQrCodeToDownload'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Share.share(
                  'Téléchargez l\'application Tri Automatique des Prunes : https://example.com/download/plum-classifier',
                );
              },
              child: Text(
                context.tr('shareApp'),
                style: TextStyle(
                  color: AppTheme.accentColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.tr('cancel')),
            ),
          ],
        );
      },
    );
  }
}