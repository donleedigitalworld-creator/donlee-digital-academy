import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryBlack, AppColors.primaryBlackLight],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryGold.withOpacity(0.5), blurRadius: 30, spreadRadius: 5),
                      ],
                    ),
                    child: const Icon(Icons.palette, size: 60, color: AppColors.primaryBlack),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    AppConstants.appName,
                    style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryWhite, letterSpacing: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Creative Art Academy",
                    style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.primaryGold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 16),
                  Container(width: 60, height: 2, color: AppColors.primaryGold),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      AppConstants.tagline,
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.mediumGrey, letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const CircularProgressIndicator(color: AppColors.primaryGold, strokeWidth: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
