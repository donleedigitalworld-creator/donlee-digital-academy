import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/ai/ai_voice_service.dart';
import '../../../services/ai/privacy_service.dart';

class VoiceLearningScreen extends StatefulWidget {
  const VoiceLearningScreen({super.key});

  @override
  State<VoiceLearningScreen> createState() => _VoiceLearningScreenState();
}

class _VoiceLearningScreenState extends State<VoiceLearningScreen> {
  String _selectedLanguage = 'en';
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'yo', 'name': 'Yoruba'},
    {'code': 'ig', 'name': 'Igbo'},
    {'code': 'ha', 'name': 'Hausa'},
    {'code': 'fr', 'name': 'French'},
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<AIVoiceService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    final voice = Provider.of<AIVoiceService>(context);
    final privacy = Provider.of<PrivacyService>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Voice Learning Support", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text("Speech to text, text to speech, low-bandwidth", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Expanded(child: Text("Voice Privacy: Mic permission required, recordings encrypted, you can delete anytime via Privacy Settings. Voice data not used to train without Data Collection consent. Offline speech recognition when possible.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight)))])),
        const SizedBox(height: 20),
        Text("Select Language for Voice", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: _languages.map((lang) => ChoiceChip(label: Text(lang['name']!, style: GoogleFonts.poppins(fontSize: 11, color: _selectedLanguage == lang['code'] ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: _selectedLanguage == lang['code'], selectedColor: AppColors.primaryGold, backgroundColor: AppColors.cardBlack, onSelected: (v) => setState(() => _selectedLanguage = lang['code']!))).toList()),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all(color: voice.isListening ? AppColors.error.withOpacity(0.5) : AppColors.primaryBlackLighter, width: voice.isListening ? 2 : 1)), child: Column(children: [
          if (voice.isListening) ...[
            const Icon(Icons.mic, size: 50, color: AppColors.error),
            const SizedBox(height: 12),
            Text("Listening...", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.error)),
            const SizedBox(height: 8),
            Text(voice.lastWords.isEmpty ? "Speak about art... e.g. 'Explain Loomis method'" : voice.lastWords, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryWhite, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: null, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.error, minHeight: 4),
          ] else ...[
            const Icon(Icons.mic_none, size: 50, color: AppColors.primaryGold),
            const SizedBox(height: 12),
            Text("Tap mic to ask AI Tutor with voice", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 8),
            Text("Low-bandwidth: speech recognition runs on-device when possible, no cloud upload unless online. Example: 'How to shade sphere?' or 'Generate practice challenge'", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), textAlign: TextAlign.center),
          ],
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: voice.isListening ? () => voice.stopListening() : () async { if (privacy.consent?.voiceRecordingConsent != true) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voice consent required - check Privacy Settings"))); return; } await voice.startListening(onResult: (text) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Heard: $text - sending to AI Tutor"), backgroundColor: AppColors.success)); }); }, icon: Icon(voice.isListening ? Icons.stop : Icons.mic), label: Text(voice.isListening ? "Stop Listening" : "Start Voice"), style: ElevatedButton.styleFrom(backgroundColor: voice.isListening ? AppColors.error : AppColors.primaryGold, foregroundColor: voice.isListening ? Colors.white : AppColors.primaryBlack))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: () => voice.speak("Hello! I'm Donlee AI Tutor. How can I help you with fine art today? Your voice is encrypted and secure.", language: _selectedLanguage == 'en' ? 'en-US' : _selectedLanguage), icon: const Icon(Icons.volume_up), label: const Text("Test TTS"))),
          ]),
        ])),
        const SizedBox(height: 20),
        Text("Voice Learning Examples", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ...[
          {'q': 'Explain perspective 2-point', 'a': 'AI speaks explanation with low-bandwidth offline support'},
          {'q': 'Generate quiz on color theory', 'a': 'AI generates quiz, teacher reviews before you see'},
          {'q': 'How do I upload camera for competition offline?', 'a': 'AI guides navigation with voice'},
        ].map((ex) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.record_voice_over, size: 18, color: AppColors.primaryGold)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ex['q']!, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text(ex['a']!, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
          IconButton(icon: const Icon(Icons.play_circle, color: AppColors.primaryGold), onPressed: () => voice.speak(ex['q']!)),
        ]))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Voice Privacy Safeguards", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("• Mic permission: Request with explanation, you can deny\n• Encryption: Recordings encrypted AES-256 at rest, Secure Storage keys\n• No cloud without consent: On-device STT when possible (low-bandwidth)\n• Delete: Voice history deletable via Privacy Settings\n• Teacher visibility: Anonymized engagement only, not your voice content unless you share\n• Child safety: Parental consent for under-13 voice features", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        ])),
      ]),
    );
  }
}
