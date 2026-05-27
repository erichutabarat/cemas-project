import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:deteksi_cemas/features/dashboard_admin/domain/repository/inspection_repository.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/inspection_detail_screen.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/inspection_model.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class MedicalAdminScreen extends StatefulWidget {
  const MedicalAdminScreen({super.key});

  @override
  State<MedicalAdminScreen> createState() => _MedicalAdminScreenState();
}

class _MedicalAdminScreenState extends State<MedicalAdminScreen> {
  final _repo = InspectionsRepository();
  late Future<List<Inspection>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getInspections();
  }

  void _refresh() => setState(() => _future = _repo.getInspections());

  /// Group a flat list by userId, sorted by userId asc.
  Map<int, List<Inspection>> _groupByUser(List<Inspection> list) {
    final Map<int, List<Inspection>> map = {};
    for (final insp in list) {
      map.putIfAbsent(insp.userID, () => []).add(insp);
    }
    // Sort inspections within each group newest-first
    for (final group in map.values) {
      group.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: _AppBar(onRefresh: _refresh),
      body: FutureBuilder<List<Inspection>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }
          if (snap.hasError) {
            return _ErrorView(
              message: snap.error.toString(),
              onRetry: _refresh,
            );
          }
          final grouped = _groupByUser(snap.data ?? []);
          if (grouped.isEmpty) {
            return const _EmptyView();
          }
          return _GroupedList(grouped: grouped);
        },
      ),
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  const _AppBar({required this.onRefresh});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE2E8F0)),
      ),
      titleSpacing: 0,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(
          Icons.medical_services_rounded,
          color: Color(0xFF1E3A8A),
          size: 26,
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Inspections',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'Grouped by patient',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B)),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─── Grouped List ─────────────────────────────────────────────────────────────

class _GroupedList extends StatelessWidget {
  final Map<int, List<Inspection>> grouped;
  const _GroupedList({required this.grouped});

  @override
  Widget build(BuildContext context) {
    final userIds = grouped.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: userIds.length,
      itemBuilder: (ctx, i) {
        final uid = userIds[i];
        return _UserCard(userId: uid, inspections: grouped[uid]!);
      },
    );
  }
}

// ─── User Card (collapsible group) ───────────────────────────────────────────

class _UserCard extends StatefulWidget {
  final int userId;
  final List<Inspection> inspections;

  const _UserCard({required this.userId, required this.inspections});

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _expandAnim;

  int get _checkedCount => widget.inspections.where((i) => i.checked).length;
  int get _total => widget.inspections.length;
  double get _progress => _total == 0 ? 0 : _checkedCount / _total;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 0,
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  Color get _progressColor {
    if (_progress == 1.0) return const Color(0xFF16A34A);
    if (_progress >= 0.5) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // ── Header ──
            InkWell(
              onTap: _toggle,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar circle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'U${widget.userId}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // User info + progress bar
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'User #${widget.userId}',
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              // checked/total pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _progressColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _progressColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '$_checkedCount / $_total checked',
                                  style: TextStyle(
                                    color: _progressColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progress,
                              minHeight: 4,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation(
                                _progressColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Chevron
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFCBD5E1),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Inspection list ──
            SizeTransition(
              sizeFactor: _expandAnim,
              child: Column(
                children: [
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  ...widget.inspections.map(
                    (insp) => _InspectionRow(inspection: insp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Inspection Row ───────────────────────────────────────────────────────────

class _InspectionRow extends StatelessWidget {
  final Inspection inspection;
  const _InspectionRow({required this.inspection});

  static final _dateFmt = DateFormat('dd MMM yyyy  HH:mm');

  Color get _statusColor =>
      inspection.checked ? const Color(0xFF16A34A) : const Color(0xFFD97706);

  String get _statusLabel => inspection.checked ? 'Checked' : 'Pending';

  Color get _levelColor {
    switch (inspection.result?.anxietyLevel.toLowerCase()) {
      case 'low':
        return const Color(0xFF16A34A);
      case 'moderate':
        return const Color(0xFFD97706);
      case 'high':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = inspection.result;
    final date = _dateFmt.format(inspection.createdAt.toLocal());

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true, // gives the ✕ close button on iOS
            builder: (_) => InspectionDetailScreen(inspection: inspection),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status dot
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: _statusColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _statusColor.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID + status badge
                  Row(
                    children: [
                      Text(
                        'Inspection #${inspection.id}',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _Badge(label: _statusLabel, color: _statusColor),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Date
                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 16,
                    ),
                  ),
                  // Result chips (if available)
                  if (result != null) ...[
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 6,
                      children: [
                        _Chip(
                          icon: Icons.psychology_alt_rounded,
                          label: result.anxietyLevel,
                          color: _levelColor,
                        ),
                        _Chip(
                          icon: Icons.favorite_rounded,
                          label: '${result.bpm} BPM',
                          color: const Color(0xFF3B82F6),
                        ),
                        _Chip(
                          icon: Icons.monitor_heart_rounded,
                          label: 'HRV ${result.hrv}',
                          color: const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                  ] else if (!inspection.checked) ...[
                    const SizedBox(height: 9),
                    const Text(
                      'No result yet — awaiting analysis',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small widgets ────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── State views ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF1E3A8A), strokeWidth: 2.5),
          SizedBox(height: 14),
          Text(
            'Loading inspections…',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Color(0xFFDC2626),
              size: 44,
            ),
            const SizedBox(height: 14),
            const Text(
              'Failed to load',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, color: Color(0xFFCBD5E1), size: 48),
          SizedBox(height: 12),
          Text(
            'No inspections yet',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
