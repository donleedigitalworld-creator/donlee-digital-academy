import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';
import '../../../services/competition_service.dart';
import '../widgets/competition_card.dart';

class JudgingDashboardScreen extends StatefulWidget {
  final CompetitionModel competition;
  const JudgingDashboardScreen({super.key, required this.competition});

  @override
  State<JudgingDashboardScreen> createState() => _JudgingDashboardScreenState();
}

class _JudgingDashboardScreenState extends State<JudgingDashboardScreen> {
  final CompetitionService _service = CompetitionService();
  int _selectedIndex = 0;
  Map<String, int> _criteriaScores = {};
  String _feedback = '';

  // Mock submissions for judging
  final List<Map<String, dynamic>> _mockSubs = [
    {
      'student': 'Amara Okafor',
      'school': 'Donlee Main - Lagos',
      'title': 'Unity Mask - Mother and Child',
      'category': 'Senior Painting',
      'image': 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800',
      'isOffline': false,
      'lowBandwidth': false,
      'cameraVerified': true,
    },
    {
      'student': 'Tunde Adebayo',
      'school': 'Greensprings School',
      'title': 'Danfo Dreams',
      'category': 'Digital Art Open',
      'image': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800',
      'isOffline': true,
      'lowBandwidth': true,
      'cameraVerified': false,
    },
    {
      'student': 'Chioma Nwosu',
      'school': 'Donlee Abuja Hub',
      'title': 'Grandmothers Hands',
      'category': 'Portrait Masters',
      'image': 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
      'isOffline': false,
      'lowBandwidth': false,
      'cameraVerified': true,
    },
  ];

  double _calculateTotal() {
    double total = 0;
    double weightedTotal = 0;
    for (var crit in widget.competition.judgingCriteria) {
      final score = _criteriaScores[crit.id] ?? 0;
      total += score;
      weightedTotal += score * crit.weight;
    }
    return weightedTotal;
  }

