import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:area_film_uas/screens/notification/notification_screen.dart';

import '../../models/movie_model.dart';
import '../../services/api_service.dart';
import '../../services/watchlist_service.dart';
import '../../utils/constants.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/shimmer_widget.dart';
import '../detail/movie_detail_screen.dart';
import '../detail/see_all_screen.dart';
import '../notification/notification_screen.dart'; // Menambahkan import halaman notifikasi baru
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../watchlist/watchlist_screen.dart';

// Halaman Dummy About Us biar Drawer fungsional
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Text('About Us', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo2.png',
                width: 100, 
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AREA FILM',
              style: GoogleFonts.anton(color: AppColors.primary, fontSize: 32, letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              'v1.0.0 Proyek Akhir',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
            ),
            const Divider(color: Colors.white24, height: 40),
            Text(
              'Aplikasi informasi review dan trailer film masa kini dikembangkan khusus untuk menyajikan seleksi sinematik terbaik.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ), 
    );
  }
}

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
        const HomeContent(),
        const SearchScreen(),
        WatchlistScreen(key: ValueKey(WatchlistService.activeProfileId)),
        ProfileScreen(
          onProfileChanged: () {
            setState(() {}); 
          },
        ),
      ];

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Fungsi pengganti untuk berpindah ke halaman notifikasi penuh (Full Screen)
  void _showNotificationDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: _currentIndex == 0,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                'AREA FILM',
                style: GoogleFonts.anton(
                  color: AppColors.primary,
                  fontSize: 28,
                  letterSpacing: 1.5,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 26),
                  onPressed: () => changeTab(1),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                  onPressed: () => _showNotificationDialog(context),
                ),
                const SizedBox(width: 8),
              ],
            )
          : AppBar(
              backgroundColor: AppColors.card,
              elevation: 0,
              title: Text(
                _currentIndex == 1
                    ? 'Search'
                    : _currentIndex == 2
                        ? 'Watchlist'
                        : 'Profile',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
      drawer: _buildDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        onTap: changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark), label: 'My List'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF111111)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AREA FILM',
                  style: GoogleFonts.anton(
                    color: AppColors.primary,
                    fontSize: 36,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Afan Production',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home, 'Home', 0),
          _drawerItem(Icons.search, 'Search Film', 1),
          _drawerItem(Icons.bookmark, 'My Watchlist', 2),
          const Divider(color: Colors.white24, height: 32),
          _drawerItem(Icons.settings, 'Settings', 3),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white70),
            title: Text('About Us', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      ),
      onTap: () {
        changeTab(index);
        Navigator.pop(context);
      },
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ApiService _apiService = ApiService();
  late Future<List<Movie>> _popularMovies;
  late Future<List<Movie>> _nowPlayingMovies;
  late Future<List<Movie>> _topRatedMovies;
  late Future<List<Movie>> _upcomingMovies;

  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Movies', 'TV Shows', 'Trending', 'My List'];

  @override
  void initState() {
    super.initState();
    _loadAllMovies();
  }

  void _loadAllMovies() {
    _popularMovies = _apiService.getPopularMovies();
    _nowPlayingMovies = _apiService.getNowPlayingMovies();
    _topRatedMovies = _apiService.getTopRatedMovies();
    _upcomingMovies = _apiService.getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      onRefresh: () async {
        setState(() {
          _loadAllMovies();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Movie>>(
              future: _popularMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 460,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                }
                if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 250,
                    child: Center(child: Text('Error loading featured billboard', style: TextStyle(color: Colors.white24))),
                  );
                }
                final featuredMovie = snapshot.data!.first;
                return BillboardWidget(movie: featuredMovie);
              },
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, bottom: 8),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedCategoryIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });

                        if (index == 0) {
                          _loadAllMovies();
                        } else if (index == 1) {
                          setState(() {
                            _nowPlayingMovies = _apiService.getNowPlayingMovies();
                            _popularMovies = _apiService.getPopularMovies();
                          });
                        } else if (index == 2) {
                          setState(() {
                            _upcomingMovies = _apiService.getUpcomingMovies();
                          });
                        } else if (index == 3) {
                          setState(() {
                            _topRatedMovies = _apiService.getTopRatedMovies();
                          });
                        } else if (index == 4) {
                          final homeState = context.findAncestorStateOfType<_HomeScreenNewState>();
                          if (homeState != null) {
                            homeState.changeTab(2);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : Colors.white10,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.black : Colors.white70,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            if (_selectedCategoryIndex == 0) ...[
              _buildMovieLane('Popular on Area Film', _popularMovies, 1),
              _buildMovieLane('Now Playing', _nowPlayingMovies, 0),
              _buildMovieLane('Trending / Top Rated', _topRatedMovies, 2),
              _buildMovieLane('Upcoming Releases', _upcomingMovies, 3),
            ] else if (_selectedCategoryIndex == 1) ...[
              _buildMovieLane('Popular Movies', _popularMovies, 1),
              _buildMovieLane('Now Playing in Theaters', _nowPlayingMovies, 0),
            ] else if (_selectedCategoryIndex == 2) ...[
              _buildMovieLane('Upcoming Releases & Shows', _upcomingMovies, 3),
            ] else if (_selectedCategoryIndex == 3) ...[
              _buildMovieLane('Trending / Top Rated Today', _topRatedMovies, 2),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieLane(String title, Future<List<Movie>> futureMovies, int categoryIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllScreen(
                        category: title,
                        categoryIndex: categoryIndex,
                      ),
                    ),
                  );
                  setState(() {});
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 195,
          child: FutureBuilder<List<Movie>>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => const ShimmerMovieCard(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load movies', style: GoogleFonts.poppins(color: Colors.white30, fontSize: 12)),
                );
              }
              final movies = snapshot.data ?? [];
              if (movies.isEmpty) {
                return Center(
                  child: Text('No movies found', style: GoogleFonts.poppins(color: Colors.white30, fontSize: 12)),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(
                    movie: movie,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
                      );
                      setState(() {});
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BillboardWidget extends StatefulWidget {
  final Movie movie;
  const BillboardWidget({super.key, required this.movie});

  @override
  State<BillboardWidget> createState() => _BillboardWidgetState();
}

class _BillboardWidgetState extends State<BillboardWidget> {
  bool _isMyList = false;

  @override
  void initState() {
    super.initState();
    _checkMyList();
  }

  Future<void> _checkMyList() async {
    final status = WatchlistService.isInWatchlist(widget.movie.id);
    setState(() {
      _isMyList = status;
    });
  }

  Future<void> _toggleMyList() async {
    if (_isMyList) {
      await WatchlistService.removeFromWatchlist(widget.movie.id);
    } else {
      await WatchlistService.addToWatchlist(widget.movie);
    }
    setState(() {
      _isMyList = !_isMyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: getImageUrl(widget.movie.posterPath),
          width: size.width,
          height: 460,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.card,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.white30, size: 50),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  AppColors.background,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'AF', 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 9, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
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
              Text(
                widget.movie.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    const Shadow(
                      color: Colors.black87,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Trending Today',
                    style: GoogleFonts.poppins(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      'HD',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.movie.releaseDate.isNotEmpty ? widget.movie.releaseDate.substring(0, 4) : 'N/A',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        widget.movie.voteAverage.toStringAsFixed(1),
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: widget.movie)),
                        );
                        setState(() {});
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.black, size: 24),
                      label: Text(
                        'Play',
                        style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleMyList,
                      icon: Icon(
                        _isMyList ? Icons.check : Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                      label: Text(
                        'My List',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        side: const BorderSide(color: Colors.transparent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}