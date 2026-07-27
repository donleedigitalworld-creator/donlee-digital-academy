import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart' as perm; // placeholder, use permission_handler if added

class AIVoiceService extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  bool _isListening = false;
  bool get isListening => _isListening;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  String _lastWords = '';
  String get lastWords => _lastWords;

  double _confidence = 0;
  double get confidence => _confidence;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _initialized = true;
  }

  Future<bool> requestMicrophonePermission() async {
    // For demo, assume granted. In prod, use Permission.microphone.request()
    debugPrint("Request microphone permission for voice learning");
    return true;
  }

  Future<void> speak(String text, {String? language}) async {
    if (language != null) await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<bool> startListening({Function(String)? onResult, String localeId = "en_US"}) async {
    final available = await _stt.initialize(
      onError: (e) => debugPrint("STT error: $e"),
      onStatus: (s) => debugPrint("STT status: $s"),
    );
    if (!available) return false;

    _isListening = true;
    _lastWords = '';
    notifyListeners();

    await _stt.listen(
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        _lastWords = result.recognizedWords;
        _confidence = result.confidence;
        notifyListeners();
        if (result.finalResult && onResult != null) {
          onResult(_lastWords);
        }
      },
    );
    return true;
  }

  Future<void> stopListening() async {
    await _stt.stop();
    _isListening = false;
    notifyListeners();
  }

  // Mock translation for voice learning support - low-bandwidth friendly
  Future<String> translateForVoice({required String text, required String targetLanguage}) async {
    // Mock - in prod call translation API
    await Future.delayed(const Duration(milliseconds: 500));
    if (targetLanguage == "yo") return "Mo ni Loomis method..."; // Yoruba placeholder
    if (targetLanguage == "ig") return "A na m Loomis method..."; // Igbo
    if (targetLanguage == "ha") return "Na san Loomis method..."; // Hausa
    return text;
  }
}
