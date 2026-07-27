import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/security/security_model.dart';
import '../../../services/security/security_service.dart';
import '../../../widgets/custom_app_bar.dart';

class SecurityDashboardScreen extends StatefulWidget {
  const SecurityDashboardScreen({super.key});

  @override
  State<SecurityDashboardScreen> createState() => _SecurityDashboardScreenState();
}

class _SecurityDashboardScreenState extends State<SecurityDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final SecurityService _service = SecurityService();
  List<SecurityAuditLog> _logs = [];
  List<RolePermission> _roles = [];
  List<DataRetentionPolicy> _policies = [];
  List<FeatureFlag> _flags = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _service.init();
    _load();
  }

  Future<void> _load() async {
    final logs = await _service.getAuditLogs();
    final roles = await _service.getRolePermissions();
    final policies = await _service.getRetentionPolicies();
    final flags = await _service.getFeatureFlags();
    setState(() {
      _logs = logs;
      _roles = roles;
      _policies = policies;
      _flags = flags;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Security & Privacy Center", subtitle: "2FA, biometrics, audit logs, role matrix, retention, future scalability"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, isScrollable: true, tabs: const [Tab(text: "Overview"), Tab(text: "Audit Logs"), Tab(text: "Roles & Flags"), Tab(text: "Retention & Scalability")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [_buildOverview(), _buildLogs(), _buildRoles(), _buildRetention()])),
      ]),
    );
  }

  Widget _buildOverview() {
    final metrics = _service.getScalabilityMetrics();
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7, children: [
        _secStat("Total Users", "${metrics['totalUsers']}", Icons.people, AppColors.primaryGold),
        _secStat("Active Now", "${metrics['activeNow']}", Icons.online_prediction, AppColors.success),
        _secStat("API Version", "${metrics['apiVersion']}", Icons.api, Colors.blueAccent),
        _secStat("Storage Used", "${metrics['storageUsedGB']} GB", Icons.storage, Colors.orangeAccent),
        _secStat("AI Req/Day", "${metrics['aiRequestsPerDay']}", Icons.auto_awesome, Colors.purpleAccent),
        _secStat("CDN Hit Rate", "${(metrics['cdnHitRate'] * 100).toInt()}%", Icons.speed, AppColors.success),
      ]),
      const SizedBox(height: 20),
      Text("Security Controls", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Biometric Auth", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryWhite)),
          Switch(value: _service.isBiometricEnabled, activeColor: AppColors.success, onChanged: (v) async { await _service.enableBiometric(); setState(() {}); }),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Two-Factor Auth (2FA)", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryWhite)),
          Switch(value: _service.isTwoFactorEnabled, activeColor: AppColors.success, onChanged: (v) async { await _service.enableTwoFactor('user@example.com'); setState(() {}); }),
        ]),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.security, size: 12, color: AppColors.primaryGold), const SizedBox(width: 6), Expanded(child: Text("2FA sends code via email/SMS, biometric uses Android BiometricPrompt / iOS FaceID/TouchID. Audit logs all auth events. Low-bandwidth: 2FA via SMS works offline queue.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight)))])),
      ])),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Future Scalability - National Scale 100k+", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
        const SizedBox(height: 6),
        Text("• Multi-tenant: schoolId tenant isolation, regional sharding, tenant-aware rules\n• Feature Flags: national_dashboard, parent_portal, ai_tutor etc toggled per role via FeatureFlag model - nationalAdmin can enable for specific states\n• API Versioning: v5, microservices ready (auth, competition, ai, analytics separate), CDN 89% hit for resource library\n• Localization: 5 languages en/yo/ig/ha/fr via voice learning, offline bundles for Phase 3\n• Auto-scaling: aiRequestsPerDay 12k, storage 234GB, activeNow 1.2k, offlineQueueAvg 2.3 - designed for 100k+ students, autoScale true\n• Modular: Each feature in lib/features/* independent, provider injection, easy to extract to microservice", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
      ])),
    ]);
  }

  Widget _buildLogs() {
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _logs.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (c, i) {
      final log = _logs[i];
      return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: log.isSuspicious ? AppColors.error.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: log.isSuspicious ? AppColors.error.withOpacity(0.15) : _levelColor(log.level).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_actionIcon(log.action), size: 16, color: log.isSuspicious ? AppColors.error : _levelColor(log.level))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${log.userName} • ${log.action.name} • ${log.level.name}", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: log.isSuspicious ? AppColors.error : AppColors.primaryWhite)),
          Text("${log.details['resource'] ?? ''} • ${log.ipAddress} • ${log.deviceInfo} • ${_timeAgo(log.timestamp)}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          if (log.isSuspicious) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Suspicious - requires review", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.error))),
        ])),
      ]));
    });
  }

  Widget _buildRoles() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text("Role Permissions Matrix - Phase 5", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 12),
      ..._roles.map((role) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(role.role.toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
          const Spacer(),
          if (role.canAccessAI) _permBadge("AI", AppColors.primaryGold),
          if (role.canAccessCompetitionJudging) _permBadge("Judging", Colors.orangeAccent),
          if (role.canManageUsers) _permBadge("Users", Colors.blueAccent),
          if (role.canViewAnalytics) _permBadge("Analytics", Colors.purpleAccent),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: role.permissions.map((p) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(p, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
        const SizedBox(height: 8),
        Text("Feature Flags:", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        Wrap(spacing: 4, children: _flags.where((f) => f.enabledForRoles.contains(role.role) || f.enabledForRoles.contains('all')).map((f) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: f.enabled ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(6)), child: Text(f.key, style: GoogleFonts.poppins(fontSize: 8, color: f.enabled ? AppColors.success : AppColors.mediumGrey)))).toList()),
      ]))),
    ]);
  }

  Widget _buildRetention() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text("Data Retention & Privacy Policies", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 12),
      ..._policies.map((policy) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(policy.dataType, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: policy.autoDelete ? Colors.orangeAccent.withOpacity(0.15) : AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("${policy.retentionDays} days ${policy.autoDelete ? 'auto-delete' : ''}", style: GoogleFonts.poppins(fontSize: 9, color: policy.autoDelete ? Colors.orangeAccent : AppColors.success))),
        ]),
        const SizedBox(height: 6),
        Text(policy.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 6),
        Row(children: [
          Icon(policy.encryptAtRest ? Icons.lock : Icons.lock_open, size: 12, color: policy.encryptAtRest ? AppColors.success : AppColors.error),
          const SizedBox(width: 4),
          Text(policy.encryptAtRest ? "Encrypted at rest" : "Not encrypted", style: GoogleFonts.poppins(fontSize: 9, color: policy.encryptAtRest ? AppColors.success : AppColors.error)),
        ]),
      ]))),
      const SizedBox(height: 20),
      Text("Feature Flags - Scalability", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 12),
      ..._flags.map((flag) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: flag.enabled ? AppColors.success.withOpacity(0.2) : AppColors.primaryBlackLighter)), child: Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: flag.enabled ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(flag.enabled ? Icons.toggle_on : Icons.toggle_off, color: flag.enabled ? AppColors.success : AppColors.mediumGrey)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(flag.key, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text(flag.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          Text("Roles: ${flag.enabledForRoles.join(', ')} ${flag.requiresNationalAdmin ? '• nationalAdmin only' : ''}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ])),
        Switch(value: flag.enabled, activeColor: AppColors.success, onChanged: (v) {}),
      ]))),
    ]);
  }

  Widget _secStat(String label, String value, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 14, color: color)), Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryWhite)),
    ]));
  }

  Widget _permBadge(String label, Color color) {
    return Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(label, style: GoogleFonts.poppins(fontSize: 7, color: color)));
  }

  Color _levelColor(SecurityLevel l) {
    switch (l) {
      case SecurityLevel.low: return AppColors.success;
      case SecurityLevel.medium: return Colors.blueAccent;
      case SecurityLevel.high: return Colors.orangeAccent;
      case SecurityLevel.critical: return AppColors.error;
    }
  }

  IconData _actionIcon(AuditAction a) {
    switch (a) {
      case AuditAction.login: return Icons.login;
      case AuditAction.competitionJudged: return Icons.gavel;
      case AuditAction.certificateIssued: return Icons.workspace_premium;
      case AuditAction.aiAnalysis: return Icons.auto_awesome;
      default: return Icons.security;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
