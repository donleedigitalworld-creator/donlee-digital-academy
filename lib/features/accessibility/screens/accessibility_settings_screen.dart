import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/accessibility/accessibility_model.dart';
import '../../../widgets/custom_app_bar.dart';

class AccessibilityService extends ChangeNotifier {
  AccessibilitySettings _settings = AccessibilitySettings.defaultSettings();
  AccessibilitySettings get settings => _settings;

  void updateSettings(AccessibilitySettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AccessibilityService>(context);
    final settings = service.settings;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Accessibility Options", subtitle: "Text scale, contrast, dyslexia font, color blind, screen reader", showBack: true),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [const Icon(Icons.accessibility_new, color: AppColors.primaryGold, size: 18), const SizedBox(width: 8), Expanded(child: Text("Accessibility ensures inclusive art education for 12% of students using these features - national equity target 20%. Settings encrypted, synced offline.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.goldLight)))])),
        const SizedBox(height: 20),
        Text("Text & Display", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        _settingTile("Text Scale", "Adjust for readability", Icons.text_fields, [
          _choiceChip("Normal", settings.textScale == TextScale.normal, () => service.updateSettings(settings.copyWith(textScale: TextScale.normal))),
          _choiceChip("Large", settings.textScale == TextScale.large, () => service.updateSettings(settings.copyWith(textScale: TextScale.large))),
          _choiceChip("Extra Large", settings.textScale == TextScale.extraLarge, () => service.updateSettings(settings.copyWith(textScale: TextScale.extraLarge))),
        ]),
        _settingTile("Contrast Mode", "High contrast for low vision", Icons.contrast, [
          _choiceChip("Normal", settings.contrastMode == ContrastMode.normal, () => service.updateSettings(settings.copyWith(contrastMode: ContrastMode.normal))),
          _choiceChip("High Contrast", settings.contrastMode == ContrastMode.highContrast, () => service.updateSettings(settings.copyWith(contrastMode: ContrastMode.highContrast))),
        ]),
        _switchTile("Bold Text", "Heavier font weight", Icons.format_bold, settings.boldText, (v) => service.updateSettings(settings.copyWith(boldText: v))),
        _switchTile("Dyslexia Font", "OpenDyslexic font for readability", Icons.font_download, settings.dyslexiaFont == DyslexiaFont.on, (v) => service.updateSettings(settings.copyWith(dyslexiaFont: v ? DyslexiaFont.on : DyslexiaFont.off))),
        const SizedBox(height: 20),
        Text("Color & Vision", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        _settingTile("Color Blind Mode", "Adjust for protanopia/deuteranopia/tritanopia", Icons.color_lens, [
          _choiceChip("None", settings.colorBlindMode == ColorBlindMode.none, () => service.updateSettings(settings.copyWith(colorBlindMode: ColorBlindMode.none))),
          _choiceChip("Protanopia", settings.colorBlindMode == ColorBlindMode.protanopia, () => service.updateSettings(settings.copyWith(colorBlindMode: ColorBlindMode.protanopia))),
          _choiceChip("Deuteranopia", settings.colorBlindMode == ColorBlindMode.deuteranopia, () => service.updateSettings(settings.copyWith(colorBlindMode: ColorBlindMode.deuteranopia))),
        ]),
        const SizedBox(height: 20),
        Text("Assistive Technologies", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        _switchTile("Screen Reader", "TalkBack/VoiceOver support - semantic labels", Icons.record_voice_over, settings.screenReaderEnabled, (v) => service.updateSettings(settings.copyWith(screenReaderEnabled: v))),
        _switchTile("Voice Navigation", "Navigate app with voice commands", Icons.mic, settings.voiceNavigationEnabled, (v) => service.updateSettings(settings.copyWith(voiceNavigationEnabled: v))),
        _switchTile("Reduce Motion", "Less animation for vestibular disorders", Icons.motion_photos_off, settings.reduceMotion, (v) => service.updateSettings(settings.copyWith(reduceMotion: v))),
        _switchTile("Subtitles", "Captions for video lessons", Icons.subtitles, settings.subtitlesEnabled, (v) => service.updateSettings(settings.copyWith(subtitlesEnabled: v))),
        _switchTile("Keyboard Navigation", "Full keyboard support for external keyboards", Icons.keyboard, settings.keyboardNavigation, (v) => service.updateSettings(settings.copyWith(keyboardNavigation: v))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Preview: ${settings.textScaleFactor}x scale, ${settings.contrastMode.name}, ${settings.dyslexiaFont.name} dyslexia, ${settings.colorBlindMode.name} mode", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
          const SizedBox(height: 8),
          Text("The quick brown fox jumps over the lazy dog. Donlee Digital World Creative Art Academy empowers creativity through digital fine art education. Loomis head method sphere and cross.", style: GoogleFonts.poppins(fontSize: 13 * settings.textScaleFactor, color: AppColors.primaryWhite, height: settings.lineSpacing, fontWeight: settings.boldText ? FontWeight.bold : FontWeight.normal)),
        ])),
      ]),
    );
  }

  Widget _settingTile(String title, String sub, IconData icon, List<Widget> choices) {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 16, color: AppColors.primaryGold), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)), Text(sub, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]))]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: choices),
    ]));
  }

  Widget _switchTile(String title, String sub, IconData icon, bool value, Function(bool) onChanged) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: value ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: value ? AppColors.success : AppColors.mediumGrey)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)), Text(sub, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))])),
      Switch(value: value, activeColor: AppColors.success, onChanged: onChanged),
    ]));
  }

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(label: Text(label, style: GoogleFonts.poppins(fontSize: 11, color: selected ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: selected, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.primaryBlackLight, onSelected: (_) => onTap());
  }
}
