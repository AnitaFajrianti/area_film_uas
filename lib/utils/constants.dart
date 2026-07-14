import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF111111); 
  static const Color accent = Color(0xFFFFA222);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white54; 
  
  // 🔥 FIX: Tambahkan dua baris ini agar eror "Member not found" hilang semua!
  static const Color primary = Color(0xFFFFA222); // Warna Oranye Logo Area Film
  static const Color card = Color(0xFF1F1F1F);    // Warna Abu-abu gelap untuk Container/Card
}

final TextStyle sectionTitle = GoogleFonts.poppins(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

final TextStyle bodyText = GoogleFonts.poppins(
  color: Colors.white70,
  fontSize: 14,
);

final TextStyle chipText = GoogleFonts.poppins(
  color: Colors.black,
  fontSize: 11,
  fontWeight: FontWeight.w600,
);

String getImageUrl(String? path) {
  if (path == null || path.isEmpty) {
    return 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500';
  }
  return 'https://image.tmdb.org/t/p/w500$path';
}