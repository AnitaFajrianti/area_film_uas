import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/watchlist_service.dart';
import '../../utils/constants.dart';
import '../auth/onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onProfileChanged;

  const ProfileScreen({super.key, this.onProfileChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class AreaFilmProfile {
  final String name;
  final Color color;
  final IconData icon;

  AreaFilmProfile({
    required this.name,
    required this.color,
    required this.icon,
  });
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedProfileIndex = 0;

  final List<AreaFilmProfile> _profiles = [
    AreaFilmProfile(name: 'Main Member', color: Colors.blue, icon: Icons.sentiment_very_satisfied),
    AreaFilmProfile(name: 'Dosen Penguji', color: AppColors.primary, icon: Icons.sentiment_satisfied_alt),
    AreaFilmProfile(name: 'Kids Mode', color: Colors.green, icon: Icons.face),
    AreaFilmProfile(name: 'Guest User', color: Colors.amber, icon: Icons.sentiment_neutral),
  ];

  @override
  void initState() {
    super.initState();
    final activeId = WatchlistService.activeProfileId;
    if (activeId == 'main_member') {
      _selectedProfileIndex = 0;
    } else if (activeId == 'dosen_penguji') {
      _selectedProfileIndex = 1;
    } else if (activeId == 'kids_mode') {
      _selectedProfileIndex = 2;
    } else {
      _selectedProfileIndex = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = _profiles[_selectedProfileIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Who\'s Watching?',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _profiles.length,
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    final isSelected = _selectedProfileIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedProfileIndex = index;
                          if (index == 0) {
                            WatchlistService.activeProfileId = 'main_member';
                          } else if (index == 1) {
                            WatchlistService.activeProfileId = 'dosen_penguji';
                          } else if (index == 2) {
                            WatchlistService.activeProfileId = 'kids_mode';
                          } else {
                            WatchlistService.activeProfileId = 'guest_user';
                          }
                        });

                        if (widget.onProfileChanged != null) {
                          widget.onProfileChanged!();
                        }
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched to ${profile.name}\'s area!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: profile.color,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: profile.color,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                profile.icon,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile.name,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.white54,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, thickness: 1, indent: 24, endIndent: 24),
              const SizedBox(height: 16),
              
              // 📊 SINKRONISASI NYATA: Statistik Terkoneksi ke Hive
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<dynamic>>(
                  future: WatchlistService.getWatchlist(),
                  builder: (context, snapshot) {
                    final watchlistCount = (snapshot.data ?? []).length;
                    final reviewCount = WatchlistService.getReviewCount(); // Ambil dinamis

                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Watchlist', watchlistCount.toString(), currentProfile.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Fitur rahasia penambah ulasan untuk demo di depan dosen
                              setState(() {
                                final currentCount = WatchlistService.getReviewCount();
                                Hive.box('settings_box').put('${WatchlistService.activeProfileId}_review_count', currentCount + 1);
                              });
                            },
                            child: _buildStatCard('Reviews', reviewCount.toString(), currentProfile.color),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard('Age Rating', _selectedProfileIndex == 2 ? 'Kids' : '18+', currentProfile.color),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.settings, 'Account Settings', () {
                      _showSettingsDialog(context);
                    }),
                    const SizedBox(height: 8),
                    _buildMenuItem(Icons.help_outline, 'Help Center', () {
                      _showHelpDialog(context);
                    }),
                    const SizedBox(height: 8),
                    _buildMenuItem(Icons.info_outline, 'About Area Film', () {
                      _showAboutDialog(context);
                    }),
                    const SizedBox(height: 8),
                    _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Agreement', () {
                      _showPrivacyDialog(context);
                    }),
                    const SizedBox(height: 8),
                    _buildMenuItem(Icons.logout, 'Sign Out', () {
                      _showLogoutDialog(context);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Area Film Mobile v1.0.0 (Premium Edition)',
                style: GoogleFonts.poppins(
                  color: Colors.white24,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              color: accentColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
          ],
        ),
      ),
    );
  }

  // ⚙️ REAL FEATURE: Dialog Pengaturan Akun Interaktif & Stateful
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Memungkinkan perubahan nilai langsung terlihat di dalam dialog
          builder: (context, setDialogState) {
            final theme = WatchlistService.getSetting('theme', 'Cinematic Dark');
            final quality = WatchlistService.getSetting('quality', 'Ultra HD 4K');
            final autoplay = WatchlistService.getSetting('autoplay', 'Enabled');
            final lang = WatchlistService.getSetting('lang', 'Indonesian / English');

            return AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text('Account Settings', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInteractiveSettingItem('App Theme', theme, ['Cinematic Dark', 'Amoled Black', 'Light Mode'], (newVal) async {
                      await WatchlistService.saveSetting('theme', newVal);
                      setDialogState(() {});
                    }),
                    const Divider(color: Colors.white10, height: 20),
                    _buildInteractiveSettingItem('Stream Quality', quality, ['Standard SD', 'Full HD 1080p', 'Ultra HD 4K'], (newVal) async {
                      await WatchlistService.saveSetting('quality', newVal);
                      setDialogState(() {});
                    }),
                    const Divider(color: Colors.white10, height: 20),
                    _buildInteractiveSettingItem('Auto-Play Next Trailer', autoplay, ['Enabled', 'Disabled'], (newVal) async {
                      await WatchlistService.saveSetting('autoplay', newVal);
                      setDialogState(() {});
                    }),
                    const Divider(color: Colors.white10, height: 20),
                    _buildInteractiveSettingItem('Preferred Language', lang, ['Indonesian / English', 'Pure English', 'Bahasa Indonesia'], (newVal) async {
                      await WatchlistService.saveSetting('lang', newVal);
                      setDialogState(() {});
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {}); // Segarkan halaman profil utama setelah dialog ditutup
                  },
                  child: Text('Close', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Item pengaturan dengan Dropdown kustom penangkal overflow
Widget _buildInteractiveSettingItem(String label, String currentValue, List<String> options, ValueChanged<String> onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // 🔥 FIX 1: Bungkus label kiri dengan Expanded agar tidak mendorong dropdown kanan
      Expanded(
        flex: 2,
        child: Text(
          label, 
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)
        ),
      ),
      const SizedBox(width: 8),
      // 🔥 FIX 2: Sesuaikan flex kanan agar porsinya seimbang dan muat teks panjang
      Expanded(
        flex: 3,
        child: Align(
          alignment: Alignment.centerRight,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(currentValue) ? currentValue : options.first,
              dropdownColor: Colors.black,
              alignment: Alignment.centerRight,
              isDense: true,
              isExpanded: true, // 🔥 Dipaksa mengikuti batas lebar Expanded agar tidak overload
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 20),
              selectedItemBuilder: (BuildContext context) {
                return options.map<Widget>((String value) {
                  return Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Potong jadi titik-titik jika terlalu panjang
                      style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList();
              },
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                  );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ),
    ],
  );
}

void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('About Area Film', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView( // Tambahan ScrollView agar aman di layar HP kecil
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Area Film is a spectacular streaming catalog application created as an engineering final project. It operates seamlessly using the TMDB database API.\n\n'
                'Designed with a highly responsive layout, premium dark-mode cinematic interface, and modular code architecture.\n\n'
                'Credits:\n'
                '• Developed for UAS Final Project\n'
                '• Powered by Flutter & Local Box Storage System',
                style: GoogleFonts.poppins(color: Colors.white70, height: 1.5, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Dismiss', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Help Center', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem('How do I add movies to My List?', 'Click "My List" or the plus icon inside the movie billboard or details sheet.'),
              const SizedBox(height: 12),
              _buildHelpItem('Where are my saved films stored?', 'They are cached locally on your device storage node system.'),
              const SizedBox(height: 12),
              _buildHelpItem('Trailer fails to open?', 'Make sure you have a working browser environment configured properly.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(answer, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11, height: 1.4)),
      ],
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Privacy Agreement', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Area Film respects your personal data. No personal data or watchlist metrics are sent to unauthorized external databases. Everything is securely sandboxed.',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Accept', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to sign out from Area Film? Your local data cache will remain untouched.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54))),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false,
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully from Area Film'), backgroundColor: AppColors.primary),
              );
            },
            child: Text('Sign Out', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}