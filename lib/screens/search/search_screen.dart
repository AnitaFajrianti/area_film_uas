import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/movie_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../detail/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Movie> _results = [];
  List<Movie> _topSearches = [];
  bool _isLoading = false;
  bool _isTopSearchesLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTopSearches();
  }

  Future<void> _loadTopSearches() async {
    setState(() => _isTopSearchesLoading = true);
    try {
      final popular = await _apiService.getPopularMovies();
      setState(() {
        _topSearches = popular;
        _isTopSearchesLoading = false;
      });
    } catch (e) {
      setState(() => _isTopSearchesLoading = false);
    }
  }

  Future<void> _searchMovies(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final movies = await _apiService.searchMovies(query);
      setState(() {
        _results = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTopSearches = _controller.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Search Input Field
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF222222),
                  hintText: 'Search for movies or genres...',
                  hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white38),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _results = []);
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {});
                  _searchMovies(value);
                },
              ),
              const SizedBox(height: 20),
              
              // Search section label
              Text(
                showTopSearches ? 'Top Searches' : 'Search Results',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Content Area
              Expanded(
                child: showTopSearches
                    ? _isTopSearchesLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : _topSearches.isEmpty
                            ? Center(
                                child: Text(
                                  'Connect to TMDB to view recommendations.',
                                  style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _topSearches.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) =>
                                    _buildSearchTile(context, _topSearches[index]), // FIX: Nama fungsi diubah
                              )
                    : _isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : _results.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.white24),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No results match your search.',
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Try other movie keywords or genres.',
                                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: _results.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) =>
                                    _buildSearchTile(context, _results[index]), // FIX: Nama fungsi diubah
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FIX: Mengubah komponen tile hasil pencarian menjadi netral (Area Film Style)
  Widget _buildSearchTile(BuildContext context, Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Container(
        color: const Color(0xFF161616),
        child: Row(
          children: [
            // Wide Landscape Card Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: getImageUrl(
                  movie.backdropPath.isNotEmpty ? movie.backdropPath : movie.posterPath,
                ),
                height: 70,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 70,
                  width: 120,
                  color: AppColors.card,
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 70,
                  width: 120,
                  color: AppColors.card,
                  child: const Icon(Icons.broken_image, color: Colors.white24, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Play Button Icon on Right (Menyesuaikan dengan aksen warna baru jika ditekan)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}