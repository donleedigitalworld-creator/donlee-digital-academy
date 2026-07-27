import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/assignment_model.dart';
import '../../../services/teacher_service.dart';
import '../../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../features/lessons/data/lessons_data.dart';

class AssignmentCreateScreen extends StatefulWidget {
  const AssignmentCreateScreen({super.key});

  @override
  State<AssignmentCreateScreen> createState() => _AssignmentCreateScreenState();
}

class _AssignmentCreateScreenState extends State<AssignmentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();
  final _scoreCtrl = TextEditingController(text: '100');
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _selectedClassId = 'c1';
  String? _selectedModuleId;
  bool _requireCamera = false;
  bool _allowLate = true;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final teacherId = auth.currentFirebaseUser?.uid ?? 't1';
      final teacherName = auth.currentUserModel?.displayName ?? 'Donlee Instructor';
      final assignment = AssignmentModel(
        id: '',
        title: _titleCtrl.text,
        description: _descCtrl.text,
        instructions: _instrCtrl.text,
        teacherId: teacherId,
        teacherName: teacherName,
        classId: _selectedClassId,
        schoolId: 's1',
        moduleId: _selectedModuleId,
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        maxScore: int.tryParse(_scoreCtrl.text) ?? 100,
        tags: _selectedModuleId != null ? [_selectedModuleId!] : [],
        requireCameraPhoto: _requireCamera,
        allowLateSubmission: _allowLate,
      );
      await TeacherService().createAssignment(assignment);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Assignment created! Students notified."), backgroundColor: AppColors.success));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = LessonsData.modules;
    final teacherService = TeacherService();
    final classes = teacherService.getMockClasses('t1');

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.close, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Text("Create Assignment", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontWeight: FontWeight.bold)), actions: [TextButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGold)) : Text("PUBLISH", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontWeight: FontWeight.bold)))]),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<String>(value: _selectedClassId, decoration: const InputDecoration(labelText: 'Select Class *', prefixIcon: Icon(Icons.class_, color: AppColors.primaryGold)), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(), onChanged: (v) => setState(() => _selectedClassId = v!)),
            const SizedBox(height: 16),
            TextFormField(controller: _titleCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Assignment Title *', hintText: 'e.g. Loomis Head 5 Angles', prefixIcon: Icon(Icons.title, color: AppColors.primaryGold)), validator: (v) => v != null && v.length >= 5 ? null : 'Title required'),
            const SizedBox(height: 16),
            TextFormField(controller: _descCtrl, maxLines: 2, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Short Description *', prefixIcon: Icon(Icons.description_outlined, color: AppColors.primaryGold)), validator: (v) => v != null && v.isNotEmpty ? null : 'Required'),
            const SizedBox(height: 16),
            TextFormField(controller: _instrCtrl, maxLines: 5, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Detailed Instructions - mention camera/gallery upload *', alignLabelWithHint: true, prefixIcon: Icon(Icons.list_alt, color: AppColors.primaryGold)), validator: (v) => v != null && v.length >= 10 ? null : 'Add instructions'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(value: _selectedModuleId, decoration: const InputDecoration(labelText: 'Link to Module (optional)', prefixIcon: Icon(Icons.school_outlined, color: AppColors.primaryGold)), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: [const DropdownMenuItem(value: null, child: Text("No module link"))] + modules.map((m) => DropdownMenuItem(value: m.id, child: Text(m.title))).toList(), onChanged: (v) => setState(() => _selectedModuleId = v)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(readOnly: true, controller: TextEditingController(text: "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}"), style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(labelText: 'Due Date', prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primaryGold), suffixIcon: IconButton(icon: const Icon(Icons.edit_calendar, color: AppColors.primaryGold), onPressed: () async { final d = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90))); if (d != null) setState(() => _dueDate = d); })))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _scoreCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Max Score', prefixIcon: Icon(Icons.score, color: AppColors.primaryGold)))),
            ]),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Upload Requirements - Phase 2", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              SwitchListTile(value: _requireCamera, activeColor: AppColors.primaryGold, title: Text("Require Camera Capture", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryWhite)), subtitle: Text("Students must use camera to capture drawing (proves original work)", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _requireCamera = v)),
              SwitchListTile(value: _allowLate, activeColor: AppColors.primaryGold, title: Text("Allow Late Submission", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryWhite)), subtitle: Text("Late submissions flagged but accepted", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _allowLate = v)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryGold), const SizedBox(width: 8), Expanded(child: Text("Phase 2 adds secure camera + gallery upload. Profile photos stored securely. Teachers can review, annotate and score uploaded work. Future: AI suggestions on proportions/shading (teacher guided for now).", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight)))])),
            ])),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _loading ? null : _submit, icon: const Icon(Icons.send), label: Text(_loading ? "Publishing..." : "PUBLISH ASSIGNMENT"))),
          ],
        ),
      ),
    );
  }
}
