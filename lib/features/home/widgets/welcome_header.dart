import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final double overallProgress;
  const WelcomeHeader({super.key, required this.userName, required this.overallProgress});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getGreeting(), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryGold, fontWeight: FontWeight.w500, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(userName, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 6),
                Text("Ready to create something amazing today?", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60, height: 60,
                child: CircularProgressIndicator(value: overallProgress, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, strokeWidth: 4),
              ),
              Text("${(overallProgress * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            ],
          ),
        ],
      ),
    );
  }
}
