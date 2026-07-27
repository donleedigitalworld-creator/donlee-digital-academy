import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/scholarship/scholarship_model.dart';
import '../../../widgets/custom_app_bar.dart';

class ScholarshipCenterScreen extends StatefulWidget {
  const ScholarshipCenterScreen({super.key});

  @override
  State<ScholarshipCenterScreen> createState() => _ScholarshipCenterScreenState();
}

class _ScholarshipCenterScreenState extends State<ScholarshipCenterScreen> {
  List<ScholarshipProgram> _programs = [];

  @override
  void initState() {
    super.initState();
    setState(() => _programs = ScholarshipProgram.mock());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Scholarship & Opportunity Center", subtitle: "Application, eligibility checker, docs upload, recommendations, disbursement - Phase 6"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purpleAccent.withOpacity(0.2), Colors.purpleAccent.withOpacity(0.05)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.purpleAccent.withOpacity(0.2))), child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.school, color: Colors.purpleAccent)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Scholarships Linked to National Competition", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            Text("Top 3 + exhibition selected auto-eligible fast-track. Eligibility checker, document upload, recommendation letters, disbursement status tracking.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
        ])),
        const SizedBox(height: 20),
        ..._programs.map((prog) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: prog.isForCompetitionWinners ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _typeColor(prog.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(prog.type.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _typeColor(prog.type)))),
            const SizedBox(width: 6),
            if (prog.isForCompetitionWinners) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.emoji_events, size: 10, color: AppColors.primaryGold), const SizedBox(width: 2), Text("National Winners", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.primaryGold))])),
            const Spacer(),
            Text("${prog.appliedCount}/${prog.availableSlots} applied • Deadline ${prog.deadline.day}/${prog.deadline.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          ]),
          const SizedBox(height: 8),
          Text(prog.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text("${prog.organization} • ${prog.currency} ${prog.amount.toInt()}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
          const SizedBox(height: 6),
          Text(prog.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 3),
          const SizedBox(height: 10),
          Text("Eligibility:", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          ...prog.eligibilityCriteria.map((e) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 6), Expanded(child: Text(e, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))]))),
          const SizedBox(height: 8),
          Text("Required Docs: ${prog.requiredDocuments.join(', ')}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Eligibility Check", style: TextStyle(fontSize: 10)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Apply Now", style: TextStyle(fontSize: 10)))),
          ]),
        ]))),
      ]),
    );
  }

  Color _typeColor(type) {
    switch (type) {
      case ScholarshipType.full: return Colors.purpleAccent;
      case ScholarshipType.grant: return AppColors.primaryGold;
      default: return Colors.blueAccent;
    }
  }
}
