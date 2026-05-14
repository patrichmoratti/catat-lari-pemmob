import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/run_model.dart';
import '../../services/auth_service.dart';
import '../../services/run_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/run/create_run_viewmodel.dart';
import '../../widgets/custom_button.dart';

class CreateRunView extends StatelessWidget {
  final RunModel? existing;

  const CreateRunView({
    super.key,
    this.existing,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRunViewModel(
        RunService(),
        AuthService(),
        existing,
      ),
      child: const _CreateRunViewBody(),
    );
  }
}

class _CreateRunViewBody extends StatelessWidget {
  const _CreateRunViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateRunViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          vm.isEdit
              ? 'Edit Aktivitas'
              : 'Catat Lari Baru',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel('Tanggal Lari'),

                const SizedBox(height: 8),

                _DatePicker(
                  date: vm.selectedDate,
                  onTap: () {
                    vm.pickDate(context);
                  },
                ),

                const SizedBox(height: 24),

                const _SectionLabel('Jarak Tempuh'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: vm.distanceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    suffixText: 'km',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Masukkan jarak tempuh';
                    }

                    final d = double.tryParse(
                      v.replaceAll(',', '.'),
                    );

                    if (d == null || d <= 0) {
                      return 'Jarak tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const _SectionLabel('Durasi'),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: vm.hourController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          suffixText: 'jam',
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: vm.minuteController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          suffixText: 'menit',
                        ),
                      ),
                    ),
                  ],
                ),

                if (vm.previewPace != null) ...[
                  const SizedBox(height: 28),

                  _PreviewCard(
                    pace: vm.previewPace!,
                    calories: vm.previewCalories ?? 0,
                    dist: vm.previewDistance ?? 0,
                  ),
                ],

                const SizedBox(height: 32),

                CustomButton(
                  text: vm.isEdit
                      ? 'Simpan Perubahan'
                      : 'Simpan Aktivitas',
                  isLoading: vm.isSaving,
                  icon: vm.isEdit
                      ? Icons.save_rounded
                      : Icons.check_circle_rounded,
                  onPressed: () async {
                    final success = await vm.save();

                    if (!context.mounted) return;

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Gagal menyimpan aktivitas',
                          ),
                        ),
                      );

                      return;
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          vm.isEdit
                              ? 'Aktivitas berhasil diperbarui!'
                              : 'Aktivitas lari tercatat! 🎉',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final DateTime date;

  final VoidCallback onTap;

  const _DatePicker({
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded),

            const SizedBox(width: 12),

            Text(
              DateFormat(
                'EEEE, d MMMM yyyy',
                'id_ID',
              ).format(date),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String pace;
  final int calories;
  final double dist;

  const _PreviewCard({
    required this.pace,
    required this.calories,
    required this.dist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PreviewItem(
              label: 'Pace',
              value: pace,
              unit: '/km',
              icon: Icons.speed_rounded,
            ),
          ),

          Expanded(
            child: _PreviewItem(
              label: 'Kalori',
              value: '$calories',
              unit: 'kkal',
              icon: Icons.local_fire_department_rounded,
            ),
          ),

          Expanded(
            child: _PreviewItem(
              label: 'Kategori',
              value: _category(dist),
              unit: '',
              icon: Icons.emoji_events_rounded,
            ),
          ),
        ],
      ),
    );
  }

  String _category(double km) {
    if (km < 3) return 'Easy';
    if (km < 7) return 'Moderate';
    if (km < 12) return 'Long';
    return 'Ultra';
  }
}

class _PreviewItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _PreviewItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
        ),

        const SizedBox(height: 6),

        Text(
          unit.isEmpty
              ? value
              : '$value $unit',
        ),

        Text(label),
      ],
    );
  }
}