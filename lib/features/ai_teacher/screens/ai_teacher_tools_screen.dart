import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_teacher_tools_service.dart';
import '../../../widgets/custom_app_bar.dart';

class AITeacherToolsScreen extends StatefulWidget {
  const AITeacherToolsScreen({super.key});

  @override
  State<AITeacherToolsScreen> createState() => _AITeacherToolsScreenState();
}

class _AITeacherToolsScreenState extends State<AITeacherToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final AITeacherToolsService _service = AITeacherToolsService();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "AI Teacher Tools", subtitle: "Generate quizzes & lesson plans - teacher reviewed before use", showBack: true),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "Quiz Generator"), Tab(text: "Lesson Plan Generator")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [_quizTab(), _lessonPlanTab()])),
      ]),
    );
  }

  Widget _quizTab() {
    return _QuizGeneratorTab(service: _service);
  }

  Widget _lessonPlanTab() {
    return _LessonPlanGeneratorTab(service: _service);
  }
}

class _QuizGeneratorTab extends StatefulWidget {
  final AITeacherToolsService service;
  const _QuizGeneratorTab({required this.service});

  @override
  State<_QuizGeneratorTab> createState() => _QuizGeneratorTabState();
}

class _QuizGeneratorTabState extends State<_QuizGeneratorTab> {
  String _topic = 'Loomis Head Method';
  String _difficulty = 'medium';
  int _count = 3;
  List<AIQuizQuestionGenerated> _questions = [];
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    final qs = await widget.service.generateQuiz(teacherId: 'teacher1', lessonId: 'facial_drawing_1', topic: _topic, questionCount: _count, difficulty: _difficulty);
    setState(() {
      _questions = qs;
      _generating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Expanded(child: Text("AI generated quizzes always require teacher review before student sees. Teacher-approved flag ensures privacy and quality. Encrypted, no student data used without consent.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight)))])),
      const SizedBox(height: 16),
      TextField(decoration: const InputDecoration(labelText: 'Topic *', hintText: 'e.g. Loomis Head Method'), style: const TextStyle(color: AppColors.primaryWhite), onChanged: (v) => _topic = v, controller: TextEditingController(text: _topic)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: DropdownButtonFormField<String>(value: _difficulty, decoration: const InputDecoration(labelText: 'Difficulty'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: ['easy', 'medium', 'hard'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(), onChanged: (v) => setState(() => _difficulty = v!))),
        const SizedBox(width: 12),
        Expanded(child: DropdownButtonFormField<int>(value: _count, decoration: const InputDecoration(labelText: 'Count'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: [3, 5, 10].map((c) => DropdownMenuItem(value: c, child: Text("$c questions"))).toList(), onChanged: (v) => setState(() => _count = v!))),
      ]),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _generating ? null : _generate, icon: _generating ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome), label: Text(_generating ? "AI Generating Quiz..." : "Generate Quiz with AI"))),
      const SizedBox(height: 20),
      ..._questions.asMap().entries.map((entry) {
        final idx = entry.key;
        final q = entry.value;
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: q.teacherReviewed ? AppColors.success.withOpacity(0.3) : AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Q${idx + 1} • ${q.difficulty} • ${q.source}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: q.teacherReviewed ? AppColors.success.withOpacity(0.15) : Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(q.teacherReviewed ? "Reviewed" : "Needs Review", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: q.teacherReviewed ? AppColors.success : Colors.orangeAccent))),
          ]),
          const SizedBox(height: 8),
          Text(q.question, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          ...q.options.asMap().entries.map((opt) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            Container(width: 20, height: 20, decoration: BoxDecoration(color: opt.key == q.correctIndex ? AppColors.success.withOpacity(0.2) : AppColors.primaryBlackLighter, shape: BoxShape.circle, border: Border.all(color: opt.key == q.correctIndex ? AppColors.success : Colors.transparent)), child: Center(child: Text(String.fromCharCode(65 + opt.key), style: GoogleFonts.poppins(fontSize: 10, color: opt.key == q.correctIndex ? AppColors.success : AppColors.mediumGrey)))),
            const SizedBox(width: 8),
            Expanded(child: Text(opt.value, style: GoogleFonts.poppins(fontSize: 11, color: opt.key == q.correctIndex ? AppColors.success : AppColors.mediumGrey))),
          ]))),
          const SizedBox(height: 8),
          Text("Explanation: ${q.explanation}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight, fontStyle: FontStyle.italic)),
        ]));
      }),
      if (_questions.isNotEmpty) ...[
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Edit"))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: () async { final reviewed = await widget.service.teacherReviewQuiz(questions: _questions, teacherId: 'teacher1'); setState(() => _questions = reviewed); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quiz approved! Now visible to students - teacher-reviewed flag set"), backgroundColor: AppColors.success)); }, child: const Text("Approve & Publish"))),
        ]),
      ],
    ]);
  }
}

