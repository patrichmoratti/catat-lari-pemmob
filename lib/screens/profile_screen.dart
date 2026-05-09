import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/run_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final runs = context.watch<RunProvider>();
    final user = auth.currentUser!;
    final uid = user.id;

    final totalDist = runs.totalDistanceForUser(uid);
    final totalRuns = runs.runsForUser(uid).length;
    final totalCal = runs.totalCaloriesForUser(uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
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
          child: Column(
            children: [
              // Avatar + name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Stats
              Row(
                children: [
                  _StatTile(
                    icon: Icons.directions_run_rounded,
                    value: totalRuns.toString(),
                    label: 'Total Lari',
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    icon: Icons.route_rounded,
                    value: totalDist.toStringAsFixed(1),
                    label: 'Total km',
                    highlight: true,
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    icon: Icons.local_fire_department_rounded,
                    value: '$totalCal',
                    label: 'kkal',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Info card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Nama',
                      value: user.name,
                    ),
                    const Divider(height: 1, indent: 56),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                    ),
                    const Divider(height: 1, indent: 56),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Telepon',
                      value: user.phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Edit profile
              CustomButton(
                text: 'Edit Profil',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const EditProfileScreen()),
                ),
                icon: Icons.edit_rounded,
                backgroundColor: AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
              ),

              const SizedBox(height: 12),

              // Logout
              CustomButton(
                text: 'Keluar dari Akun',
                onPressed: () => _confirmLogout(context),
                icon: Icons.logout_rounded,
                backgroundColor: AppColors.error.withValues(alpha: 0.12),
                foregroundColor: AppColors.error,
              ),

              const SizedBox(height: 24),

              // App version
              const Text(
                'Catat Lari v1.0.0',
                style: TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content:
            const Text('Yakin ingin keluar? Kamu bisa masuk kembali kapan saja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlight
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: highlight ? AppColors.primary : AppColors.textSecondary,
                size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: highlight ? AppColors.primary : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 16),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
