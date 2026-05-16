import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const primary = Color(0xFF6366F1); // Electric Indigo
  static const secondary = Color(0xFF4F46E5); // Deep Indigo
  static const accent = Color(0xFFF59E0B); // Amber Gold
  
  // Neutral / Backgrounds
  static const background = Color(0xFF0F172A); // Deep Slate (Midnight)
  static const cardBg = Color(0xFF1E293B); // Lighter Slate (Card BG)
  static const glassBg = Color(0x1A6366F1); // Glassy Indigo (10% Opacity)
  
  // Text
  static const textPrimary = Color(0xFFF8FAFC); // Almost White
  static const textSecondary = Color(0xFF94A3B8); // Muted Blue-Grey
  static const textMuted = Color(0xFF64748B); // Muted Grey
  
  // Functional
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF22C55E);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const darkGradient = LinearGradient(
    colors: [background, Color(0xFF020617)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
