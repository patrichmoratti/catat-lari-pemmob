import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/run_model.dart';
import '../theme/app_theme.dart';

class RunCard extends StatelessWidget {
  final RunModel run;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const RunCard({
    super.key,
    required this.run,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: [
          _CardHeader(
            run: run,
            onEdit: onEdit,
            onDelete: onDelete,
          ),

          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),

          _CardMetrics(
            run: run,
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final RunModel run;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const _CardHeader({
    required this.run,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        8,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_run_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Aktivitas Lari',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        color:
                            AppColors.textPrimary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 2),

                Text(
                  DateFormat(
                    'EEE, d MMM yyyy',
                    'id_ID',
                  ).format(run.date),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                        color: AppColors
                            .textSecondary,
                      ),
                ),
              ],
            ),
          ),

          _ActionsMenu(
            run: run,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CardMetrics extends StatelessWidget {
  final RunModel run;

  const _CardMetrics({
    required this.run,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        14,
      ),
      child: Row(
        children: [
          _Metric(
            icon: Icons.route_rounded,
            value: run.distanceFormatted,
            label: 'Jarak',
            highlight: true,
          ),

          _divider(),

          _Metric(
            icon: Icons.timer_outlined,
            value: run.durationFormatted,
            label: 'Durasi',
          ),

          _divider(),

          _Metric(
            icon: Icons.speed_rounded,
            value: run.paceFormatted,
            label: '/km',
          ),

          _divider(),

          _Metric(
            icon:
                Icons.local_fire_department_rounded,
            value: '${run.calories}',
            label: 'kkal',
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      margin:
          const EdgeInsets.symmetric(horizontal: 6),
      color: AppColors.cardBorder,
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;

  final String value;

  final String label;

  final bool highlight;

  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: highlight
                ? AppColors.primary
                : AppColors.textSecondary,
            size: 16,
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? AppColors.primary
                  : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  final RunModel run;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const _ActionsMenu({
    required this.run,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.textSecondary,
        size: 20,
      ),

      padding: EdgeInsets.zero,

      onSelected: (value) async {
        if (value == 'edit') {
          onEdit?.call();
        }

        else if (value == 'delete') {
          final ok =
              await _confirmDelete(context);

          if (ok && context.mounted) {
            onDelete?.call();

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Aktivitas dihapus',
                ),
              ),
            );
          }
        }
      },

      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 18,
              ),

              SizedBox(width: 10),

              Text('Edit'),
            ],
          ),
        ),

        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 18,
              ),

              SizedBox(width: 10),

              Text(
                'Hapus',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title:
              const Text('Hapus Aktivitas'),

          content: const Text(
            'Aktivitas lari ini akan dihapus permanen. Lanjutkan?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.error,
                minimumSize:
                    const Size(80, 40),
              ),

              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}