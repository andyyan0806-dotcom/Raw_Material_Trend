import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF1E3A5F);
  static const Color accent = Color(0xFFC0392B);
  static const Color primaryLight = Color(0xFF4A90D9);

  // Light theme
  static const Color backgroundLight = Color(0xFFF4F6FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceAltLight = Color(0xFFEEF1F8);
  static const Color textLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textMutedLight = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color cardShadowLight = Color(0x0F000000);

  // Dark theme
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color surfaceDark = Color(0xFF1A2B3C);
  static const Color surfaceAltDark = Color(0xFF0F2135);
  static const Color textDark = Color(0xFFF0F4FA);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF2D3F52);
  static const Color cardShadowDark = Color(0x33000000);

  // Directional colors
  static const Color up = Color(0xFF16A34A);
  static const Color down = Color(0xFFDC2626);
  static const Color upBg = Color(0xFFDCFCE7);
  static const Color downBg = Color(0xFFFEE2E2);
  static const Color upBgDark = Color(0xFF052E16);
  static const Color downBgDark = Color(0xFF450A0A);
  static const Color neutral = Color(0xFF6B7280);
  static const Color neutralBg = Color(0xFFF3F4F6);
  static const Color neutralBgDark = Color(0xFF1F2937);

  // Recommendation section
  static const Color recommendationBgLight = Color(0xFFF0F4FF);
  static const Color recommendationBorderLight = Color(0xFFC7D7F5);
  static const Color recommendationBgDark = Color(0xFF0F1E30);
  static const Color recommendationBorderDark = Color(0xFF2D4A6A);

  // Chart
  static const Color chartLine = Color(0xFF1E3A5F);
  static const Color chartLineDark = Color(0xFF4A90D9);

  // Confidence band colors
  static const Color confidenceBand1 = Color(0x261E3A5F); // 1M — tightest
  static const Color confidenceBand2 = Color(0x1A1E3A5F); // 3M
  static const Color confidenceBand3 = Color(0x111E3A5F); // 6M — widest
  static const Color confidenceBand1Dark = Color(0x264A90D9);
  static const Color confidenceBand2Dark = Color(0x1A4A90D9);
  static const Color confidenceBand3Dark = Color(0x114A90D9);

  // Category colors
  static const Color metals = Color(0xFF1E3A5F);
  static const Color energy = Color(0xFFB45309);
  static const Color agriculture = Color(0xFF15803D);
  static const Color chemicals = Color(0xFF7C3AED);
}
