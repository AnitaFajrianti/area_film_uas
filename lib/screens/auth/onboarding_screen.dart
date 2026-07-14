import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../home/home_screen_new.dart'; // 🔥 Import untuk jalur bypass sosial login
import 'login_screen.dart';
import 'signup_screen.dart'; // 🔥 Import untuk link Sign Up di bawah

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSocialLoading = false; // 🔥 Status interaktif demo sosial login

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Unlimited movies,\nTV shows & more',
      'subtitle': 'Watch Area Film anywhere. Cancel at any time smoothly.',
      'image': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500&auto=format&fit=crop', 
    },
    {
      'title': 'Watch movies\nTV, Virtual Reality',
      'subtitle': 'An immersive experience crafted tailored for movie lovers.',
      'image': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=500&auto=format&fit=crop',
    },
  ];

  // 🔥 Fungsi simulator masuk menggunakan akun sosial media
  void _handleSocialLogin(String provider) {
    setState(() {
      _isSocialLoading = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting with $provider...'),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: AppColors.primary,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSocialLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreenNew()), 
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length + 1,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              if (index == _onboardingData.length) return _buildWelcomePage();
              return _buildSliderPage(_onboardingData[index]);
            },
          ),

          if (_currentPage < _onboardingData.length)
            Positioned(
              bottom: 180,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length + 1,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? const Color(0xFFFFA222) : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          
          // Layar pelindung loading ketika memproses otentikasi sosial
          if (_isSocialLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFA222)),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSliderPage(Map<String, String> data) {
    return Stack(
      children: [
        Image.network(data['image']!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7), AppColors.background],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(data['title']!, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(data['subtitle']!, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 120),
              ElevatedButton(
                onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA222),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('NEXT', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWelcomePage() {
    return Stack(
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=500&auto=format&fit=crop',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), AppColors.background.withOpacity(0.9), AppColors.background],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Image.asset('assets/images/logo.png', width: 80, height: 80, fit: BoxFit.contain)),
              const SizedBox(height: 16),
              Text('Let\'s you in', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              
              // 🔥 IMPLEMENTASI TOMBOL SOSIAL INTERAKTIF DEMO
              _buildSocialButton(Icons.facebook, 'Continue with Facebook', () => _handleSocialLogin('Facebook')),
              const SizedBox(height: 12),
              _buildSocialButton(Icons.g_mobiledata_rounded, 'Continue with Google', () => _handleSocialLogin('Google'), isGoogle: true),
              const SizedBox(height: 12),
              _buildSocialButton(Icons.apple, 'Continue with Apple ID', () => _handleSocialLogin('Apple')),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white24)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: GoogleFonts.poppins(color: Colors.white38))),
                  const Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA222),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('SIGN IN WITH PASSWORD', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                  GestureDetector(
                    onTap: () {
                      // 🔥 LINK KE HALAMAN SIGN UP BARU
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                    },
                    child: Text('Sign Up', style: GoogleFonts.poppins(color: const Color(0xFFFFA222), fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onTap, {bool isGoogle = false}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: isGoogle ? Colors.redAccent : Colors.white, size: 24),
      label: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.card,
        side: const BorderSide(color: Colors.white10),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}