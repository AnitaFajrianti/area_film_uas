import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/cast_model.dart';
import '../../models/movie_model.dart';
import '../../services/api_service.dart';
import '../../services/watchlist_service.dart';
import '../../utils/constants.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<String?> trailerKey;
  late Future<List<Cast>> castList;
  bool isInWatchlist = false;

  // State untuk mengontrol pemutar video
  YoutubePlayerController? _ytController;
  bool _isPlayingTrailer = false;
  String? _resolvedKey;

  @override
  void initState() {
    super.initState();
    trailerKey = ApiService().getMovieTrailerKey(widget.movie.id);
    castList = ApiService().getMovieCast(widget.movie.id);
    _checkWatchlist();

    // Inisialisasi controller secara asinkronus begitu key didapatkan
    trailerKey.then((key) {
      if (key != null && mounted) {
        setState(() {
          _resolvedKey = key;
          _ytController = YoutubePlayerController(
            initialVideoId: key,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
              disableDragSeek: false,
              loop: false,
              isLive: false,
              forceHD: false,
              controlsVisibleAtStart: false, // UI tombol tidak di-load barengan biar enteng
              useHybridComposition: true,   // Rendering native HP biar video lancar
            ),
          );
        });
      }
    });
  }

  Future<void> _checkWatchlist() async {
    final inWatchlist = WatchlistService.isInWatchlist(widget.movie.id);
    setState(() => isInWatchlist = inWatchlist);
  }

  Future<void> _toggleWatchlist() async {
    if (isInWatchlist) {
      await WatchlistService.removeFromWatchlist(widget.movie.id);
    } else {
      await WatchlistService.addToWatchlist(widget.movie);
    }
    _checkWatchlist();
  }

  // Fungsi play internal di dalam aplikasi
  void _startTrailer() {
    if (_ytController != null) {
      setState(() {
        _isPlayingTrailer = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trailer is currently unavailable.')),
      );
    }
  }

  @override
  void dispose() {
    // 🔥 FIX: Paksa pause video terlebih dahulu sebelum menghancurkan objek dari memori
    if (_ytController != null) {
      _ytController!.pause();
      _ytController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isPlayingTrailer, // Mengunci back bawaan HP jika video lagi nyala
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isPlayingTrailer) {
          _ytController?.pause();
          setState(() {
            _isPlayingTrailer = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Immersive Collapsible Backdrop Banner
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // 🔥 FIX: Amankan player video dalam kondisi apa pun sebelum navigasi
                    _ytController?.pause();
                    
                    if (_isPlayingTrailer) {
                      setState(() {
                        _isPlayingTrailer = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              // ✂️ Bagian actions (tombol ceklis pojok kanan atas) sudah dihapus dari sini biar makin clean!
              flexibleSpace: FlexibleSpaceBar(
                background: _isPlayingTrailer && _ytController != null
                    ? SafeArea(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            YoutubePlayer(
                              controller: _ytController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: AppColors.primary,
                            ),
                            // Tombol Close kecil di pojok video jika ingin menyudahi video
                            Positioned(
                              top: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: 16,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                  onPressed: () {
                                    _ytController?.pause();
                                    setState(() {
                                      _isPlayingTrailer = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: getImageUrl(
                              widget.movie.backdropPath.isNotEmpty
                                  ? widget.movie.backdropPath
                                  : widget.movie.posterPath,
                            ),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.card,
                              child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.card,
                              child: const Icon(Icons.broken_image, color: Colors.white24, size: 48),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.background,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                          // Center Play Overlay (Trigger pemutar internal)
                          if (_resolvedKey != null)
                            Center(
                              child: GestureDetector(
                                onTap: _startTrailer,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.play_circle_filled,
                                    color: AppColors.primary,
                                    size: 70,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            
            // Movie Details Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            'AF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PREMIUM SELECTION',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Movie Title
                  Text(
                    widget.movie.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Metadata Badges Row
                  Row(
                    children: [
                      Text(
                        'Popular Choices',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.movie.releaseDate.isNotEmpty
                            ? widget.movie.releaseDate.substring(0, 4)
                            : 'N/A',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'HD',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Action Buttons (Play / Add to Watchlist)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _resolvedKey != null ? _startTrailer : null,
                          icon: const Icon(Icons.play_arrow, color: Colors.black, size: 24),
                          label: Text(
                            _resolvedKey != null ? 'Play Trailer' : 'Trailer Unavailable',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white24,
                            disabledForegroundColor: Colors.white30,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Watchlist Button (Tombol ini tetap dipertahankan 👍)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isInWatchlist ? Icons.check : Icons.add,
                            color: Colors.white,
                            size: 26,
                          ),
                          onPressed: _toggleWatchlist,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Synopsis Header & Body
                  Text(
                    'Synopsis',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview.isEmpty
                        ? 'No synopsis available.'
                        : widget.movie.overview,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Cast Profiles
                  Text(
                    'Cast & Crew',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Cast>>(
                    future: castList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                        return Text(
                          'Cast information not available.',
                          style: GoogleFonts.poppins(color: Colors.white30, fontSize: 13),
                        );
                      }
                      final cast = snapshot.data!.take(10).toList();
                      return SizedBox(
                        height: 155,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: cast.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) => _buildCastCard(cast[index]),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCastCard(Cast actor) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.card,
            backgroundImage: actor.profilePath.isNotEmpty
                ? CachedNetworkImageProvider(getImageUrl(actor.profilePath))
                : null,
            child: actor.profilePath.isEmpty
                ? const Icon(Icons.person, color: Colors.white24, size: 40)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            actor.character,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}