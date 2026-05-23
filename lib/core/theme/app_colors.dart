import 'package:flutter/material.dart';

/// Centralized color palette for the Penny Pulse dark fintech theme.
class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────────────
  static const background = Color(0xFF0A0B14); // darkest — Scaffold
  static const surface = Color(0xFF141521); // cards / bottom nav
  static const surfaceVariant = Color(0xFF1C1D2E); // elevated cards
  static const cardBorder = Color(0xFF252636); // card outline

  // ── Brand — Deep Purple (primary accent) ────────────────────────────────
  static const purple = Color(0xFF7B2FBE);
  static const purpleLight = Color(0xFF9747FF);
  static const purpleDim = Color(0xFF5B1A9C);
  static const purpleContainer = Color(0xFF2D1B5C);

  // ── Action — Neon Green (buttons, active nav, FAB) ───────────────────────
  static const neonGreen = Color(0xFFC8FF00);
  static const neonGreenDark = Color(0xFF0A0B14); // text ON neon green

  // ── Positive — Emerald Green (needs / income) ────────────────────────────
  static const emerald = Color(0xFF22D36B);
  static const emeraldDim = Color(0xFF059669);
  static const emeraldContainer = Color(0xFF0A2E1C);

  // ── Negative — Rose Red (wants / expenses) ───────────────────────────────
  static const rose = Color(0xFFFF4757);
  static const roseDim = Color(0xFFCC1A2A);
  static const roseContainer = Color(0xFF2E0A12);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8B8FA8);
  static const textTertiary = Color(0xFF4B4F68);
}
