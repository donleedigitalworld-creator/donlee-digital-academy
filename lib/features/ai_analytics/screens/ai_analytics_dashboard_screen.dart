import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_analytics_service.dart';
import '../../../widgets/custom_app_bar.dart';

class AIAnalyticsDashboardScreen extends StatefulWidget {
  const AIAnalyticsDashboardScreen({super.key});

  @override
  State<AIAnalyticsDashboardScreen> createState() => _AIAnalyticsDashboardScreenState();
}

class _AIAnalyticsDashboardScreenState extends State<AIAnalyticsDashboardScreen> {
  final AIAnalyticsService _service = AIAnalyticsService();
  List<AIAnalyticsInsight> _insights = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final data = await _service.generateStudentInsights(studentId: 'student1', moduleProgress: {'intro_fine_art': 1.0, 'elements_of_art': 0.82, 'facial_drawing': 0.65, 'perspective': 0.3}, lessonsCompleted: 18, artworks: 12, recentSubmissions: [], quizResults: []);
    setState(() {
      _insights = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "AI Analytics - Learning Trends", subtitle: "Engagement, weakness, strength, predictions - privacy safeguarded", showBack: true),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Expanded(child: Text("Privacy: Analytics uses encrypted progress, consent required. Teacher sees anonymized class trends, not private chats unless you share. Low-bandwidth compresses analytics data. No training without Data Collection consent.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight)))])),
        const SizedBox(height: 16),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6, children: [
          _metricCard("Avg Completion", "68%", "+5% vs last month • Offline 2.3 queue", AppColors.primaryGold, 0.68),
          _metricCard("Camera Verified", "73%", "27% gallery • Low-BW saves 60%", AppColors.success, 0.73),
          _metricCard("At-Risk Students", "2 of 12", "Below 40% • Joined attention list", AppColors.error, 0.2),
          _metricCard("Competition Readiness", "78%", "Predicts 88% by deadline if plan followed", Colors.purpleAccent, 0.78),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Progress Over Time - AI Trend Prediction", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: LineChart(LineChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.primaryBlackLighter, strokeWidth: 1)),
            titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) => Text(['W1', 'W2', 'W3', 'W4', 'W5'][v.toInt() % 5], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))))),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(spots: [const FlSpot(0, 30), const FlSpot(1, 45), const FlSpot(2, 55), const FlSpot(3, 62), const FlSpot(4, 68)], isCurved: true, color: AppColors.primaryGold, barWidth: 3, dotData: FlDotData(show: true)),
              LineChartBarData(spots: [const FlSpot(3, 62), const FlSpot(4, 68), const FlSpot(5, 78), const FlSpot(6, 88)], isCurved: true, color: Colors.purpleAccent.withOpacity(0.5), barWidth: 2, dashArray: [5, 5], dotData: FlDotData(show: false)),
            ],
          ))),
          const SizedBox(height: 8),
          Row(children: [Container(width: 12, height: 3, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Actual", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)), const SizedBox(width: 12), Container(width: 12, height: 3, color: Colors.purpleAccent.withOpacity(0.5)), const SizedBox(width: 6), Text("AI Predicted if plan followed", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]),
        ])),
        const SizedBox(height: 20),
        Text("AI Insights - Personalized", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._insights.map((ins) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: _insightColor(ins.type).withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: _insightColor(ins.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_insightIcon(ins.type), size: 16, color: _insightColor(ins.type))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ins.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Text("${ins.type.toUpperCase()} • Confidence ${(ins.confidence * 100).toInt()}% • ${ins.generatedAt.day}/${ins.generatedAt.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: _insightColor(ins.type).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(ins.type, style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _insightColor(ins.type)))),
          ]),
          const SizedBox(height: 10),
          Text(ins.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.4)),
          const SizedBox(height: 10),
          Text("Recommendations:", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 4),
          ...ins.recommendations.map((r) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: const EdgeInsets.only(top: 4), width: 4, height: 4, decoration: BoxDecoration(color: _insightColor(ins.type), shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(r, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.offWhite)))]))),
        ]))),
      ]),
    );
  }

  Widget _metricCard(String label, String value, String sub, Color color, double progress) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.auto_awesome, size: 14, color: color)), Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
      const SizedBox(height: 8),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
      Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), maxLines: 2),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.primaryBlackLighter, color: color, minHeight: 4)),
    ]));
  }

  Color _insightColor(String type) {
    switch (type) {
      case 'weakness': return Colors.orangeAccent;
      case 'strength': return AppColors.success;
      case 'engagement': return Colors.blueAccent;
      case 'prediction': return Colors.purpleAccent;
      case 'trend': return AppColors.primaryGold;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _insightIcon(String type) {
    switch (type) {
      case 'weakness': return Icons.trending_down;
      case 'strength': return Icons.star;
      case 'engagement': return Icons.favorite;
      case 'prediction': return Icons.insights;
      default: return Icons.lightbulb;
    }
  }
}
