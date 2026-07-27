import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/partnership/partnership_model.dart';
import '../../../services/partnership/partnership_service.dart';
import '../../../widgets/custom_app_bar.dart';

class PartnershipsPortalScreen extends StatefulWidget {
  const PartnershipsPortalScreen({super.key});

  @override
  State<PartnershipsPortalScreen> createState() => _PartnershipsPortalScreenState();
}

class _PartnershipsPortalScreenState extends State<PartnershipsPortalScreen> {
  final PartnershipService _service = PartnershipService();
  List<Sponsor> _sponsors = [];
  List<SponsoredEvent> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sponsors = await _service.getSponsors();
    final events = await _service.getSponsoredEvents();
    setState(() {
      _sponsors = sponsors;
      _events = events;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Partnerships Portal for Sponsors", subtitle: "Sponsor profiles, packages, impact metrics, CSR reporting - Phase 6"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [
          const Icon(Icons.handshake, color: AppColors.primaryBlack, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Sponsors Powering National Art Education", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
            Text("${_sponsors.length} active sponsors • ₦${_sponsors.fold(0.0, (p, s) => p + s.totalContribution).toInt()} total contribution • 45k students reached", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.8))),
          ])),
        ])),
        const SizedBox(height: 20),
        Text("Our Sponsors - Tiered Packages", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._sponsors.map((s) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: _tierColor(s.tier).withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: _tierColor(s.tier).withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(s.name[0], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: _tierColor(s.tier))))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Text("${s.tier.name.toUpperCase()} • ${s.status.name} • ${s.currency} ${s.totalContribution.toInt()} • ${s.partnershipStart.day}/${s.partnershipStart.month} - ${s.partnershipEnd.day}/${s.partnershipEnd.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _tierColor(s.tier), borderRadius: BorderRadius.circular(8)), child: Text(s.tier.name, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
          const SizedBox(height: 8),
          Text(s.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 8),
          Text("Contact: ${s.contactEmail} • ${s.website ?? ''}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ]))),
        const SizedBox(height: 20),
        Text("Sponsored Events - CSR & Impact", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._events.map((e) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(e.sponsorName, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
            const Spacer(),
            Text("${e.date.day}/${e.date.month} • Reach ${e.expectedReach}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
            if (e.isNationalCompetition) Container(margin: const EdgeInsets.only(left: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("National Comp", style: GoogleFonts.poppins(fontSize: 8, color: Colors.purpleAccent))),
          ]),
          const SizedBox(height: 8),
          Text(e.eventTitle, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text(e.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 6),
          Text("Branding: ${e.branding.entries.map((en) => "${en.key}:${en.value}").join(', ')}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ]))),
      ]),
    );
  }

  Color _tierColor(tier) {
    switch (tier) {
      case SponsorshipTier.title: return const Color(0xFF0A3D62);
      case SponsorshipTier.platinum: return Colors.grey;
      case SponsorshipTier.gold: return AppColors.primaryGold;
      case SponsorshipTier.silver: return Colors.blueGrey;
      default: return Colors.brown;
    }
  }
}
