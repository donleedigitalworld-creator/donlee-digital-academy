import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/partnership/partnership_model.dart';
import '../../../services/partnership/partnership_service.dart';
import '../../../widgets/custom_app_bar.dart';

class SponsorDashboardScreen extends StatefulWidget {
  const SponsorDashboardScreen({super.key});

  @override
  State<SponsorDashboardScreen> createState() => _SponsorDashboardScreenState();
}

class _SponsorDashboardScreenState extends State<SponsorDashboardScreen> {
  final PartnershipService _service = PartnershipService();
  Sponsor? _sponsor;
  ImpactMetric? _impact;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sponsors = await _service.getSponsors();
    final impactList = await _service.getImpactMetrics(sponsors.first.id);
    setState(() {
      _sponsor = sponsors.first;
      _impact = impactList.first;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Sponsor Dashboard - CSR & Impact", subtitle: "Branding, reach, offline kits, scholarships, brand visibility score - Phase 6"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primaryBlack, borderRadius: BorderRadius.circular(16)), child: Center(child: Text(_sponsor!.name[0], style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryGold)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_sponsor!.name, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
            Text("${_sponsor!.tier.name.toUpperCase()} Sponsor • ${ _sponsor!.status.name} • ${ _sponsor!.currency} ${_sponsor!.totalContribution.toInt()}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryBlack.withOpacity(0.8))),
            Text(_sponsor!.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.7)), maxLines: 2),
          ])),
        ])),
        const SizedBox(height: 20),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.4, children: [
          _impactCard("Students Reached", "${_impact!.studentsReached}", Icons.people, AppColors.primaryGold),
          _impactCard("Schools Reached", "${_impact!.schoolsReached}", Icons.school, Colors.blueAccent),
          _impactCard("Artworks Created", "${_impact!.artworksCreated}", Icons.palette, Colors.purpleAccent),
          _impactCard("Offline Kits", "${_impact!.offlineKitsDistributed}", Icons.wifi_off, Colors.orangeAccent),
          _impactCard("Scholarships", "${_impact!.scholarshipsAwarded}", Icons.school_outlined, AppColors.success),
          _impactCard("Brand Visibility", "${_impact!.brandVisibilityScore}/10", Icons.visibility, AppColors.primaryGold),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("CSR Reporting - Future Scalability", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          Text("• Branding: Logo placement Cover, Certificates, Exhibition, App splash for Title sponsors, 45k students reach\n• Offline kits: 2,340 kits distributed to North-East 68% offline adoption areas, low-bandwidth optimized\n• Scholarships: 50 awarded, linked to national competition Top 3 + exhibition selected auto-eligible, fast-track\n• Artworks: 12,456 created from sponsored competitions, exhibition at Nike Art Gallery\n• Schools: 1,247 reached, state coverage 92% target 100% 36 states + FCT\n• Brand visibility score 8.9/10 based on certificate QR scans, app opens, exhibition footfall\n• Future: Flutterwave/Paystack integration for sponsor payments, automated CSR PDF reports", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _impactCard(String label, String value, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(height: 6),
      Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      Text(label, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), textAlign: TextAlign.center),
    ]));
  }
}
