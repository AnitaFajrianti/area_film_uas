import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/movie_model.dart';
import '../../services/watchlist_service.dart';
import '../../utils/constants.dart';
import '../../widgets/movie_card.dart';
import '../detail/movie_detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  
  // Method pembantu untuk memaksa halaman melakukan render ulang datanya
  void _refreshWatchlist() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        onRefresh: () async {
          _refreshWatchlist();
        },
        child: SafeArea(
          child: FutureBuilder<List<Movie>>(
            // 🔥 Mengambil data langsung dari Hive Service secara real-time.
            // Setiap kali tab dibuka atau dipaksa rebuild, Hive akan otomatis 
            // membaca ID profil aktif yang paling baru tanpa tertukar.
            future: WatchlistService.getWatchlist(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
                  ),
                );
              }
              
              final watchlist = snapshot.data ?? [];
              
              // Tampilan jika data Watchlist untuk profil aktif masih kosong
              if (watchlist.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), 
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_library_outlined,
                              size: 70,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your list is empty',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add movies to your list by clicking "My List" on the home billboard or details pages.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              
              // Grid list film milik profil yang aktif
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.65, 
                  ),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];
                    
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: MovieCard(
                            movie: movie,
                            onTap: () async {
                              // Menunggu transisi halaman detail selesai
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailScreen(movie: movie),
                                ),
                              );
                              // Refresh data ketika kembali dari halaman detail (jika user menghapus dari sana)
                              _refreshWatchlist(); 
                            },
                          ),
                        ),
                        // Tombol (X) kecil di pojok kanan kartu untuk menghapus film secara instan
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () async {
                              await WatchlistService.removeFromWatchlist(movie.id);
                              _refreshWatchlist(); // Paksa render ulang UI setelah dihapus
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${movie.title} removed from Watchlist'),
                                    backgroundColor: AppColors.card,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}