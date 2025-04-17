// lib/utils/language_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode;

  LanguageProvider(this._languageCode);

  String get languageCode => _languageCode;

  // Traductions pour français et anglais
  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      // Écrans d'onboarding et d'authentification
      'welcome': 'Bienvenue',
      'continue': 'Continuer',
      'next': 'Suivant',
      'finish': 'Terminer',
      'login': 'Connexion',
      'register': 'Inscription',
      'firstName': 'Prénom',
      'lastName': 'Nom',
      'email': 'Email',
      'phone': 'Téléphone',
      'password': 'Mot de passe',
      'confirmPassword': 'Confirmer le mot de passe',
      'forgotPassword': 'Mot de passe oublié ?',
      'dontHaveAccount': 'Auncun compte ? Inscrivez-vous',
      'alreadyHaveAccount': 'Déjà un compte ?',

      // Écran principal
      'home': 'Accueil',
      'history': 'Historique',
      'profile': 'Profil',
      'settings': 'Paramètres',

      // Analyse des prunes
      'takePhoto': 'Prendre une photo',
      'chooseFromGallery': 'Choisir depuis la galerie',
      'analyzing': 'Analyse en cours...',
      'results': 'Résultats',

      // Catégories de prunes
      'goodQuality': 'Bonne qualité',
      'unripe': 'Non mûre',
      'spotted': 'Tachetée',
      'cracked': 'Fissurée',
      'bruised': 'Meurtrie',
      'rotten': 'Pourrie',

      // Conseils pour chaque catégorie
      'goodQualityAdvice':
          'Cette prune est de bonne qualité et prête à être consommée.',
      'unripeAdvice':
          'Cette prune n\'est pas encore mûre. Attendez quelques jours avant de la consommer.',
      'spottedAdvice':
          'Cette prune présente des taches. Elle reste comestible mais moins appétissante.',
      'crackedAdvice':
          'Cette prune est fissurée, consommez-la rapidement pour éviter qu\'elle ne se détériore davantage.',
      'bruisedAdvice':
          'Cette prune est meurtrie, elle peut être utilisée pour des compotes ou des confitures.',
      'rottenAdvice':
          'Cette prune est pourrie et ne devrait pas être consommée.',

      // Paramètres
      'darkMode': 'Mode sombre',
      'language': 'Langue',
      'french': 'Français',
      'english': 'Anglais',
      'shareApp': 'Partager l\'application',
      'help': 'Aide',
      'logout': 'Déconnexion',
      'qrCode': 'Code QR',
      'scanQrCodeToDownload':
          'Scannez ce code QR pour télécharger l\'application',

      // Profil utilisateur
      'editProfile': 'Modifier le profil',
      'saveChanges': 'Enregistrer les modifications',
      'changePassword': 'Changer le mot de passe',
      'currentPassword': 'Mot de passe actuel',
      'newPassword': 'Nouveau mot de passe',
      'deleteAccount': 'Supprimer le compte',

      // Messages
      'success': 'Succès',
      'error': 'Erreur',
      'confirmAction': 'Confirmer l\'action',
      'cancel': 'Annuler',
      'loading': 'Chargement...',
      'noResults': 'Aucun résultat',
      'noHistory': 'Aucun historique disponible',
      'passwordsDontMatch': 'Les mots de passe ne correspondent pas',
      'fieldRequired': 'Ce champ est requis',
      'invalidEmail': 'Email invalide',

      // Écran d'aide
      'howToUse': 'Comment utiliser',
      'aboutApp': 'À propos',
      'termsOfService': 'Conditions d\'utilisation',
      'privacyPolicy': 'Politique de confidentialité',
      'contactUs': 'Contactez-nous',
      'version': 'Version',
    },
    'en': {
      // Onboarding and authentication screens
      'welcome': 'Welcome',
      'continue': 'Continue',
      'next': 'Next',
      'finish': 'Finish',
      'login': 'Login',
      'register': 'Register',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'email': 'Email',
      'phone': 'Phone',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': 'Don\'t have an account? Sign up',
      'alreadyHaveAccount': 'Already have an account? Log in',

      // Main screen
      'home': 'Home',
      'history': 'History',
      'profile': 'Profile',
      'settings': 'Settings',

      // Plum analysis
      'takePhoto': 'Take a Photo',
      'chooseFromGallery': 'Choose from Gallery',
      'analyzing': 'Analyzing...',
      'results': 'Results',

      // Plum categories
      'goodQuality': 'Good Quality',
      'unripe': 'Unripe',
      'spotted': 'Spotted',
      'cracked': 'Cracked',
      'bruised': 'Bruised',
      'rotten': 'Rotten',

      // Advice for each category
      'goodQualityAdvice':
          'This plum is of good quality and ready to be consumed.',
      'unripeAdvice':
          'This plum is not yet ripe. Wait a few days before consuming it.',
      'spottedAdvice':
          'This plum has spots. It remains edible but less appetizing.',
      'crackedAdvice':
          'This plum is cracked, consume it quickly to prevent further deterioration.',
      'bruisedAdvice':
          'This plum is bruised, it can be used for compotes or jams.',
      'rottenAdvice': 'This plum is rotten and should not be consumed.',

      // Settings
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'french': 'French',
      'english': 'English',
      'shareApp': 'Share App',
      'help': 'Help',
      'logout': 'Logout',
      'qrCode': 'QR Code',
      'scanQrCodeToDownload': 'Scan this QR code to download the app',

      // User profile
      'editProfile': 'Edit Profile',
      'saveChanges': 'Save Changes',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'deleteAccount': 'Delete Account',

      // Messages
      'success': 'Success',
      'error': 'Error',
      'confirmAction': 'Confirm Action',
      'cancel': 'Cancel',
      'loading': 'Loading...',
      'noResults': 'No Results',
      'noHistory': 'No history available',
      'passwordsDontMatch': 'Passwords don\'t match',
      'fieldRequired': 'This field is required',
      'invalidEmail': 'Invalid email',

      // Help screen
      'howToUse': 'How to Use',
      'aboutApp': 'About the App',
      'termsOfService': 'Terms of Service',
      'privacyPolicy': 'Privacy Policy',
      'contactUs': 'Contact Us',
      'version': 'Version',
    },
  };

  String translate(String key) {
    return _localizedValues[_languageCode]?[key] ?? key;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != _languageCode &&
        (_localizedValues.containsKey(languageCode))) {
      _languageCode = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
      notifyListeners();
    }
  }
}

// Extension pour faciliter l'accès aux traductions
extension TranslateExtension on BuildContext {
  String tr(String key) {
    return Provider.of<LanguageProvider>(this, listen: false).translate(key);
  }
}
