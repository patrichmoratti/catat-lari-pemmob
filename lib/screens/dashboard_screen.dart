import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/run_model.dart';
import '../providers/auth_provider.dart';
import '../providers/run_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/run_card.dart';
import 'create_run_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final runProv = context.watch<RunProvider>();
    final user = auth.currentUser!;
    final uid = user.id;
    final runs = runProv.runsForUser(uid);
    final weekRuns = runProv.thisWeekRunsForUser(uid);
    final totalDist = runProv.totalDistanceForUser(uid);
    final totalDur = runProv.totalDurationForUser(uid);
    final totalCal = runProv.totalCaloriesForUser(uid);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: _DashHeader(
              userName: user.name.split(' ').first,
              onProfileTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
          ),

          // ── Stats Banner ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _StatsBanner(
                totalDist: totalDist,
                totalDurMin: totalDur,
                totalCal: totalCal,
                weekCount: weekRuns.length,
              ),
            ),
          ),

          // ── Weekly Streak ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _WeekStreak(weekRuns: weekRuns),
            ),
          ),

          // ── Section header ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Riwayat Aktivitas',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (runs.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${runs.length} sesi',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Run list / Empty ─────────────────────────────────
          if (runs.isEmpty)
            SliverToBoxAdapter(child: _EmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RunCard(
                      run: runs[i],
                      onEdit: () => Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CreateRunScreen(existing: runs[i]),
                        ),
                      ),
                    ),
                  ),
                  childCount: runs.length,
                ),
              ),
            ),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateRunScreen()),
        ),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'Catat Lari',
          style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700, fontSize: 14),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────

class _DashHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;

  const _DashHeader(
      {required this.userName, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Halo, $userName ',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text('👋', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                        .format(DateTime.now()),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats Banner ─────────────────────────────────────────────

class _StatsBanner extends StatelessWidget {
  final double totalDist;
  final int totalDurMin;
  final int totalCal;
  final int weekCount;

  const _StatsBanner({
    required this.totalDist,
    required this.totalDurMin,
    required this.totalCal,
    required this.weekCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalH = totalDurMin ~/ 60;
    final totalM = totalDurMin % 60;
    final durStr = totalH > 0 ? '${totalH}j ${totalM}m' : '${totalM}m';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A0C00),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                'Statistik Keseluruhan',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$weekCount lari minggu ini',
                  style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _BannerStat(
                  value: totalDist.toStringAsFixed(1),
                  unit: 'km',
                  label: 'Jarak Total'),
              _vDivider(),
              _BannerStat(value: durStr, unit: '', label: 'Waktu Total'),
              _vDivider(),
              _BannerStat(
                  value: totalCal.toString(),
                  unit: 'kkal',
                  label: 'Kalori Terbakar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.cardBorder,
      );
}

class _BannerStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;

  const _BannerStat(
      {required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Week Streak ──────────────────────────────────────────────

class _WeekStreak extends StatelessWidget {
  final List<RunModel> weekRuns;
  const _WeekStreak({required this.weekRuns});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final runDays = weekRuns.map((r) => r.date.weekday).toSet();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            'Minggu Ini',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          ...List.generate(7, (i) {
            final day = i + 1;
            final isToday = now.weekday == day;
            final hasRun = runDays.contains(day);
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: hasRun
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !hasRun
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4))
                          : null,
                    ),
                    child: hasRun
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[i],
                    style: TextStyle(
                      color:
                          isToday ? AppColors.primary : AppColors.textHint,
                      fontSize: 9,
                      fontWeight: isToday
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.directions_run_rounded,
                color: AppColors.textHint, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada aktivitas lari',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan tombol + di bawah untuk\nmulai mencatat larimu hari ini!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
