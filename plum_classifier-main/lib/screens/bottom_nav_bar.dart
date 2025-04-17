// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/language_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            items: [
              _buildNavItem(
                context,
                Icons.home_outlined,
                Icons.home,
                context.tr('home'),
                0,
              ),
              _buildNavItem(
                context,
                Icons.history_outlined,
                Icons.history,
                context.tr('history'),
                1,
              ),
              _buildNavItem(
                context,
                Icons.person_outline,
                Icons.person,
                context.tr('profile'),
                2,
              ),
              _buildNavItem(
                context,
                Icons.settings_outlined,
                Icons.settings,
                context.tr('settings'),
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(
            currentIndex == index ? selectedIcon : unselectedIcon,
            size: 24,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            width: currentIndex == index ? 20 : 0,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}