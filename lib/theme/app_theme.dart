import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C61);
  static const Color primaryDark = Color(0xFFE55A20);
  static const Color primaryGlow = Color(0x33FF6B35);
  static const Color background = Color(0xFF080808);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceVariant = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF282828);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textHint = Color(0xFF555555);
  static const Color error = Color(0xFFFF4D4D);
  static const Color success = Color(0xFF4CAF50);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800),
        displayMedium: base.displayMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        headlineLarge: base.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        headlineMedium: base.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: base.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: base.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: base.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleSmall: base.titleSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary),
        bodySmall: base.bodySmall?.copyWith(color: AppColors.textSecondary),
        labelLarge: base.labelLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: base.labelMedium?.copyWith(color: AppColors.textSecondary),
        labelSmall: base.labelSmall?.copyWith(color: AppColors.textHint),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(double.infinity, 52),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.cardBorder, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariant,
        contentTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700,
        ),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary, fontSize: 14,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        elevation: 8,
        textStyle: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textSecondary),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primaryGlow : AppColors.cardBorder),
      ),
    );
  }
}
