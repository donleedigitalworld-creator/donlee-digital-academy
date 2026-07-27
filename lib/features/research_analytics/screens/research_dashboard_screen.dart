import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/research/research_model.dart';
import '../../../widgets/custom_app_bar.dart';

class ResearchDashboardScreen extends StatefulWidget {
  const ResearchDashboardScreen({super.key});

  @override
  State<ResearchDashboardScreen> createState() => _ResearchDashboardScreenState();
}

class _ResearchDashboardScreenState extends State<ResearchDashboardScreen> {
  List<ResearchStudy> _studies = [];

  @override
  void initState() {
    super.initState();
    _studies = ResearchStudy.mockStudies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Research Analytics - Anonymized Data", subtitle: "Studies on art education effectiveness, data exports, ethics approval - Phase 6"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Privacy: Research uses anonymized data only - no PII, consent required, ethics approval, data sensitivity public/internal/confidential/restricted", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
          const SizedBox(height: 6),
          Text("• Data sources: anonymized progress, competition scores, offline queue, low-bandwidth usage, ai_feedback teacher_reviewed, student_scores - no names\n• Sensitivity: public (aggregated), internal (school-level), confidential (regional), restricted (individual - requires consent)\n• Ethics: ethics review → approved before data collection\n• Exports: JSON/CSV anonymized for researchers, encrypted", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        ])),
        const SizedBox(height: 20),
        Text("Active Research Studies", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._studies.map((study) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: study.hasEthicsApproval ? AppColors.success.withOpacity(0.3) : Colors.orangeAccent.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _statusColor(study.status).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(study.status.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _statusColor(study.status)))),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _sensitivityColor(study.sensitivity).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(study.sensitivity.name, style: GoogleFonts.poppins(fontSize: 8, color: _sensitivityColor(study.sensitivity)))),
            const SizedBox(width: 6),
            if (study.hasEthicsApproval) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.verified, size: 10, color: AppColors.success), const SizedBox(width: 2), Text("Ethics Approved", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.success))])),
          ]),
          const SizedBox(height: 8),
          Text(study.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text("${study.leadResearcher} • ${study.institution}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
          const SizedBox(height: 6),
          Text(study.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 8),
          Text("Data Sources: ${study.dataSources.join(', ')}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
          Text("Participants: ${study.participantsCount} • Started: ${study.startedAt.day}/${study.startedAt.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          const SizedBox(height: 8),
          Text("Findings:", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          ...study.findings.map((f) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 6), Expanded(child: Text(f, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.offWhite)))]))),
        ]))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Future Scalability - Research as Service", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("• Modular: Research service independent, provider injection, easy to extract to microservice with API versioning v5\n• Multi-tenant: Datasets sharded by region schoolId anonymized, tenant-aware rules\n• Feature flags: research_analytics toggled per role nationalAdmin/teacher/researcher\n• Offline: Research datasets downloadable for offline analysis, low-bandwidth compressed\n• AI: Research includes AI feedback effectiveness 73% adoption +12% score, ethics approval required, teacher-reviewed flag ensures quality\n• National: 45,892 students anonymized data for Ministry policy decisions, equity metrics", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
      ]),
    );
  }

  Color _statusColor(status) {
    switch (status) {
      case ResearchStatus.dataCollection: return Colors.blueAccent;
      case ResearchStatus.analysis: return Colors.purpleAccent;
      case ResearchStatus.published: return AppColors.success;
      default: return Colors.orangeAccent;
    }
  }

  Color _sensitivityColor(s) {
    switch (s) {
      case DataSensitivity.public: return AppColors.success;
      case DataSensitivity.internal: return Colors.blueAccent;
      case DataSensitivity.confidential: return Colors.orangeAccent;
      case DataSensitivity.restricted: return AppColors.error;
    }
  }
}
