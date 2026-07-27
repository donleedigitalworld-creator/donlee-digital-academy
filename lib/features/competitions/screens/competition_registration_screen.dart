import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';
import '../../../services/competition_service.dart';
import '../../../services/auth_service.dart';

class CompetitionRegistrationScreen extends StatefulWidget {
  final CompetitionModel competition;
  const CompetitionRegistrationScreen({super.key, required this.competition});

  @override
  State<CompetitionRegistrationScreen> createState() => _CompetitionRegistrationScreenState();
}

class _CompetitionRegistrationScreenState extends State<CompetitionRegistrationScreen> {
  String? _selectedCategoryId;
  bool _loading = false;
  bool _agreeTerms = false;

  Future<void> _register() async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select a category"), backgroundColor: AppColors.error));
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to terms"), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final uid = auth.currentFirebaseUser?.uid ?? 'student1';
      final name = auth.currentUserModel?.displayName ?? 'Student';
      final photo = auth.currentUserModel?.photoUrl;
      final schoolId = auth.currentSchoolId ?? 's1';
      final classId = auth.currentClassId ?? 'c1';

      final reg = CompetitionRegistration(
        id: '',
        competitionId: widget.competition.id,
        studentId: uid,
        studentName: name,
        studentPhotoUrl: photo,
        schoolId: schoolId,
        schoolName: 'Donlee Main - Lagos',
        classId: classId,
        categoryId: _selectedCategoryId!,
        registeredAt: DateTime.now(),
        isApproved: true,
      );

      await CompetitionService().registerForCompetition(reg);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered! You can now submit artwork. Offline mode supported."), backgroundColor: AppColors.success));
        Navigator.pushNamed(context, '/competitionSubmit', arguments: widget.competition);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.close, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Text("Register for Competition", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontWeight: FontWeight.bold))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.competition.title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
          const SizedBox(height: 4),
          Text(widget.competition.theme, style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.primaryBlack.withOpacity(0.8))),
          const SizedBox(height: 8),
          Row(children: [Icon(Icons.security, size: 12, color: AppColors.primaryBlack.withOpacity(0.7)), const SizedBox(width: 4), Expanded(child: Text("Secure registration, offline queue supported, low-bandwidth mode available", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.7))))]),
        ])),
        const SizedBox(height: 20),
        Text("Select Category *", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ...widget.competition.categories.map((cat) {
          final isSelected = _selectedCategoryId == cat.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryId = cat.id),
            child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: isSelected ? AppColors.primaryGold.withOpacity(0.15) : AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.primaryGold : AppColors.primaryBlackLighter, width: isSelected ? 1.5 : 1)), child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: isSelected ? AppColors.primaryGold : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.category, color: isSelected ? AppColors.primaryBlack : AppColors.mediumGrey, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cat.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? AppColors.primaryGold : AppColors.primaryWhite)), Text(cat.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), Text("Age: ${cat.ageGroup} • Max ${cat.maxSubmissionsPerStudent} entries", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.darkGrey))])),
              if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryGold),
            ])),
          );
        }),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Competition Rules - Secure & Fair", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          ...[
            "Original work only - Camera verification required for top categories",
            "Offline submission supported - queue when no internet, auto-sync when back online",
            "Low-bandwidth mode compresses images, uses thumbnails first for judging",
            "Judging: 3 judges + Chief Judge, blind review, secure scoring, no judge sees others until final",
            "Top 10 selected for Nike Art Gallery Lagos exhibition (future-ready)",
            "Scholarship eligible - top 3 + exhibition selected linked to scholarship portal",
          ].map((r) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: const EdgeInsets.only(top: 5), width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(r, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.4)))]))),
        ])),
        const SizedBox(height: 16),
        Row(children: [Checkbox(value: _agreeTerms, activeColor: AppColors.primaryGold, checkColor: AppColors.primaryBlack, onChanged: (v) => setState(() => _agreeTerms = v ?? false)), Expanded(child: Text("I agree that my artwork is original, consent to secure storage, exhibition selection, and scholarship linking if eligible. I understand offline submissions will sync when online.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)))]),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _loading ? null : _register, child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("CONFIRM REGISTRATION - OFFLINE OK"))),
        const SizedBox(height: 12),
        Center(child: Text("Smart syncing ensures no duplicate - low bandwidth mode saves data", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.darkGrey))),
      ]),
    );
  }
}

