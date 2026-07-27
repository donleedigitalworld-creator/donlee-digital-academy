import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/teacher_pd/teacher_pd_model.dart';
import '../../../services/teacher_pd/teacher_pd_service.dart';
import '../../../widgets/custom_app_bar.dart';

class TeacherPDCenterScreen extends StatefulWidget {
  const TeacherPDCenterScreen({super.key});

  @override
  State<TeacherPDCenterScreen> createState() => _TeacherPDCenterScreenState();
}

class _TeacherPDCenterScreenState extends State<TeacherPDCenterScreen> {
  final TeacherPDService _service = TeacherPDService();
  List<TeacherPDCourse> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final courses = await _service.getCourses();
    setState(() {
      _courses = courses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Teacher Professional Development Center", subtitle: "CPD tracking, mentorship, AI tools mastery, offline teaching - Phase 6"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [
          const Icon(Icons.school, color: AppColors.primaryBlack, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("CPD Tracking - 10 Hours Completed", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
            Text("Bronze → Silver → Gold → Master certification levels • Peer mentoring • Resource sharing", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.8))),
          ])),
        ])),
        const SizedBox(height: 20),
        Text("Professional Development Courses", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._courses.map((course) => Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(course.thumbnailUrl ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800', height: 120, width: double.infinity, fit: BoxFit.cover)),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _typeColor(course.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(course.type.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _typeColor(course.type)))),
              const Spacer(),
              Text("${course.durationHours}h • ${course.enrolledCount} enrolled", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            ]),
            const SizedBox(height: 8),
            Text(course.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text(course.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
            const SizedBox(height: 10),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: course.progress, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("${(course.progress * 100).toInt()}% completed", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
              Row(children: [const Icon(Icons.star, size: 10, color: AppColors.primaryGold), Text(" ${course.rating}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))]),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: course.modules.take(3).map((m) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(m, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
          ])),
        ]))),
      ]),
    );
  }

  Color _typeColor(type) {
    switch (type) {
      case PDCourseType.artMastery: return AppColors.primaryGold;
      case PDCourseType.aiTools: return Colors.purpleAccent;
      case PDCourseType.offlineTeaching: return Colors.orangeAccent;
      case PDCourseType.inclusiveEd: return AppColors.success;
      default: return Colors.blueAccent;
    }
  }
}
