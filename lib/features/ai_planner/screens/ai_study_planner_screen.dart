import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_study_planner_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/offline_service.dart';

class AIStudyPlannerScreen extends StatefulWidget {
  const AIStudyPlannerScreen({super.key});

  @override
  State<AIStudyPlannerScreen> createState() => _AIStudyPlannerScreenState();
}

class _AIStudyPlannerScreenState extends State<AIStudyPlannerScreen> {
  AIStudyGoal _selectedGoal = AIStudyGoal.dailyPractice;
  int _minutesPerDay = 20;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  AIStudyPlan? _plan;
  bool _generating = false;

  final AIStudyPlannerService _planner = AIStudyPlannerService();

  Future<void> _generatePlan() async {
    setState(() => _generating = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final offline = Provider.of<OfflineService>(context, listen: false);

    final plan = await _planner.generateStudyPlan(
      studentId: auth.currentFirebaseUser?.uid ?? 'student1',
      goal: _selectedGoal,
      minutesPerDay: _minutesPerDay,
      startDate: _startDate,
      endDate: _endDate,
      currentProgress: auth.currentUserModel?.moduleProgress ?? {'perspective': 0.3, 'facial_drawing': 0.65},
      weakAreas: ['perspective', 'hands_feet'],
      strongAreas: ['elements_of_art'],
      lowBandwidth: offline.lowBandwidthMode,
    );

    setState(() {
      _plan = plan;
      _generating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("AI Study Planner", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text("Personalized timetables - low-bandwidth & offline aware", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
      body: _plan == null ? _buildForm() : _buildPlan(),
    );
  }

  Widget _buildForm() {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.auto_awesome, color: AppColors.primaryBlack, size: 28), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("AI Creates Your Perfect Art Schedule", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)), Text("Based on progress, weak areas, goal, available time, low-bandwidth & offline needs", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.8)))]))])),
      const SizedBox(height: 20),
      Text("What's your goal?", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: AIStudyGoal.values.map((goal) {
        final isSel = _selectedGoal == goal;
        return ChoiceChip(label: Text(goal.name, style: GoogleFonts.poppins(fontSize: 11, color: isSel ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: isSel, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.cardBlack, onSelected: (v) => setState(() => _selectedGoal = goal));
      }).toList()),
      const SizedBox(height: 20),
      Text("Minutes per day: $_minutesPerDay", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      Slider(value: _minutesPerDay.toDouble(), min: 10, max: 60, divisions: 5, activeColor: AppColors.primaryGold, label: "$_minutesPerDay min", onChanged: (v) => setState(() => _minutesPerDay = v.toInt())),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _dateField("Start", _startDate, (d) => setState(() => _startDate = d))),
        const SizedBox(width: 12),
        Expanded(child: _dateField("End", _endDate, (d) => setState(() => _endDate = d))),
      ]),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.security, size: 14, color: AppColors.success), const SizedBox(width: 6), Text("Privacy & Offline", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
        const SizedBox(height: 6),
        Text("AI planner uses your progress (encrypted, consent required) to suggest lessons. Low-bandwidth mode compresses video, offline mode downloads lessons for offline queue. No data used to train without Data Collection consent. Teacher can see anonymized class trends, not individual plans unless you share.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
      ])),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: _generating ? null : _generatePlan, icon: _generating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome), label: Text(_generating ? "AI Generating Timetable..." : "Generate AI Study Plan"))),
    ]);
  }

  Widget _buildPlan() {
    final plan = _plan!;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Your AI Plan: ${plan.goal.name}", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(8)), child: Text("${plan.minutesPerDay} min/day", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
        ]),
        const SizedBox(height: 8),
        Text("${plan.startDate.day}/${plan.startDate.month} - ${plan.endDate.day}/${plan.endDate.month} • ${plan.days.length} days • ${plan.days.fold(0, (p, d) => p + d.tasks.length)} tasks • Completion ${(plan.completionRate * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: plan.completionRate, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
      ])),
      const SizedBox(height: 20),
      ...plan.days.take(7).map((day) => Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: day.date.day == DateTime.now().day ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: ExpansionTile(
        tilePadding: const EdgeInsets.all(14),
        title: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: day.completed ? AppColors.success.withOpacity(0.15) : AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Center(child: Text("${day.date.day}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: day.completed ? AppColors.success : AppColors.primaryGold)))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${_weekDay(day.date.weekday)} • ${day.theme}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text("${day.tasks.length} tasks • ${day.tasks.fold(0, (p, t) => p + t.estimatedMinutes)} min • ${day.minutesSpent} min spent", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
          if (day.completed) const Icon(Icons.check_circle, color: AppColors.success, size: 18),
        ]),
        children: day.tasks.map((task) => ListTile(
          leading: Container(width: 32, height: 32, decoration: BoxDecoration(color: _taskColor(task.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_taskIcon(task.type), size: 16, color: _taskColor(task.type))),
          title: Text(task.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${task.estimatedMinutes} min • ${task.type} • ${task.aiReason ?? ''}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 2),
          ]),
          trailing: task.completed ? const Icon(Icons.check_circle, color: AppColors.success, size: 16) : OutlinedButton(onPressed: () {}, child: const Text("Start", style: TextStyle(fontSize: 10))),
        )).toList(),
      ))),
      const SizedBox(height: 20),
      Row(children: [Expanded(child: OutlinedButton(onPressed: () => setState(() => _plan = null), child: const Text("Edit Goal"))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Start Today's Plan")))]),
      const SizedBox(height: 100),
    ]);
  }

  Widget _dateField(String label, DateTime date, Function(DateTime) onChanged) {
    return GestureDetector(onTap: () async { final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60))); if (d != null) onChanged(d); }, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)), Text("${date.day}/${date.month}/${date.year}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)) ])));
  }

  String _weekDay(int w) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[w - 1];
  }

  Color _taskColor(String type) {
    switch (type) {
      case 'lesson': return Colors.blueAccent;
      case 'practice': return AppColors.primaryGold;
      case 'quiz': return Colors.purpleAccent;
      case 'assignment': return AppColors.success;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _taskIcon(String type) {
    switch (type) {
      case 'lesson': return Icons.school;
      case 'practice': return Icons.brush;
      case 'quiz': return Icons.quiz;
      case 'assignment': return Icons.assignment;
      default: return Icons.task;
    }
  }
}
