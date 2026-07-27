import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_study_planner_service.dart';

class AIPracticeGeneratorScreen extends StatefulWidget {
  const AIPracticeGeneratorScreen({super.key});

  @override
  State<AIPracticeGeneratorScreen> createState() => _AIPracticeGeneratorScreenState();
}

class _AIPracticeGeneratorScreenState extends State<AIPracticeGeneratorScreen> {
  AIChallengeDifficulty _difficulty = AIChallengeDifficulty.intermediate;
  List<AIPracticeChallenge> _challenges = [];
  bool _generating = false;
  final AIStudyPlannerService _service = AIStudyPlannerService();

  Future<void> _generate() async {
    setState(() => _generating = true);
    final list = await _service.generateChallenges(studentId: 'student1', difficulty: _difficulty, interests: ['Portrait', 'Lagos'], count: 6);
    setState(() {
      _challenges = list;
      _generating = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("AI Practice Generator", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text("Quizzes & art challenges personalized - low-bandwidth", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [
          Expanded(child: DropdownButtonFormField<AIChallengeDifficulty>(value: _difficulty, decoration: const InputDecoration(labelText: 'Difficulty'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: AIChallengeDifficulty.values.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(), onChanged: (v) => setState(() => _difficulty = v!))),
          const SizedBox(width: 12),
          ElevatedButton.icon(onPressed: _generating ? null : _generate, icon: _generating ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome, size: 16), label: Text(_generating ? "Generating..." : "Generate")),
        ]),
        const SizedBox(height: 20),
        if (_challenges.isEmpty && _generating) const Center(child: CircularProgressIndicator(color: AppColors.primaryGold))
        else ..._challenges.map((ch) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: _difficultyColor(ch.difficulty).withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _difficultyColor(ch.difficulty).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(ch.difficulty.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _difficultyColor(ch.difficulty)))),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.timer, size: 10, color: AppColors.primaryGold), const SizedBox(width: 3), Text("${ch.estimatedMinutes} min", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))])),
            const Spacer(),
            if (ch.isDaily) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("DAILY", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.success))),
          ]),
          const SizedBox(height: 10),
          Text(ch.title, style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text(ch.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.lightbulb, size: 12, color: AppColors.primaryGold), const SizedBox(width: 4), Text("AI Prompt", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold))]),
            const SizedBox(height: 6),
            Text(ch.prompt, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite, height: 1.4)),
          ])),
          const SizedBox(height: 10),
          Wrap(spacing: 6, children: ch.tags.map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(12)), child: Text(t, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_alt, size: 14), label: const Text("Camera Submit", style: TextStyle(fontSize: 11)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Start Challenge", style: TextStyle(fontSize: 11)))),
          ]),
        ]))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.security, size: 14, color: AppColors.success), const SizedBox(width: 6), Text("AI Practice Privacy", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
          const SizedBox(height: 6),
          Text("Challenges generated based on your progress (encrypted, consent required). Offline queue supported. Low-bandwidth compresses reference images. No personal data used to train AI without Data Collection consent. Teacher can see class challenge completion anonymized.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        ])),
      ]),
    );
  }

  Color _difficultyColor(AIChallengeDifficulty d) {
    switch (d) {
      case AIChallengeDifficulty.beginner: return AppColors.success;
      case AIChallengeDifficulty.intermediate: return AppColors.primaryGold;
      case AIChallengeDifficulty.advanced: return Colors.orangeAccent;
      case AIChallengeDifficulty.master: return AppColors.error;
    }
  }
}
