import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/run_model.dart';
import '../providers/auth_provider.dart';
import '../providers/run_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class CreateRunScreen extends StatefulWidget {
  final RunModel? existing;
  const CreateRunScreen({super.key, this.existing});

  @override
  State<CreateRunScreen> createState() => _CreateRunScreenState();
}

class _CreateRunScreenState extends State<CreateRunScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  final _distCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  final _mCtrl = TextEditingController();
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final r = widget.existing!;
      _date = r.date;
      _distCtrl.text = r.distanceKm.toString();
      final h = r.durationMinutes ~/ 60;
      final m = r.durationMinutes % 60;
      if (h > 0) _hCtrl.text = h.toString();
      _mCtrl.text = m.toString();
    } else {
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _distCtrl.dispose();
    _hCtrl.dispose();
    _mCtrl.dispose();
    super.dispose();
  }

  // Live preview values
  double? get _previewDist =>
      double.tryParse(_distCtrl.text.replaceAll(',', '.'));
  int get _previewTotalMin =>
      (int.tryParse(_hCtrl.text) ?? 0) * 60 +
      (int.tryParse(_mCtrl.text) ?? 0);
  String? get _previewPace {
    final d = _previewDist;
    final t = _previewTotalMin;
    if (d == null || d <= 0 || t <= 0) return null;
    final p = t / d;
    final pm = p.floor();
    final ps = ((p - pm) * 60).round();
    return "$pm'${ps.toString().padLeft(2, '0')}\"";
  }

  int? get _previewCal {
    final d = _previewDist;
    if (d == null || d <= 0) return null;
    return (d * 62).round();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dist = double.tryParse(_distCtrl.text.replaceAll(',', '.'))!;
    final total = _previewTotalMin;

    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Durasi harus lebih dari 0 menit')),
      );
      return;
    }

    setState(() => _saving = true);
    final provider = context.read<RunProvider>();

    if (_isEdit) {
      await provider.updateRun(
        widget.existing!.copyWith(
          date: _date,
          distanceKm: dist,
          durationMinutes: total,
        ),
      );
    } else {
      final uid = context.read<AuthProvider>().currentUser!.id;
      await provider.addRun(
        userId: uid,
        date: _date,
        distanceKm: dist,
        durationMinutes: total,
      );
    }

    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isEdit ? 'Aktivitas berhasil diperbarui!' : 'Aktivitas lari tercatat! 🎉'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pace = _previewPace;
    final cal = _previewCal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Aktivitas' : 'Catat Lari Baru',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textPrimary),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                _SectionLabel('Tanggal Lari'),
                const SizedBox(height: 8),
                _DatePicker(date: _date, onTap: _pickDate),
                const SizedBox(height: 24),

                // Distance
                _SectionLabel('Jarak Tempuh'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _distCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    prefixIcon:
                        Icon(Icons.route_rounded, color: AppColors.textSecondary),
                    suffixText: 'km',
                    suffixStyle: TextStyle(
                        color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Masukkan jarak tempuh';
                    }
                    final d = double.tryParse(v.replaceAll(',', '.'));
                    if (d == null || d <= 0) return 'Jarak tidak valid';
                    if (d > 300) return 'Jarak terlalu besar';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Duration
                _SectionLabel('Durasi'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: '0',
                          prefixIcon: Icon(Icons.hourglass_top_rounded,
                              color: AppColors.textSecondary),
                          suffixText: 'jam',
                          suffixStyle:
                              TextStyle(color: AppColors.textSecondary),
                        ),
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final h = int.tryParse(v);
                            if (h == null || h < 0) return 'Tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _mCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: '0',
                          prefixIcon: Icon(Icons.timer_outlined,
                              color: AppColors.textSecondary),
                          suffixText: 'menit',
                          suffixStyle:
                              TextStyle(color: AppColors.textSecondary),
                        ),
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final m = int.tryParse(v);
                            if (m == null || m < 0 || m > 59) {
                              return 'Tidak valid (0-59)';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                // Preview card
                if (pace != null) ...[
                  const SizedBox(height: 28),
                  _PreviewCard(pace: pace, calories: cal ?? 0, dist: _previewDist ?? 0),
                ],

                const SizedBox(height: 32),
                CustomButton(
                  text: _isEdit ? 'Simpan Perubahan' : 'Simpan Aktivitas',
                  isLoading: _saving,
                  onPressed: _save,
                  icon: _isEdit ? Icons.save_rounded : Icons.check_circle_rounded,
                ),
                const SizedBox(height: 16),
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
  const _DatePicker({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
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
  const _PreviewCard(
      {required this.pace, required this.calories, required this.dist});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Estimasi Performa',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _PreviewItem(
                  label: 'Pace', value: pace, unit: '/km', icon: Icons.speed_rounded),
              const SizedBox(width: 16),
              _PreviewItem(
                  label: 'Kalori',
                  value: '$calories',
                  unit: 'kkal',
                  icon: Icons.local_fire_department_rounded),
              const SizedBox(width: 16),
              _PreviewItem(
                  label: 'Kategori',
                  value: _category(dist),
                  unit: '',
                  icon: Icons.emoji_events_rounded),
            ],
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
  const _PreviewItem(
      {required this.label,
      required this.value,
      required this.unit,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(height: 4),
          Text(
            unit.isEmpty ? value : '$value $unit',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
