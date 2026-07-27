import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ministry/ministry_model.dart';

class WelcomeMessageWidget extends StatelessWidget {
  final WelcomeMessage message;
  const WelcomeMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: message.id.contains('ministry') ? const Color(0xFF0A3D62).withOpacity(0.5) : AppColors.primaryGold.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: message.id.contains('ministry') ? [const Color(0xFF0A3D62), const Color(0xFF079992)] : [AppColors.primaryGold, const Color(0xFFB8962E)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            CircleAvatar(radius: 22, backgroundColor: message.id.contains('ministry') ? Colors.white : AppColors.primaryBlack, child: Icon(message.id.contains('ministry') ? Icons.account_balance : Icons.palette, color: message.id.contains('ministry') ? const Color(0xFF0A3D62) : AppColors.primaryGold, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(message.title, style: GoogleFonts.playfairDisplay(fontSize: 12, fontWeight: FontWeight.bold, color: message.id.contains('ministry') ? Colors.white : AppColors.primaryBlack), maxLines: 2),
              Text("${message.authorName} • ${message.authorTitle}", style: GoogleFonts.poppins(fontSize: 9, color: message.id.contains('ministry') ? Colors.white.withOpacity(0.9) : AppColors.primaryBlack.withOpacity(0.8)), maxLines: 2),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: message.isActive ? AppColors.success : AppColors.error, borderRadius: BorderRadius.circular(6)), child: Text(message.isActive ? "Active" : "Archived", style: GoogleFonts.poppins(fontSize: 7, color: Colors.white))),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message.message, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite, height: 1.5), maxLines: 10, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Wrap(spacing: 6, children: message.tags.map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(t, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
          const SizedBox(height: 10),
          Row(children: [
            Text("${message.publishedAt.day}/${message.publishedAt.month}/${message.publishedAt.year} • Ministry Portal", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
            const Spacer(),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.play_circle, size: 14), label: const Text("Read Full", style: TextStyle(fontSize: 10)), style: TextButton.styleFrom(foregroundColor: AppColors.primaryGold)),
          ]),
        ])),
      ]),
    );
  }
}

class WelcomeMessageHomeSection extends StatelessWidget {
  const WelcomeMessageHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final welcome = WelcomeMessage.ministryWelcome();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A3D62), Color(0xFF079992)]), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.account_balance, color: Color(0xFF0A3D62))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(welcome.title, style: GoogleFonts.playfairDisplay(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1),
          Text("From ${welcome.authorName} • ${welcome.authorTitle}", style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9)), maxLines: 1),
          const SizedBox(height: 4),
          Text(welcome.message.substring(0, 120) + "...", style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withOpacity(0.9)), maxLines: 2, overflow: TextOverflow.ellipsis),
        ])),
        const SizedBox(width: 8),
        IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/ministryPortal')),
      ]),
    );
  }
}
