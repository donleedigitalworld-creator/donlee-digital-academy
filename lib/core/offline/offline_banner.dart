import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/offline_service.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final offline = Provider.of<OfflineService>(context);
    final pending = offline.pendingCount;

    if (offline.isOnline && pending == 0 && !offline.lowBandwidthMode) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: !offline.isOnline ? Colors.orangeAccent.withOpacity(0.9) : offline.lowBandwidthMode ? Colors.blueAccent.withOpacity(0.9) : AppColors.success.withOpacity(0.9),
      child: Row(children: [
        Icon(!offline.isOnline ? Icons.wifi_off : offline.lowBandwidthMode ? Icons.signal_cellular_alt : Icons.sync, size: 14, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(child: Text(!offline.isOnline ? "Offline Mode: ${pending} items queued - will auto-sync when back online (smart sync, no duplicate)" : offline.lowBandwidthMode ? "Low-Bandwidth Mode ON: Images compressed, thumbnail-first - saves data (${pending} pending sync)" : "Smart Sync: ${pending} items synced - camera uploads secure", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white))),
        if (pending > 0 || !offline.isOnline) GestureDetector(onTap: () => Navigator.pushNamed(context, '/offlineMode'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text("View Queue →", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)))),
      ]),
    );
  }
}

class LowBandwidthToggle extends StatelessWidget {
  const LowBandwidthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final offline = Provider.of<OfflineService>(context);
    return SwitchListTile(
      value: offline.lowBandwidthMode,
      activeColor: AppColors.primaryGold,
      title: Text("Low-Bandwidth Mode", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      subtitle: Text("Save data: compress uploads, load thumbnails first, offline queue", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
      onChanged: (v) => offline.setLowBandwidthMode(v),
    );
  }
}
