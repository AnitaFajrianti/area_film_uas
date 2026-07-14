import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cast_model.dart';
import '../models/movie_model.dart';

class ApiService {
  static const String apiKey = '7b7c4e45bc596ca472141fc93cebe0d3';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    return _getMovies('/movie/popular');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    return _getMovies('/movie/now_playing');
  }

  Future<List<Movie>> getTopRatedMovies() async {
    return _getMovies('/movie/top_rated');
  }

  Future<List<Movie>> getUpcomingMovies() async {
    return _getMovies('/movie/upcoming');
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    throw Exception('Search failed');
  }

  Future<List<Movie>> _getMovies(String path) async {
    final url = Uri.parse('$baseUrl$path?api_key=$apiKey&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    throw Exception('Gagal memuat data film.');
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['cast'] ?? [];
      return results.map((cast) => Cast.fromJson(cast)).toList();
    }

    throw Exception('Gagal memuat cast.');
  }

  Future<List<Crew>> getMovieCrew(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['crew'] ?? [];
      return results.map((crew) => Crew.fromJson(crew)).toList();
    }

    throw Exception('Gagal memuat crew.');
  }

  Future<String?> getMovieTrailerKey(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'] ?? [];
      final trailer = results.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      if (trailer != null) {
        return trailer['key'] as String?;
      }
      return null;
    }

    throw Exception('Gagal memuat trailer.');
  }
}
