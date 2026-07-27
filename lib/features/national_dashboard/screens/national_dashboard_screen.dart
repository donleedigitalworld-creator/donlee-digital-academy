import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/national/national_dashboard_model.dart';
import '../../../services/national/national_dashboard_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../core/offline/offline_banner.dart';

class NationalDashboardScreen extends StatefulWidget {
  const NationalDashboardScreen({super.key});

  @override
  State<NationalDashboardScreen> createState() => _NationalDashboardScreenState();
}

class _NationalDashboardScreenState extends State<NationalDashboardScreen> {
  final NationalDashboardService _service = NationalDashboardService();
  NationalStats? _stats;
  List<EquityMetric> _equity = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stats = await _service.getNationalStats();
    final equity = await _service.getEquityMetrics();
    setState(() {
      _stats = stats;
      _equity = equity;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "National Education Dashboard", subtitle: "Ministry Overview - 36 states + FCT • 1,247 schools • 45k students"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : Column(children: [
        const OfflineBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Top national cards
              GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.5, children: [
                _statCard("Schools", "${_stats!.totalSchools}", Icons.school, AppColors.primaryGold, "↑ 12% YoY"),
                _statCard("Students", "${_stats!.totalStudents}", Icons.people, Colors.blueAccent, "45.9k active"),
                _statCard("Teachers", "${_stats!.totalTeachers}", Icons.person, AppColors.success, "3 pending verify"),
                _statCard("Parents", "${_stats!.totalParents}", Icons.family_restroom, Colors.orangeAccent, "Parental consent 92%"),
                _statCard("Competitions", "${_stats!.totalCompetitions}", Icons.emoji_events, Colors.purpleAccent, "${_stats!.totalSubmissions} submissions"),
                _statCard("Certificates", "${_stats!.totalCertificates}", Icons.workspace_premium, AppColors.primaryGold, "QR verifiable"),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _rateCard("National Completion", _stats!.nationalCompletionRate, "Avg across 10 modules", AppColors.primaryGold)),
                const SizedBox(width: 12),
                Expanded(child: _rateCard("Offline Adoption", _stats!.offlineAdoptionRate, "Low-connectivity areas", Colors.orangeAccent)),
                const SizedBox(width: 12),
                Expanded(child: _rateCard("AI Adoption", _stats!.aiAdoptionRate, "Tutor + Feedback", Colors.purpleAccent)),
              ]),
              const SizedBox(height: 20),
              // Regional map bars
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Regional Breakdown - 6 Geo-Political Zones", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 16),
                ..._stats!.regionalStats.entries.map((entry) {
                  final region = entry.value;
                  return Padding(padding: const EdgeInsets.only(bottom: 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(region.region.name.replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                      Text("${region.totalSchools} schools • ${region.totalStudents} students • ${region.competitionEntries} comp entries", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: region.avgCompletionRate, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6))),
                      const SizedBox(width: 8),
                      Text("${(region.avgCompletionRate * 100).toInt()}% completion", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold)),
                      const SizedBox(width: 8),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Offline ${(region.offlineUsageRate * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 8, color: Colors.orangeAccent))),
                    ]),
                    const SizedBox(height: 4),
                    Wrap(spacing: 6, children: region.stateBreakdown.entries.take(3).map((e) => Text("${e.key}: ${e.value}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey))).toList()),
                  ]));
                }),
              ])),
              const SizedBox(height: 20),
              Text("Equity & Inclusion Metrics - Future Scalability", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              ..._equity.map((metric) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: metric.currentValue < metric.targetValue ? Colors.orangeAccent.withOpacity(0.3) : AppColors.success.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(metric.label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: metric.currentValue >= metric.targetValue ? AppColors.success.withOpacity(0.15) : Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("${(metric.currentValue * 100).toInt()}% / Target ${(metric.targetValue * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: metric.currentValue >= metric.targetValue ? AppColors.success : Colors.orangeAccent))),
                ]),
                const SizedBox(height: 6),
                Text(metric.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: metric.currentValue / metric.targetValue, backgroundColor: AppColors.primaryBlackLighter, color: metric.currentValue >= metric.targetValue ? AppColors.success : AppColors.primaryGold, minHeight: 6)),
                const SizedBox(height: 4),
                Text("National Avg: ${(metric.nationalAverage * 100).toInt()}% • Trend: +${(metric.currentValue - metric.trendData.firstOrNull?['value'] ?? 0) * 100}%", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
              ]))),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.rocket_launch, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Future Scalability - National Scale", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite))]),
                const SizedBox(height: 8),
                Text("• Multi-tenant: Schools isolated by schoolId, regional sharding by Region enum, tenant-aware Firestore rules\n• Feature Flags: national_dashboard, parent_portal, offline_mode, ai_tutor etc toggled per role via FeatureFlag model - nationalAdmin can enable for specific states\n• API Versioning: apiVersion v5, microservices ready, CDN hit rate 89% for resource library\n• Localization: 5 languages en/yo/ig/ha/fr via voice learning service, offline bundles\n• Auto-scaling: aiRequestsPerDay 12k, storage 234GB, activeNow 1.2k, offlineQueueAvg 2.3 - designed for 100k+ students\n• Equity focus: rural offline adoption 68%, accessibility usage 12% target 20%, female participation 48% near parity", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
              ])),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, String sub) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 14, color: color)), Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
      Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey)),
    ]));
  }

  Widget _rateCard(String label, double rate, String sub, Color color) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
      const SizedBox(height: 6),
      Text("${(rate * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: rate, backgroundColor: AppColors.primaryBlackLighter, color: color, minHeight: 4)),
      const SizedBox(height: 4),
      Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.darkGrey)),
    ]));
  }
}

extension FirstOrNull on List {
  dynamic get firstOrNull => isEmpty ? null : first;
}
