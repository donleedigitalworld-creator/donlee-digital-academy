import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/ai/ai_models.dart';

class AIService {
  // For Phase 4, we use mock AI with structure for real OpenAI integration
  // Replace baseUrl with your AI backend or OpenAI compatible endpoint
  static const String _mockMode = "mock"; // set to "api" when real API key available
  static const String _apiBaseUrl = "https://api.openai.com/v1";
  static const String _model = "gpt-4o-mini"; // or donlee fine-tuned

  bool _isMockMode = true;
  bool get isMockMode => _isMockMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isMockMode = prefs.getString('ai_api_key') == null;
  }

  Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_api_key', apiKey);
    _isMockMode = false;
  }

  // Generic AI chat completion - mock with intelligent rule-based responses for art education
  Future<AIMessage> chatCompletion({
    required List<AIMessage> history,
    required String userQuery,
    Map<String, dynamic>? context, // lesson, progress, etc
  }) async {
    if (_isMockMode) {
      return _mockChatResponse(history, userQuery, context);
    } else {
      return await _apiChatResponse(history, userQuery, context);
    }
  }

  Future<AIMessage> _mockChatResponse(List<AIMessage> history, String query, Map<String, dynamic>? context) async {
    // Simulate latency
    await Future.delayed(Duration(milliseconds: 800 + (query.length * 10).clamp(0, 1200)));

    final lower = query.toLowerCase();
    String response;
    List<String> suggestedLessons = [];

    if (lower.contains('loomis') || lower.contains('head') || lower.contains('face')) {
      response = """
**Loomis Head Method - AI Tutor:**

Great question about heads! 🎨

The Loomis method is your foundation:

1. **Sphere** = cranium. Lightly draw a sphere.
2. **Cross** = brow line (middle of sphere) + center line for direction.
3. **Thirds**: Hairline to brow, brow to nose base, nose base to chin.
4. **Fifths**: 5 eye-widths across head, 1 eye gap between eyes.

**Common mistake I see:** Jaw too long. Measure: chin should be 1/3 below sphere in front view.

**Your next step:** Since you're at ${context?['progress'] ?? '60%'} in Facial Drawing, try drawing 5 heads different angles today - no shading, just light construction. Embrace camera capture for verification!

Want me to generate a practice challenge for Loomis?
""";
      suggestedLessons = ['facial_drawing_1', 'human_anatomy_1'];
    } else if (lower.contains('shading') || lower.contains('value') || lower.contains('shadow')) {
      response = """
**Value & Shading - AI Insight:**

Value = light to dark, the secret to 3D! 🌗

**5 Elements of Light & Shadow you need for sphere:**
- **Highlight** - brightest, small, sharp
- **Light** - mid light on form
- **Core Shadow** - darkest ON object, not cast!
- **Reflected Light** - light bouncing from ground into shadow, don't make too bright
- **Cast Shadow** - darkest, sharp near object, soft further

**Your work analysis:** If core shadow is same as cast shadow, that's a common slip. Core should be slightly lighter than cast, and reflected light should be only 1-2 values lighter than core.

**Exercise:** Create 9-step value scale today (white to blackest). Most beginners use only 3 values - pros use all 9. 5 min daily.

I can analyze your uploaded sphere photo if you share via camera!
""";
      suggestedLessons = ['elements_of_art_2', 'still_life_1'];
    } else if (lower.contains('perspective') || lower.contains('vanishing')) {
      response = """
**Perspective - AI Tutor:**

Perspective is your depth illusion superpower! 📐

- **1-point**: One vanishing point, e.g., road receding. Good for interiors.
- **2-point**: Two VPs on horizon, building corners. Most common for Lagos street scenes you love.
- **3-point**: Adds third VP above/below, skyscrapers dramatic.

**Tip for your Lagos Market drawings:** For 2-point, place VPs OUTSIDE your page (tape extra paper). This avoids distortion. Horizon line = your eye level. Lower horizon = looking up (monumental). High horizon = bird's eye.

**Common teaching:** Students put vanishing points too close → fish-eye. Space them far!

Your schedule shows Perspective module at 30% - want a personalized study plan for this week?
""";
      suggestedLessons = ['perspective_1'];
    } else if (lower.contains('color') || lower.contains('theory')) {
      response = """
**Color Theory - AI Guide:**

Color = emotion before logic! 🌈

**Wheel essentials:**
- Primary: RYB (Red, Yellow, Blue) can't mix.
- Secondary: Orange (R+Y), Green (Y+B), Purple (B+R)
- Tertiary: Red-Orange etc.

**Harmony rules you asked about:**
- **Complementary** - opposite: Red-Green = vibrant, but use one as dominant, other as accent 20%.
- **Analogous** - neighbors: Blue, Blue-Green, Green = harmony, peaceful.
- **Triadic** - 3 spaced: e.g., Red, Yellow, Blue = balanced pop.

**Temperature trick for portraits:** Add cool (blue) in shadows, warm (yellow/red) in lights = realism! Your last portrait had warm shadows - try flipping.

Want me to generate a limited palette challenge (complementary only)?
""";
      suggestedLessons = ['color_theory_1'];
    } else if (lower.contains('navigat') || lower.contains('where') || lower.contains('find') || lower.contains('how to use')) {
      response = """
**Donlee App Navigation - AI Assistant:**

I'm your Donlee guide! 🧭 Here's where to find things:

- **Learn:** Bottom nav Learn tab → 10 modules (Intro, Elements, Principles, Anatomy, Facial Loomis, Hands/Feet, Perspective, Still Life, Landscape, Color Theory)
- **Practice:** National competitions center tab Compete → also Practice exercises (Blind Contour, Gesture) via Home Quick Access
- **Camera Upload:** Home Quick Access Camera Upload → Portfolio → Upload Work → Camera or Gallery (secure, teacher verifies)
- **Assignments:** Home Assignments preview or Menu → Assignments (camera required badge means must use camera)
- **Competitions:** Center bottom nav Compete → National Art Championship 2025, registration, offline OK, low-bandwidth mode
- **Offline Mode:** AppBar wifi icon or Menu Offline Mode & Sync → see queue, toggle low-bandwidth, download lessons
- **Certificates:** Menu Certificates or Profile → Certificates + luxury black/gold viewer
- **Teacher Portal:** Menu Teacher Portal → dashboard, class management, assignment creation, submissions review with AI proportion/shading feedback, student progress
- **Exhibition & Scholarships:** Menu Exhibition & Scholarships → Nike Art Gallery top 10 + scholarship eligibility
- **AI Tutor:** You're chatting with me now! Also available via AI Chat Assistant button on Home - I can answer art questions, suggest lessons, generate practice.

What concept do you want to dive into now?
""";
    } else {
      response = """
**Donlee AI Art Tutor here!** 🎨✨

I see you asked: "$query"

I'm trained on Donlee's 10 modules + 500+ fine art critiques. I can:

- **Answer art questions:** Proportion, shading, composition, Loomis, color theory - just ask!
- **Suggest lessons:** Based on your progress ${context?['progress'] ?? ''} - I see you're strongest in ${context?['strength'] ?? 'Elements of Art'}, need help with ${context?['weakness'] ?? 'Perspective'}.
- **Generate practice:** Daily 5-min challenges tailored to your weakness
- **Analyze drawings:** Upload via camera/gallery → I give proportion (e.g., jaw 10% too long), shading (core shadow darker), composition (rule of thirds) - teacher-reviewed, secure
- **Study planner:** AI creates personalized timetable based on goal (daily practice, exam, competition, portfolio)

**Privacy:** Your chats are encrypted, consent required. You can delete anytime via Privacy Settings. No data used to train without permission.

Try:
- "Explain Loomis head at 3/4 angle"
- "Give me a still life challenge for today"
- "Analyze my sphere shading"
- "Create study plan for competition in 20 days"

What would you like to learn next?
""";
    }

    return AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: AIMessageRole.assistant,
      content: response,
      timestamp: DateTime.now(),
      metadata: {
        'suggestedLessons': suggestedLessons,
        'model': 'donlee-mock-v1',
        'isOfflineAnalysis': false,
        'tokens': response.length ~/ 4,
      },
    );
  }

  Future<AIMessage> _apiChatResponse(List<AIMessage> history, String query, Map<String, dynamic>? context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('ai_api_key');
      if (apiKey == null) throw Exception("No API key");

      final messages = [
        {"role": "system", "content": "You are Donlee AI Art Tutor - friendly, encouraging, expert in fine art education. You teach 10 modules: Intro Fine Art, Elements, Principles, Anatomy, Facial Loomis, Hands/Feet, Perspective, Still Life, Landscape, Color Theory. You give proportion/shading/composition feedback, suggest lessons, generate practice. You respect privacy, mention secure storage, offline support. You are teacher-guided, not replacing teachers. Provide concise but thorough explanations with actionable steps."},
        ...history.map((m) => {"role": m.role.name, "content": m.content}),
        {"role": "user", "content": query},
      ];

      final response = await http.post(
        Uri.parse("$_apiBaseUrl/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": _model,
          "messages": messages,
          "max_tokens": 800,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return AIMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: AIMessageRole.assistant,
          content: content,
          timestamp: DateTime.now(),
          metadata: {'model': _model, 'realApi': true},
        );
      } else {
        throw Exception("API error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("AI API failed, fallback mock: $e");
      return _mockChatResponse(history, query, context);
    }
  }

  Future<List<String>> suggestLessons({required String studentId, String? currentModule, double? progress}) async {
    // Mock lesson suggestions based on progress weakness
    await Future.delayed(const Duration(milliseconds: 500));
    if (currentModule == 'facial_drawing') return ['human_anatomy_1', 'elements_of_art_2', 'facial_drawing_2'];
    if (currentModule == 'perspective') return ['perspective_1', 'principles_design_1', 'landscape_2'];
    return ['elements_of_art_1', 'principles_design_1', 'color_theory_1'];
  }
}
