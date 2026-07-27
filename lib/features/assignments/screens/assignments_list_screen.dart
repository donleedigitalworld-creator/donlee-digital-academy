import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/assignment_model.dart';
import '../../../services/assignment_service.dart';
import '../../../widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class AssignmentsListScreen extends StatefulWidget {
  const AssignmentsListScreen({super.key});

  @override
  State<AssignmentsListScreen> createState() => _AssignmentsListScreenState();
}

class _AssignmentsListScreenState extends State<AssignmentsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final classId = auth.currentClassId ?? 'c1';
    final assignments = AssignmentService().getMockStudentAssignments(classId);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Assignments", subtitle: "Camera capture & gallery upload for drawings", showBack: true),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "Pending"), Tab(text: "Submitted"), Tab(text: "Graded")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          _buildList(assignments.where((a) => !a.isOverdue).toList(), false),
          _buildList([], true, emptyMsg: "No submissions yet - complete an assignment!"),
          _buildList([assignments.first], true, isGraded: true),
        ])),
      ]),
    );
  }

  Widget _buildList(List<AssignmentModel> list, bool isSubmittedList, {bool isGraded = false, String? emptyMsg}) {
    if (list.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(isSubmittedList ? Icons.task_alt : Icons.assignment_outlined, size: 60, color: AppColors.mediumGrey.withOpacity(0.5)), const SizedBox(height: 12), Text(emptyMsg ?? "No pending assignments 🎉", style: GoogleFonts.poppins(color: AppColors.mediumGrey))] ));
    }
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: list.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final a = list[i];
      return Container(
        decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: a.isOverdue ? AppColors.error.withOpacity(0.3) : AppColors.primaryBlackLighter)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Row(children: [Expanded(child: Text(a.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryWhite))), if (a.requireCameraPhoto) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.camera_alt, size: 10, color: AppColors.success), const SizedBox(width: 4), Text("CAMERA REQUIRED", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.success))])),
          ]),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 6),
            Text(a.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.person, size: 12, color: AppColors.primaryGold.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text(a.teacherName, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today, size: 12, color: a.isOverdue ? AppColors.error : AppColors.mediumGrey),
              const SizedBox(width: 4),
              Text(a.isOverdue ? "Overdue" : "${a.daysLeft} days left", style: GoogleFonts.poppins(fontSize: 10, color: a.isOverdue ? AppColors.error : AppColors.mediumGrey)),
              const Spacer(),
              if (isGraded) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("85/100", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success))),
            ]),
          ]),
          onTap: () => Navigator.pushNamed(context, '/assignmentDetail', arguments: a),
          trailing: isGraded ? const Icon(Icons.check_circle, color: AppColors.success) : Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.mediumGrey),
        ),
      );
    });
  }
}