class _LessonPlanGeneratorTab extends StatefulWidget {
  final AITeacherToolsService service;
  const _LessonPlanGeneratorTab({required this.service});

  @override
  State<_LessonPlanGeneratorTab> createState() => _LessonPlanGeneratorTabState();
}

class _LessonPlanGeneratorTabState extends State<_LessonPlanGeneratorTab> {
  String _topic = 'Loomis Head Method - 3/4 Angle';
  String _ageGroup = '13-17';
  String _level = 'intermediate';
  int _duration = 60;
  AILessonPlanDraft? _draft;
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    final draft = await widget.service.generateLessonPlan(teacherId: 'teacher1', topic: _topic, ageGroup: _ageGroup, level: _level, durationMinutes: _duration);
    setState(() {
      _draft = draft;
      _generating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      TextField(decoration: const InputDecoration(labelText: 'Topic *'), controller: TextEditingController(text: _topic), style: const TextStyle(color: AppColors.primaryWhite), onChanged: (v) => _topic = v),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: DropdownButtonFormField<String>(value: _ageGroup, decoration: const InputDecoration(labelText: 'Age Group'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: ['8-12', '13-17', '18+', 'Open'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(), onChanged: (v) => setState(() => _ageGroup = v!))),
        const SizedBox(width: 12),
        Expanded(child: DropdownButtonFormField<String>(value: _level, decoration: const InputDecoration(labelText: 'Level'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: ['beginner', 'intermediate', 'advanced'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(), onChanged: (v) => setState(() => _level = v!))),
      ]),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(value: _duration, decoration: const InputDecoration(labelText: 'Duration'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: [30, 60, 90].map((d) => DropdownMenuItem(value: d, child: Text("$d minutes"))).toList(), onChanged: (v) => setState(() => _duration = v!)),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _generating ? null : _generate, icon: _generating ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome), label: Text(_generating ? "AI Generating Lesson Plan..." : "Generate Lesson Plan with AI"))),
      const SizedBox(height: 20),
      if (_draft != null) ...[
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: _draft!.teacherApproved ? AppColors.success.withOpacity(0.3) : AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_draft!.topic, style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _draft!.teacherApproved ? AppColors.success.withOpacity(0.15) : Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(_draft!.teacherApproved ? "Approved" : "Draft - Needs Review", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: _draft!.teacherApproved ? AppColors.success : Colors.orangeAccent))),
          ]),
          const SizedBox(height: 8),
          Text("Objectives: ${_draft!.objectives}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
          const SizedBox(height: 8),
          Text("Materials: ${_draft!.materials.join(', ')}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 12),
          Text("Steps (${_draft!.steps.length})", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          ..._draft!.steps.map((step) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Center(child: Text("${step.minutes}m", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryGold)))),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(step.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Text(step.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
              if (step.tip != null) Text("Tip: ${step.tip}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.goldLight, fontStyle: FontStyle.italic)),
            ])),
          ]))),
        ])),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Edit"))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: () async { final approved = await widget.service.teacherReviewLessonPlan(draft: _draft!, teacherId: 'teacher1', approved: true); setState(() => _draft = approved); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lesson plan approved! Now visible - teacher-approved flag set, secure"), backgroundColor: AppColors.success)); }, child: const Text("Approve & Publish"))),
        ]),
      ],
    ]);
  }
}
