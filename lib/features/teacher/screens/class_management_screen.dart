import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/school_model.dart';
import '../../../services/teacher_service.dart';
import '../../../services/school_service.dart';
import '../../../widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final TeacherService _teacherService = TeacherService();
  final SchoolService _schoolService = SchoolService();

  void _showCreateClassDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final scheduleCtrl = TextEditingController();
    String level = 'beginner';
    int maxStudents = 25;
    String selectedSchoolId = 's1';

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.cardBlack, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (c) => StatefulBuilder(builder: (context, setSB) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.mediumGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(4)))),
      const SizedBox(height: 16),
      Text("Create New Class", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 16),
      TextField(controller: nameCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Class Name *', hintText: 'e.g. JSS2 Art Club')),
      const SizedBox(height: 12),
      TextField(controller: descCtrl, maxLines: 2, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Description')),
      const SizedBox(height: 12),
      TextField(controller: scheduleCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Schedule', hintText: 'Mon & Wed 4pm')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(value: level, decoration: const InputDecoration(labelText: 'Level'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: ['beginner', 'intermediate', 'advanced'].map((l) => DropdownMenuItem(value: l, child: Text(l.toUpperCase()))).toList(), onChanged: (v) => setSB(() => level = v!)),
      const SizedBox(height: 12),
      Row(children: [Text("Max Students: $maxStudents", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontSize: 13)), Expanded(child: Slider(value: maxStudents.toDouble(), min: 5, max: 50, divisions: 9, activeColor: AppColors.primaryGold, onChanged: (v) => setSB(() => maxStudents = v.toInt())))]),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
        final auth = Provider.of<AuthService>(context, listen: false);
        final teacherId = auth.currentFirebaseUser?.uid ?? 't1';
        final newClass = ClassModel(id: '', schoolId: selectedSchoolId, name: nameCtrl.text, description: descCtrl.text, teacherId: teacherId, createdAt: DateTime.now(), level: level, maxStudents: maxStudents, schedule: scheduleCtrl.text);
        await _teacherService.createClass(newClass);
        if (mounted) Navigator.pop(context);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Class created!"), backgroundColor: AppColors.success));
        setState(() {});
      }, child: const Text("CREATE CLASS"))),
      const SizedBox(height: 20),
    ])))));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final teacherId = auth.currentFirebaseUser?.uid ?? 't1';
    final classes = _teacherService.getMockClasses(teacherId);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Class Management", subtitle: "${classes.length} classes • ${classes.fold(0, (p, c) => p + c.studentIds.length)} students", showBack: true, actions: [IconButton(icon: const Icon(Icons.add, color: AppColors.primaryGold), onPressed: _showCreateClassDialog)]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (c, i) {
          final cls = classes[i];
          return Container(
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16),
              leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.class_, color: AppColors.primaryGold)),
              title: Text(cls.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryWhite)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 4),
                Text("${cls.studentIds.length}/${cls.maxStudents} students • ${cls.level}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: cls.occupancy, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 4)),
              ]),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(cls.description ?? '', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
                    const SizedBox(height: 12),
                    Row(children: [
                      _actionBtn(Icons.person_add, "Add Student", () {}),
                      const SizedBox(width: 8),
                      _actionBtn(Icons.assignment, "Assignments", () => Navigator.pushNamed(context, '/createAssignment')),
                      const SizedBox(width: 8),
                      _actionBtn(Icons.analytics, "Progress", () {}),
                    ]),
                    const SizedBox(height: 16),
                    Text("Students (${cls.studentIds.length})", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: List.generate(cls.studentIds.length > 6 ? 6 : cls.studentIds.length, (idx) => Chip(avatar: CircleAvatar(backgroundColor: AppColors.primaryGold.withOpacity(0.2), child: Text("S$idx", style: const TextStyle(fontSize: 9, color: AppColors.primaryGold))), label: Text("Student ${idx+1}", style: GoogleFonts.poppins(fontSize: 10)), backgroundColor: AppColors.primaryBlackLight))),
                    if (cls.studentIds.length > 6) Padding(padding: const EdgeInsets.only(top: 8), child: Text("+ ${cls.studentIds.length - 6} more students", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold))),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showCreateClassDialog, backgroundColor: AppColors.primaryGold, child: const Icon(Icons.add, color: AppColors.primaryBlack)),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 14), label: Text(label, style: const TextStyle(fontSize: 10)), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10))));
  }
}
