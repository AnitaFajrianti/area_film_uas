import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/movie_model.dart';

class WatchlistService {
  static const String boxName = 'watchlist';
  static late Box<String> _box;
  
  // 💡 STATE GLOBAL UNTUK MENYIMPAN ID PROFIL / USER YANG SEDANG AKTIF
  // Secara default kita set sebagai 'guest'
  static String activeProfileId = 'guest';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<String>(boxName);
    } else {
      _box = Hive.box<String>(boxName);
    }
  }

  // =========================================================================
  // 🔥 TAMBAHAN OPTIMALISASI FITUR NYATA PADA ACCOUNT SETTINGS & STATISTIK
  // =========================================================================

  // Ambil preferensi pengaturan berdasarkan profil aktif, jika kosong pakai nilai default
  static String getSetting(String key, String defaultValue) {
    final uniqueSettingKey = 'profile_${activeProfileId}_setting_$key';
    return _box.get(uniqueSettingKey) ?? defaultValue;
  }

  // Simpan preferensi pengaturan berdasarkan profil aktif
  static Future<void> saveSetting(String key, String value) async {
    final uniqueSettingKey = 'profile_${activeProfileId}_setting_$key';
    await _box.put(uniqueSettingKey, value);
  }

  // Mengambil jumlah review dinamis spesifik untuk tiap profil aktif
  static int getReviewCount() {
    final uniqueReviewKey = 'profile_${activeProfileId}_review_count';
    final savedValue = _box.get(uniqueReviewKey);
    if (savedValue != null) {
      return int.tryParse(savedValue) ?? 4; // default 4 sesuai UI awal jika gagal parse
    }
    return 4; // default awal
  }

  // Menyimpan/menambah jumlah ulasan profil aktif
  static Future<void> saveReviewCount(int count) async {
    final uniqueReviewKey = 'profile_${activeProfileId}_review_count';
    await _box.put(uniqueReviewKey, count.toString());
  }

  // =========================================================================
  // 🍿 CORE WATCHLIST MANAGE CODE (TETAP SAMA DENGAN CODEMU)
  // =========================================================================

  // 💡 FIX: Simpan film berdasarkan ID Profil agar tidak bercampur
  static Future<void> addToWatchlist(Movie movie) async {
    final movieJson = movie.toJson();
    final uniqueKey = 'profile_${activeProfileId}_movie_${movie.id}';
    await _box.put(uniqueKey, json.encode(movieJson));
  }

  // 💡 FIX: Hapus berdasarkan ID Profil yang sedang aktif
  static Future<void> removeFromWatchlist(int movieId) async {
    final uniqueKey = 'profile_${activeProfileId}_movie_$movieId';
    await _box.delete(uniqueKey);
  }

  // 💡 FIX: Cek status berdasarkan ID Profil yang sedang aktif
  static bool isInWatchlist(int movieId) {
    final uniqueKey = 'profile_${activeProfileId}_movie_$movieId';
    return _box.containsKey(uniqueKey);
  }

  // 💡 FIX: Hanya mengambil film yang cocok dengan ID Profil yang sedang aktif
  static Future<List<Movie>> getWatchlist() async {
    final List<Movie> movies = [];
    final prefix = 'profile_${activeProfileId}_movie_';
    
    // Looping semua data di Hive, tapi filter yang depannya cocok dengan profile aktif
    for (var key in _box.keys) {
      if (key.toString().startsWith(prefix)) {
        final value = _box.get(key);
        if (value != null) {
          try {
            final Map<String, dynamic> movieMap = json.decode(value);
            movies.add(Movie.fromJson(movieMap));
          } catch (e) {
            continue;
          }
        }
      }
    }
    return movies;
  }

  // Hapus semua data watchlist hanya untuk profil yang sedang aktif
  static Future<void> clearWatchlist() async {
    final prefix = 'profile_${activeProfileId}_movie_';
    final List<dynamic> keysToDelete = [];
    
    for (var key in _box.keys) {
      if (key.toString().startsWith(prefix)) {
        keysToDelete.add(key);
      }
    }
    await _box.deleteAll(keysToDelete);
  }
}

extension MovieJson on Movie {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
    };
  }
}