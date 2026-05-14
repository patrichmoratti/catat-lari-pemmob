import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/run_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/run_service.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../../../widgets/run_card.dart';
import '../profile/profile_view.dart';
import '../run/create_run_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        AuthService(),
        RunService(),
      )..init(),
      child: const _DashboardViewBody(),
    );
  }
}

class _DashboardViewBody extends StatelessWidget {
  const _DashboardViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = vm.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'User tidak ditemukan',
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _DashHeader(
              userName:
                  user.name.split(' ').first,

              onProfileTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProfileView(),
                  ),
                );

                if (!context.mounted) {
                  return;
                }

                await context
                    .read<
                        DashboardViewModel>()
                    .refresh();
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                4,
                20,
                0,
              ),
              child: _StatsBanner(
                totalDist:
                    vm.totalDistance,
                totalDurMin:
                    vm.totalDuration,
                totalCal:
                    vm.totalCalories,
                weekCount:
                    vm.weekRuns.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: _WeekStreak(
                weekRuns: vm.weekRuns,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                12,
              ),
              child: Row(
                children: [
                  const Text(
                    'Riwayat Aktivitas',
                    style: TextStyle(
                      color: AppColors
                          .textPrimary,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  if (vm.runs.isNotEmpty)
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.12,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),

                      child: Text(
                        '${vm.runs.length} sesi',

                        style: GoogleFonts
                            .plusJakartaSans(
                          color: AppColors
                              .primary,

                          fontSize: 12,

                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (vm.runs.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyState(),
            )

          else
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                120,
              ),

              sliver: SliverList(
                delegate:
                    SliverChildBuilderDelegate(
                  (ctx, i) {
                    final run =
                        vm.runs[i];

                    return Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        bottom: 12,
                      ),

                      child: RunCard(
                        run: run,

                        onEdit:
                            () async {
                          await Navigator
                              .push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      CreateRunView(
                                existing:
                                    run,
                              ),
                            ),
                          );

                          if (!context
                              .mounted) {
                            return;
                          }

                          await context
                              .read<
                                  DashboardViewModel>()
                              .refresh();
                        },

                        onDelete:
                            () async {
                          await context
                              .read<
                                  DashboardViewModel>()
                              .deleteRun(
                                run.id,
                              );
                        },
                      ),
                    );
                  },

                  childCount:
                      vm.runs.length,
                ),
              ),
            ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateRunView(),
            ),
          );

          if (!context.mounted) {
            return;
          }

          await context
              .read<DashboardViewModel>()
              .refresh();
        },

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: const Text(
          'Catat Lari',
        ),

        backgroundColor:
            AppColors.primary,
      ),
    );
  }
}

class _DashHeader extends StatelessWidget {
  final String userName;

  final VoidCallback onProfileTap;

  const _DashHeader({
    required this.userName,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,

      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          16,
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Row(
                    children: [
                      Text(
                        'Halo, $userName ',

                        style:
                            const TextStyle(
                          color: AppColors
                              .textPrimary,

                          fontSize: 22,

                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),

                      const Text(
                        '👋',

                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Text(
                    DateFormat(
                      'EEEE, d MMMM yyyy',
                      'id_ID',
                    ).format(
                      DateTime.now(),
                    ),

                    style:
                        const TextStyle(
                      color: AppColors
                          .textSecondary,

                      fontSize: 13,
                    ),
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
                  gradient:
                      const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors
                          .primaryLight,
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: Center(
                  child: Text(
                    userName[0]
                        .toUpperCase(),

                    style:
                        const TextStyle(
                      color: Colors.white,

                      fontSize: 18,

                      fontWeight:
                          FontWeight
                              .w800,
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
    final totalH =
        totalDurMin ~/ 60;

    final totalM =
        totalDurMin % 60;

    final durStr = totalH > 0
        ? '${totalH}j ${totalM}m'
        : '${totalM}m';

    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Expanded(
            child: _BannerStat(
              value: totalDist
                  .toStringAsFixed(1),

              unit: 'km',

              label: 'Jarak',
            ),
          ),

          Expanded(
            child: _BannerStat(
              value: durStr,

              unit: '',

              label: 'Durasi',
            ),
          ),

          Expanded(
            child: _BannerStat(
              value: totalCal.toString(),

              unit: 'kkal',

              label: 'Kalori',
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String value;

  final String unit;

  final String label;

  const _BannerStat({
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value $unit',

          style: const TextStyle(
            color:
                AppColors.textPrimary,

            fontSize: 18,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: const TextStyle(
            color: AppColors
                .textSecondary,

            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _WeekStreak extends StatelessWidget {
  final List<RunModel> weekRuns;

  const _WeekStreak({
    required this.weekRuns,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada aktivitas',
      ),
    );
  }
}