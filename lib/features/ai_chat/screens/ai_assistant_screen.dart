import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_service.dart';
import '../../../services/ai/ai_voice_service.dart';
import '../../../services/ai/privacy_service.dart';
import '../../../services/auth_service.dart';
import '../widgets/ai_message_bubble.dart';
import '../../../core/offline/offline_banner.dart';

class AIAssistantScreen extends StatefulWidget {
  final String? initialTopic;
  const AIAssistantScreen({super.key, this.initialTopic});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  List<AIMessage> _messages = [];
  bool _thinking = false;
  AITutorSession? _session;

  @override
  void initState() {
    super.initState();
    _aiService.init();
    _initSession();
  }

  void _initSession() {
    final topic = widget.initialTopic ?? "General Art Help";
    setState(() {
      _messages = [
        AIMessage(
          id: 'welcome',
          role: AIMessageRole.assistant,
          content: "👋 Hi! I'm Donlee AI Tutor - your friendly fine art assistant! 🎨\n\nI'm trained on 10 modules: Intro, Elements, Principles, Anatomy, Facial Loomis, Hands/Feet, Perspective, Still Life, Landscape, Color Theory.\n\n**I can:**\n• Answer art questions (proportion, shading, composition)\n• Suggest lessons based on your progress\n• Generate practice challenges\n• Analyze drawings you upload via camera/gallery (proportion 10% long, core shadow darker, etc) - teacher-reviewed, secure\n• Create personalized study timetables\n• Help navigate the app\n• Voice learning support\n\n**Privacy:** Chats encrypted, consent required, no training without permission. Delete anytime via Privacy Settings.\n\nWhat would you like to learn today? Try:\n• \"Explain Loomis 3/4 angle\"\n• \"Give me a still life challenge\"\n• \"How do I submit competition artwork offline?\"",
          timestamp: DateTime.now(),
          metadata: {'suggestedLessons': ['intro_fine_art_1', 'elements_of_art_1']},
        ),
      ];
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final auth = Provider.of<AuthService>(context, listen: false);
    final privacy = Provider.of<PrivacyService>(context, listen: false);

    if (privacy.consent?.aiTutorConsent != true) {
      _showConsentDialog();
      return;
    }

    final userMsg = AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: AIMessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _thinking = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    // Get AI response
    final response = await _aiService.chatCompletion(
      history: _messages,
      userQuery: text,
      context: {
        'progress': '${((auth.currentUserModel?.overallProgress ?? 0) * 100).toInt()}%',
        'studentId': auth.currentFirebaseUser?.uid,
        'currentModule': 'facial_drawing',
        'weakness': 'perspective 30%',
        'strength': 'elements of art 82%',
      },
    );

    setState(() {
      _messages.add(response);
      _thinking = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void _showConsentDialog() {
    showDialog(context: context, builder: (c) => AlertDialog(
      backgroundColor: AppColors.cardBlack,
      title: Text("AI Tutor Privacy Consent Required", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontSize: 16)),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("To use AI Tutor, please consent:\n\n• Chats encrypted with AES-256, keys in Secure Storage\n• Your questions help personalize suggestions but not used to train AI without separate Data Collection consent\n• Voice recordings (if you use voice) stored encrypted, you can delete anytime\n• Teacher can see anonymized insights (e.g., class struggles with perspective), not your private chats", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.security, size: 14, color: AppColors.success), const SizedBox(width: 6), Expanded(child: Text("Permission: Microphone optional for voice learning. Camera optional for drawing analysis. You can toggle each in Privacy Settings.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.success)))])),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text("Deny")),
        ElevatedButton(onPressed: () async {
          final auth = Provider.of<AuthService>(context, listen: false);
          final privacy = Provider.of<PrivacyService>(context, listen: false);
          final newConsent = PrivacyConsent(
            userId: auth.currentFirebaseUser?.uid ?? 'user',
            aiTutorConsent: true,
            aiArtAnalysisConsent: privacy.consent?.aiArtAnalysisConsent ?? false,
            voiceRecordingConsent: privacy.consent?.voiceRecordingConsent ?? false,
            dataCollectionConsent: false,
            analyticsConsent: privacy.consent?.analyticsConsent ?? false,
            cameraUsageConsent: privacy.consent?.cameraUsageConsent ?? false,
            consentedAt: DateTime.now(),
          );
          await privacy.saveConsent(newConsent);
          if (mounted) Navigator.pop(c);
        }, child: const Text("Consent & Continue")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<AIVoiceService>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 28, height: 28, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryBlack)),
            const SizedBox(width: 8),
            Text("Donlee AI Art Tutor", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.lock, size: 8, color: AppColors.success), const SizedBox(width: 2), Text("Encrypted", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.success))])),
          ]),
          Text("AI answers questions, suggests lessons, teacher-guided • Voice support", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryGold), onPressed: () => Navigator.pushNamed(context, '/privacySettings')),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.primaryWhite), onPressed: () {}),
        ],
      ),
      body: Column(children: [
        const OfflineBanner(),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: AppColors.primaryGold.withOpacity(0.1), child: Row(children: [
          const Icon(Icons.lightbulb, size: 12, color: AppColors.primaryGold),
          const SizedBox(width: 6),
          Expanded(child: Text("AI Tutor • Drawing Feedback (proportion/shading/composition) • Study Planner • Practice Generator • Voice Learning • Teacher Tools Reviewed • Analytics", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))),
        ])),
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _messages.length + (_thinking ? 1 : 0),
            itemBuilder: (c, i) {
              if (_thinking && i == _messages.length) return const AIThinkingIndicator();
              final msg = _messages[i];
              return AIMessageBubble(message: msg, onSpeak: () => voiceService.speak(msg.content), onCopy: () {});
            },
          ),
        ),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, border: Border(top: BorderSide(color: AppColors.primaryBlackLighter))), child: Column(children: [
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            _suggestionChip("Explain Loomis head 3/4", () => _sendMessage("Explain Loomis head 3/4 angle step by step")),
            _suggestionChip("Shading sphere core shadow", () => _sendMessage("How to shade sphere with core shadow and reflected light?")),
            _suggestionChip("Generate practice challenge", () => _sendMessage("Generate practice challenge for today - 10 min")),
            _suggestionChip("Study plan for competition", () => _sendMessage("Create study plan for national competition in 20 days, 20 min per day")),
          ])),
          const SizedBox(height: 10),
          Row(children: [
            IconButton(icon: Icon(voiceService.isListening ? Icons.mic_off : Icons.mic, color: voiceService.isListening ? AppColors.error : AppColors.primaryGold), onPressed: () async {
              if (voiceService.isListening) {
                await voiceService.stopListening();
              } else {
                final ok = await voiceService.requestMicrophonePermission();
                if (!ok) return;
                await voiceService.startListening(onResult: (text) => _sendMessage(text));
              }
            }),
            if (voiceService.isListening) Expanded(child: Text("Listening... ${voiceService.lastWords}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.error, fontStyle: FontStyle.italic))),
            if (!voiceService.isListening) Expanded(child: TextField(controller: _inputCtrl, style: const TextStyle(color: AppColors.primaryWhite, fontSize: 13), decoration: InputDecoration(hintText: "Ask AI Tutor anything about fine art... or tap mic for voice", hintStyle: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), filled: true, fillColor: AppColors.primaryBlackLighter, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onSubmitted: _sendMessage)),
            const SizedBox(width: 8),
            if (!voiceService.isListening) Container(decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.send, size: 18, color: AppColors.primaryBlack), onPressed: () => _sendMessage(_inputCtrl.text))),
          ]),
        ])),
      ]),
    );
  }

  Widget _suggestionChip(String label, VoidCallback onTap) {
    return Container(margin: const EdgeInsets.only(right: 8), child: ActionChip(label: Text(label, style: GoogleFonts.poppins(fontSize: 10)), backgroundColor: AppColors.primaryBlackLight, side: BorderSide(color: AppColors.primaryGold.withOpacity(0.3)), onPressed: onTap));
  }
}