  @override
  Widget build(BuildContext context) {
    final current = _mockSubs[_selectedIndex];
    final weightedScore = _calculateTotal();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Judging Dashboard", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text("${widget.competition.title} • Secure Role: Judge", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.security, color: AppColors.success), onPressed: () {}), IconButton(icon: const Icon(Icons.sync, color: AppColors.primaryWhite), onPressed: () {})],
      ),
      body: Row(children: [
        if (MediaQuery.of(context).size.width > 700)
          Container(
            width: 320,
            decoration: BoxDecoration(color: AppColors.cardBlack, border: Border(right: BorderSide(color: AppColors.primaryBlackLighter))),
            child: Column(children: [
              Container(padding: const EdgeInsets.all(16), color: AppColors.primaryBlackLight, child: Row(children: [
                Icon(Icons.gavel, color: AppColors.primaryGold, size: 18),
                const SizedBox(width: 8),
                Text("Submissions to Judge (${_mockSubs.length})", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Blind Review", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.success))),
              ])),
              Expanded(
                child: ListView.separated(
                  itemCount: _mockSubs.length,
                  separatorBuilder: (_, __) => Divider(color: AppColors.primaryBlackLighter, height: 1),
                  itemBuilder: (c, i) {
                    final s = _mockSubs[i];
                    final isSel = i == _selectedIndex;
                    return ListTile(
                      selected: isSel,
                      selectedTileColor: AppColors.primaryGold.withOpacity(0.1),
                      leading: Stack(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: CachedNetworkImage(imageUrl: s['image'], width: 50, height: 50, fit: BoxFit.cover)),
                        if (s['isOffline']) Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle), child: const Icon(Icons.wifi_off, size: 8, color: Colors.white))),
                      ]),
                      title: Text(s['title'], style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? AppColors.primaryGold : AppColors.primaryWhite), maxLines: 1),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("${s['student']} • ${s['school']}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 1),
                        const SizedBox(height: 2),
                        Row(children: [
                          if (s['cameraVerified']) Container(margin: const EdgeInsets.only(right: 4), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text("Camera", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.success))),
                          if (s['lowBandwidth']) Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text("Low-BW", style: GoogleFonts.poppins(fontSize: 7, color: Colors.blueAccent))),
                        ]),
                      ]),
                      onTap: () => setState(() => _selectedIndex = i),
                    );
                  },
                ),
              ),
              Container(padding: const EdgeInsets.all(12), color: AppColors.primaryBlackLight, child: Row(children: [const Icon(Icons.security, size: 12, color: AppColors.success), const SizedBox(width: 6), Expanded(child: Text("Secure: Judges cannot see other scores until chief judge finalizes. No student info shown beyond name/school. Role-based.", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))])),
            ]),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (MediaQuery.of(context).size.width <= 700) ...[
                SizedBox(height: 60, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _mockSubs.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (c, i) => ChoiceChip(label: Text(_mockSubs[i]['title'], style: GoogleFonts.poppins(fontSize: 10)), selected: i == _selectedIndex, selectedColor: AppColors.primaryGold, onSelected: (_) => setState(() => _selectedIndex = i)))),
                const SizedBox(height: 16),
              ],
              ClipRRect(borderRadius: BorderRadius.circular(16), child: Stack(children: [
                CachedNetworkImage(imageUrl: current['image'], width: double.infinity, height: 350, fit: BoxFit.cover),
                Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(20)), child: Row(children: [
                  Icon(current['cameraVerified'] ? Icons.verified : Icons.warning, size: 12, color: current['cameraVerified'] ? AppColors.success : Colors.orangeAccent),
                  const SizedBox(width: 4),
                  Text(current['cameraVerified'] ? "Camera Verified Original" : "Gallery Upload", style: GoogleFonts.poppins(fontSize: 10, color: Colors.white)),
                ]))),
                if (current['isOffline']) Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.wifi_off, size: 12, color: Colors.white), const SizedBox(width: 4), Text("Offline Synced", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))]))),
              ])),
              const SizedBox(height: 16),
              Row(children: [Expanded(child: Text(current['title'], style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(20)), child: Text("Avg: ${weightedScore.toStringAsFixed(1)}/10", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)))]),
              const SizedBox(height: 4),
              Text("${current['student']} • ${current['school']} • ${current['category']}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGold)),
              const SizedBox(height: 4),
              if (current['lowBandwidth']) Row(children: [const Icon(Icons.signal_cellular_alt, size: 12, color: Colors.blueAccent), const SizedBox(width: 4), Text("Low-bandwidth mode: showing high-res after thumbnail. Student in limited connectivity area - offline queued then synced.", style: GoogleFonts.poppins(fontSize: 10, color: Colors.blueAccent))]),
              const SizedBox(height: 20),
              Text("Scoring Criteria (5) - Weighted", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              ...widget.competition.judgingCriteria.map((crit) => JudgingCriteriaWidget(criteria: crit, selectedScore: _criteriaScores[crit.id], onScoreSelected: (score) => setState(() => _criteriaScores[crit.id] = score))),
              const SizedBox(height: 16),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Judge Feedback (visible to student after results)", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
                const SizedBox(height: 10),
                TextField(maxLines: 4, onChanged: (v) => _feedback = v, style: const TextStyle(color: AppColors.primaryWhite, fontSize: 12), decoration: InputDecoration(hintText: 'Excellent composition, strong theme interpretation. For exhibition, consider larger format...', hintStyle: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), filled: true, fillColor: AppColors.primaryBlackLighter, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Weighted Total", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), Text("${weightedScore.toStringAsFixed(2)} / 10", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGold))])),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Raw Total", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), Text("${_criteriaScores.values.fold(0, (a, b) => a + b)} / ${widget.competition.judgingCriteria.length * 10}", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))])),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: OutlinedButton(onPressed: () { setState(() { _criteriaScores.clear(); _feedback = ''; }); }, child: const Text("Clear"))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Score ${weightedScore.toStringAsFixed(1)} submitted securely! Role: Judge - blind review"), backgroundColor: AppColors.success)); }, child: const Text("Submit Score - Secure"))),
                ]),
              ])),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.shield, size: 16, color: AppColors.success), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Security & Future-Ready", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text("Judging roles: judge, chiefJudge, moderator, admin. Chief judge finalizes weighted scores, resolves ties. Scores encrypted, only visible after finalization. Top 10 auto-flagged for exhibition (Nike Art Gallery), scholarship linkage for winners. Exhibition status: pending/selected/exhibited/awarded.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4))]))])),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
