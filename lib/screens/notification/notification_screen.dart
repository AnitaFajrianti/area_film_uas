import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart'; // Pastikan path AppColors kamu sesuai

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Contoh data dummy tiruan biar mirip dengan screenshot Netflix kamu
  final List<Map<String, dynamic>> _notifications = const [
    {
      'title': 'A top drama picked just for you',
      'message': 'Check out Teach You a Lesson today.',
      'date': '13 Jul',
      'isNew': true,
      'hasMultiplePosters': false,
    },
    {
      'title': 'Call Me Dad',
      'message': 'What did you think? Share your review.',
      'date': '12 Jul',
      'isNew': true,
      'hasMultiplePosters': true,
    },
    {
      'title': 'Suggestions for Tonight',
      'message': 'Explore personalized picks curated for you.',
      'date': '11 Jul',
      'isNew': true,
      'hasMultiplePosters': true,
    },
    {
      'title': 'New Arrival',
      'message': 'Journey to the Center of the Earth is now streaming.',
      'date': '10 Jul',
      'isNew': true,
      'hasMultiplePosters': false,
    },
    {
      'title': 'New Arrival',
      'message': 'Check Out Sekarang, Pay Later!',
      'date': '9 Jul',
      'isNew': false,
      'hasMultiplePosters': false,
    },
    {
      'title': 'The detective vows to crack her new case',
      'message': 'The game is afoot once again.',
      'date': '7 Jul',
      'isNew': false,
      'hasMultiplePosters': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indikator Dot Merah di paling kiri untuk notifikasi baru
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 36, right: 8),
                  decoration: BoxDecoration(
                    color: item['isNew'] ? Colors.red : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                
                // Kotak/Thumbnail Poster Film ala Netflix
                Stack(
                  children: [
                    // Jika memiliki tumpukan poster (seperti menu suggestion)
                    if (item['hasMultiplePosters']) ...[
                      Positioned(
                        left: 8,
                        top: 4,
                        child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 4,
                        top: 2,
                        child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                    Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(Icons.movie_filter, color: Colors.white24, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Konten Teks Notifikasi (Judul, Deskripsi, Tanggal)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['message'],
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['date'],
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}