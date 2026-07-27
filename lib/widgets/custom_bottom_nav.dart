import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlackLight,
        border: Border(top: BorderSide(color: AppColors.primaryGold.withOpacity(0.2))),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.primaryBlackLight,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.mediumGrey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 9),
        unselectedLabelStyle: const TextStyle(fontSize: 8),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.public_rounded), label: 'National'), // Phase 5 center = National Dashboard
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books_rounded), label: 'Resources'),
        ],
      ),
    );
  }
}
