import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlack,
      leading: leading ?? (showBack ? IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryGold), onPressed: () => Navigator.pop(context)) : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold, fontWeight: FontWeight.w400),
            ),
        ],
      ),
      actions: actions,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.primaryGold.withOpacity(0.2)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 70 : 60);
}
