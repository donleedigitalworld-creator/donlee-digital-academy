enum TextScale { normal, large, extraLarge }
enum ContrastMode { normal, highContrast, darkMode, lightMode }
enum DyslexiaFont { off, on }
enum ColorBlindMode { none, protanopia, deuteranopia, tritanopia }

class AccessibilitySettings {
  final TextScale textScale;
  final ContrastMode contrastMode;
  final DyslexiaFont dyslexiaFont;
  final ColorBlindMode colorBlindMode;
  final bool screenReaderEnabled;
  final bool voiceNavigationEnabled;
  final bool reduceMotion;
  final bool subtitlesEnabled;
  final bool keyboardNavigation;
  final double lineSpacing;
  final bool boldText;

  AccessibilitySettings({
    this.textScale = TextScale.normal,
    this.contrastMode = ContrastMode.normal,
    this.dyslexiaFont = DyslexiaFont.off,
    this.colorBlindMode = ColorBlindMode.none,
    this.screenReaderEnabled = false,
    this.voiceNavigationEnabled = false,
    this.reduceMotion = false,
    this.subtitlesEnabled = false,
    this.keyboardNavigation = false,
    this.lineSpacing = 1.5,
    this.boldText = false,
  });

  factory AccessibilitySettings.defaultSettings() => AccessibilitySettings();

  Map<String, dynamic> toMap() => {
    'textScale': textScale.name,
    'contrastMode': contrastMode.name,
    'dyslexiaFont': dyslexiaFont.name,
    'colorBlindMode': colorBlindMode.name,
    'screenReaderEnabled': screenReaderEnabled,
    'voiceNavigationEnabled': voiceNavigationEnabled,
    'reduceMotion': reduceMotion,
    'subtitlesEnabled': subtitlesEnabled,
    'keyboardNavigation': keyboardNavigation,
    'lineSpacing': lineSpacing,
    'boldText': boldText,
  };

  factory AccessibilitySettings.fromMap(Map<String, dynamic> map) {
    return AccessibilitySettings(
      textScale: TextScale.values.byName(map['textScale'] ?? 'normal'),
      contrastMode: ContrastMode.values.byName(map['contrastMode'] ?? 'normal'),
      dyslexiaFont: DyslexiaFont.values.byName(map['dyslexiaFont'] ?? 'off'),
      colorBlindMode: ColorBlindMode.values.byName(map['colorBlindMode'] ?? 'none'),
      screenReaderEnabled: map['screenReaderEnabled'] ?? false,
      voiceNavigationEnabled: map['voiceNavigationEnabled'] ?? false,
      reduceMotion: map['reduceMotion'] ?? false,
      subtitlesEnabled: map['subtitlesEnabled'] ?? false,
      keyboardNavigation: map['keyboardNavigation'] ?? false,
      lineSpacing: (map['lineSpacing'] ?? 1.5).toDouble(),
      boldText: map['boldText'] ?? false,
    );
  }

  double get textScaleFactor {
    switch (textScale) {
      case TextScale.normal: return 1.0;
      case TextScale.large: return 1.15;
      case TextScale.extraLarge: return 1.3;
    }
  }

  AccessibilitySettings copyWith({
    TextScale? textScale,
    ContrastMode? contrastMode,
    DyslexiaFont? dyslexiaFont,
    ColorBlindMode? colorBlindMode,
    bool? screenReaderEnabled,
    bool? voiceNavigationEnabled,
    bool? reduceMotion,
    bool? subtitlesEnabled,
    bool? keyboardNavigation,
    double? lineSpacing,
    bool? boldText,
  }) {
    return AccessibilitySettings(
      textScale: textScale ?? this.textScale,
      contrastMode: contrastMode ?? this.contrastMode,
      dyslexiaFont: dyslexiaFont ?? this.dyslexiaFont,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      voiceNavigationEnabled: voiceNavigationEnabled ?? this.voiceNavigationEnabled,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
      keyboardNavigation: keyboardNavigation ?? this.keyboardNavigation,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      boldText: boldText ?? this.boldText,
    );
  }
}
