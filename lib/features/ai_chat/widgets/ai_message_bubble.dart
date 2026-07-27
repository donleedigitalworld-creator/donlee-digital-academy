import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';

class AIMessageBubble extends StatelessWidget {
  final AIMessage message;
  final VoidCallback? onSpeak;
  final VoidCallback? onCopy;
  const AIMessageBubble({super.key, required this.message, this.onSpeak, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AIMessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: isUser ? 40 : 12, right: isUser ? 12 : 40, top: 6, bottom: 6),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryGold : AppColors.cardBlack,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(color: AppColors.primaryBlackLighter),
                boxShadow: isUser ? [BoxShadow(color: AppColors.primaryGold.withOpacity(0.2), blurRadius: 8)] : null,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (!isUser) Row(children: [
                  Container(width: 24, height: 24, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryBlack)),
                  const SizedBox(width: 6),
                  Text("Donlee AI Tutor", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.security, size: 8, color: AppColors.success), const SizedBox(width: 3), Text("Encrypted", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.success))])),
                ]),
                if (!isUser) const SizedBox(height: 8),
                Text(message.content, style: GoogleFonts.poppins(fontSize: 13, color: isUser ? AppColors.primaryBlack : AppColors.primaryWhite, height: 1.5)),
                if (message.metadata?['suggestedLessons'] != null && (message.metadata!['suggestedLessons'] as List).isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(spacing: 6, children: (message.metadata!['suggestedLessons'] as List).map((l) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isUser ? AppColors.primaryBlack.withOpacity(0.1) : AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(l, style: GoogleFonts.poppins(fontSize: 9, color: isUser ? AppColors.primaryBlack : AppColors.primaryGold)))).toList()),
                ],
              ]),
            ),
            const SizedBox(height: 4),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text("${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
              if (!isUser) ...[
                const SizedBox(width: 8),
                GestureDetector(onTap: onSpeak, child: const Icon(Icons.volume_up, size: 14, color: AppColors.mediumGrey)),
                const SizedBox(width: 6),
                GestureDetector(onTap: onCopy, child: const Icon(Icons.copy, size: 14, color: AppColors.mediumGrey)),
              ],
              if (message.isVoice) ...[const SizedBox(width: 6), const Icon(Icons.mic, size: 12, color: AppColors.primaryGold)],
            ]),
          ],
        ),
      ),
    );
  }
}

class AIThinkingIndicator extends StatefulWidget {
  const AIThinkingIndicator({super.key});

  @override
  State<AIThinkingIndicator> createState() => _AIThinkingIndicatorState();
}

class _AIThinkingIndicatorState extends State<AIThinkingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(left: 12, right: 40, top: 6), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4)), border: Border.all(color: AppColors.primaryBlackLighter)), child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 24, height: 24, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryBlack)),
      const SizedBox(width: 10),
      AnimatedBuilder(animation: _controller, builder: (c, child) => Row(children: List.generate(3, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 2), width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(((_controller.value + i * 0.3) % 1.0)), shape: BoxShape.circle))))),
      const SizedBox(width: 10),
      Text("Donlee AI is thinking...", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, fontStyle: FontStyle.italic)),
    ])));
  }
}
