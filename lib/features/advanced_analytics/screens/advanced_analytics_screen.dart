import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';

class AdvancedAnalyticsScreen extends StatelessWidget {
  const AdvancedAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Advanced Analytics - National Intelligence", subtitle: "Predictive, regional, equity, AI, offline, low-bandwidth", showBack: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6, children: [
          _metric("Completion Prediction", "78% → 89%", "If 10 min daily perspective", AppColors.primaryGold, 0.78),
          _metric("Dropout Risk", "2 students high", "Below 40% + no offline queue", AppColors.error, 0.15),
          _metric("Regional Equity Gap", "NW 58% vs SW 74%", "Target reduce to 10% gap", Colors.orangeAccent, 0.58),
          _metric("AI Impact", "+12% score", "Students using AI feedback", Colors.purpleAccent, 0.73),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("National Trends - Completion by Region (AI Predicted)", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: BarChart(BarChartData(
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 74, color: AppColors.primaryGold, width: 12)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 71, color: AppColors.primaryGold, width: 12)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 62, color: Colors.orangeAccent, width: 12)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 58, color: AppColors.error, width: 12)]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 69, color: AppColors.primaryGold, width: 12)]),
              BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 54, color: AppColors.error, width: 12)]),
            ],
            titlesData: FlTitlesData(bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text(['SW', 'SE', 'NC', 'NW', 'SS', 'NE'][v.toInt()], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))))),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ))),
        ])),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Predictive Analytics - Future Scalability", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("• Dropout Risk: AI predicts 2 students high risk (below 40% + no offline queue + no parental consent) - trigger parent notification + teacher intervention\n• Competition Success: 78% readiness → 89% if study plan followed, scholarship eligible if top 3\n• Regional Equity: North-West 58% vs South-West 74% - 16% gap, target 10% via offline + low-bandwidth + teacher training\n• AI Adoption: 73% using tutor/feedback - correlates +12% score improvement - privacy consent 92%\n• Offline: 41% adoption, rural 68%, North-East 68% offline queue avg 2.3 - smart sync prevents duplicate\n• Resource Library: CDN hit rate 89%, offline downloadable 34% students, low-BW saves 60% data", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _metric(String label, String value, String sub, Color color, double progress) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
      const SizedBox(height: 6),
      Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 4),
      Text(sub, style: GoogleFonts.poppins(fontSize: 9, color: color)),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.primaryBlackLighter, color: color, minHeight: 4)),
    ]));
  }
}