class CompetitionCreateScreen extends StatefulWidget {
  const CompetitionCreateScreen({super.key});

  @override
  State<CompetitionCreateScreen> createState() => _CompetitionCreateScreenState();
}

class _CompetitionCreateScreenState extends State<CompetitionCreateScreen> {
  final _titleCtrl = TextEditingController();
  final _themeCtrl = TextEditingController(text: "Unity in Diversity Through Art");
  final _descCtrl = TextEditingController();
  DateTime _regStart = DateTime.now();
  DateTime _regEnd = DateTime.now().add(const Duration(days: 14));
  DateTime _subStart = DateTime.now().add(const Duration(days: 1));
  DateTime _subEnd = DateTime.now().add(const Duration(days: 21));
  bool _allowOffline = true;
  bool _lowBandwidth = true;
  bool _scholarship = true;
  bool _exhibition = true;
  bool _loading = false;

  Future<void> _create() async {
    if (_titleCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final comp = CompetitionModel(
        id: '',
        title: _titleCtrl.text,
        description: _descCtrl.text,
        theme: _themeCtrl.text,
        organizer: 'Donlee Academy',
        status: CompetitionStatus.registrationOpen,
        categories: [
          CompetitionCategory(id: 'cat1', name: 'Junior Drawing', description: 'Pencil, charcoal', type: CompetitionCategoryType.drawing, ageGroup: '8-12'),
          CompetitionCategory(id: 'cat2', name: 'Senior Painting', description: 'Watercolor, acrylic', type: CompetitionCategoryType.painting, ageGroup: '13-17'),
        ],
        judgingCriteria: [
          JudgingCriteria(id: 'c1', name: 'Creativity', description: 'Originality', maxScore: 10, weight: 0.3),
          JudgingCriteria(id: 'c2', name: 'Technique', description: 'Skill', maxScore: 10, weight: 0.3),
        ],
        createdAt: DateTime.now(),
        registrationStart: _regStart,
        registrationEnd: _regEnd,
        submissionStart: _subStart,
        submissionEnd: _subEnd,
        judgingStart: _subEnd.add(const Duration(days: 1)),
        judgingEnd: _subEnd.add(const Duration(days: 10)),
        resultsDate: _subEnd.add(const Duration(days: 15)),
        prizes: {'1st': '₦500k + Scholarship', '2nd': '₦200k', 'Exhibition': 'Nike Art Gallery'},
        allowOfflineSubmission: _allowOffline,
        lowBandwidthMode: _lowBandwidth,
        isScholarshipLinked: _scholarship,
        isExhibitionLinked: _exhibition,
        tags: ['National'],
      );
      await CompetitionService().createCompetition(comp);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Competition created! Secure judging roles set, offline support enabled."), backgroundColor: AppColors.success));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, title: Text("Create National Competition", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(controller: _titleCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Title *', prefixIcon: Icon(Icons.emoji_events, color: AppColors.primaryGold))),
        const SizedBox(height: 12),
        TextField(controller: _themeCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Theme')),
        const SizedBox(height: 12),
        TextField(controller: _descCtrl, maxLines: 3, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Description')),
        const SizedBox(height: 16),
        SwitchListTile(value: _allowOffline, activeColor: AppColors.primaryGold, title: Text("Allow Offline Submission", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontSize: 13)), subtitle: Text("Students in limited internet areas can queue offline", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _allowOffline = v)),
        SwitchListTile(value: _lowBandwidth, activeColor: AppColors.primaryGold, title: Text("Low-Bandwidth Mode", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontSize: 13)), subtitle: Text("Compress images, thumbnail-first judging", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _lowBandwidth = v)),
        SwitchListTile(value: _scholarship, activeColor: Colors.purpleAccent, title: Text("Link to Scholarships", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontSize: 13)), subtitle: Text("Top winners eligible for scholarship portal", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _scholarship = v)),
        SwitchListTile(value: _exhibition, activeColor: AppColors.primaryGold, title: Text("Link to Exhibition", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontSize: 13)), subtitle: Text("Future-ready for Nike Art Gallery exhibition", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), onChanged: (v) => setState(() => _exhibition = v)),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _loading ? null : _create, child: _loading ? const CircularProgressIndicator() : const Text("CREATE COMPETITION"))),
      ]),
    );
  }
}
