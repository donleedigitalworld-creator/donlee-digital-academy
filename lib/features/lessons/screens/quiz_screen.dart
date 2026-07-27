import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/lesson_model.dart';
import '../../../models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final LessonModel lesson;
  const QuizScreen({super.key, required this.lesson});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQ = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;

  void _submit() {
    if (_selected == null) return;
    setState(() {
      _answered = true;
      if (_selected == widget.lesson.quiz[_currentQ].correctIndex) _score++;
    });
  }

  void _next() {
    if (_currentQ < widget.lesson.quiz.length -1) {
      setState(() {
        _currentQ++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.quiz.isEmpty) {
      return Scaffold(backgroundColor: AppColors.primaryBlack, appBar: AppBar(backgroundColor: AppColors.primaryBlack, title: Text("Quiz", style: GoogleFonts.poppins(color: AppColors.primaryWhite))), body: Center(child: Text("No quiz for this lesson yet.", style: GoogleFonts.poppins(color: AppColors.mediumGrey))));
    }
    final quiz = widget.lesson.quiz;
    final q = quiz[_currentQ];

    if (_finished) {
      final percent = (_score / quiz.length * 100).toInt();
      final passed = percent >= 60;
      return Scaffold(
        backgroundColor: AppColors.primaryBlack,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 100, height: 100, decoration: BoxDecoration(color: passed ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15), shape: BoxShape.circle), child: Icon(passed ? Icons.emoji_events : Icons.refresh, size: 50, color: passed ? AppColors.success : AppColors.error)),
                const SizedBox(height: 24),
                Text(passed ? "Congratulations!" : "Keep Practicing!", style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 12),
                Text("You scored $_score out of ${quiz.length}", style: GoogleFonts.poppins(fontSize: 16, color: AppColors.mediumGrey)),
                const SizedBox(height: 20),
                Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: _score / quiz.length, strokeWidth: 8, backgroundColor: AppColors.primaryBlackLighter, color: passed ? AppColors.success : AppColors.primaryGold)),
                  Text("$percent%", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                ]),
                const SizedBox(height: 32),
                Text(passed ? "You've mastered this lesson! Continue to next lesson or practice your skills." : "You need 60% to pass. Review the lesson and try again - practice makes perfect!", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey, height: 1.5), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(passed ? "CONTINUE LEARNING" : "REVIEW LESSON"))),
                const SizedBox(height: 12),
                if (!passed) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () { setState(() { _currentQ=0; _score=0; _selected=null; _answered=false; _finished=false; }); }, child: const Text("RETRY QUIZ"))),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Quiz: ${widget.lesson.title}", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("Question ${_currentQ+1} of ${quiz.length}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGold)),
        ]),
        leading: IconButton(icon: const Icon(Icons.close, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: (_currentQ+1)/quiz.length, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
            const SizedBox(height: 24),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Text(q.question, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryWhite, height: 1.4))),
            const SizedBox(height: 20),
            ...q.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final isSelected = _selected == idx;
              final isCorrect = idx == q.correctIndex;
              Color borderColor = AppColors.primaryBlackLighter;
              Color bg = AppColors.cardBlack;
              if (_answered) {
                if (isCorrect) { bg = AppColors.success.withOpacity(0.15); borderColor = AppColors.success; }
                else if (isSelected && !isCorrect) { bg = AppColors.error.withOpacity(0.15); borderColor = AppColors.error; }
              } else if (isSelected) { borderColor = AppColors.primaryGold; bg = AppColors.primaryGold.withOpacity(0.1); }
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor, width: 1.2)),
                child: ListTile(
                  leading: Container(width: 32, height: 32, decoration: BoxDecoration(color: _answered && isCorrect ? AppColors.success : isSelected ? AppColors.primaryGold : AppColors.primaryBlackLighter, shape: BoxShape.circle), child: Center(child: _answered && isCorrect ? const Icon(Icons.check, size: 16, color: Colors.white) : Text(String.fromCharCode(65+idx), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryBlack : AppColors.mediumGrey)))),
                  title: Text(opt, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryWhite)),
                  onTap: _answered ? null : () => setState(() => _selected = idx),
                ),
              );
            }),
            if (_answered) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: (_selected == q.correctIndex ? AppColors.success : AppColors.primaryGold).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: (_selected == q.correctIndex ? AppColors.success : AppColors.primaryGold).withOpacity(0.2))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(_selected == q.correctIndex ? Icons.check_circle : Icons.lightbulb, size: 18, color: _selected == q.correctIndex ? AppColors.success : AppColors.primaryGold), const SizedBox(width: 8), Expanded(child: Text(q.explanation, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite)))])),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _answered ? _next : _selected != null ? _submit : null, child: Text(_answered ? (_currentQ == quiz.length-1 ? "FINISH QUIZ" : "NEXT QUESTION") : "SUBMIT ANSWER"))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
