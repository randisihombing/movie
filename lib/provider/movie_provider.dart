import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/api_service.dart';

class MovieProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<dynamic> _nowPlayingMovies = [];
  List<dynamic> _popularMovies = [];
  List<int> _watchlist = [];
  List<int> _favorites = [];

  List<dynamic> get nowPlayingMovies => _nowPlayingMovies;
  List<dynamic> get popularMovies => _popularMovies;
  List<int> get watchlist => _watchlist;
  List<int> get favorites => _favorites;

  MovieProvider() {
    loadNowPlayingMovies();
    loadPopularMovies();
    loadWatchlist();
    loadFavorites();
  }

  Future<void> loadNowPlayingMovies() async {
    _nowPlayingMovies = await _apiService.fetchNowPlayingMovies();
    notifyListeners();
  }

  Future<void> loadPopularMovies() async {
    _popularMovies = await _apiService.fetchPopularMovies();
    notifyListeners();
  }

  void addToWatchlist(int movieId) {
    if (!_watchlist.contains(movieId)) {
      _watchlist.add(movieId);
      saveWatchlist();
      notifyListeners();
    }
  }

  void removeFromWatchlist(int movieId) {
    if (_watchlist.contains(movieId)) {
      _watchlist.remove(movieId);
      saveWatchlist();
      notifyListeners();
    } else {
      debugPrint("Movie with ID: $movieId not found in watchlist");
    }
  }

  void addToFavorites(int movieId) {
    if (!_favorites.contains(movieId)) {
      debugPrint("Adding movie with ID: $movieId to favorites");
      _favorites.add(movieId);
      saveFavorites();
      notifyListeners();
    }
  }

  void removeFromFavorites(int movieId) {
    if (_favorites.contains(movieId)) {
      debugPrint("Removing movie with ID: $movieId from favorites");
      _favorites.remove(movieId);
      saveFavorites();
      notifyListeners();
    }
  }

  bool isInWatchlist(int movieId) {
    return _watchlist.contains(movieId);
  }

  bool isFavorite(int movieId) {
    return _favorites.contains(movieId);
  }

  void saveWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('watchlist', _watchlist.map((e) => e.toString()).toList());
  }

  void saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites.map((e) => e.toString()).toList());
  }

  void loadWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _watchlist = prefs.getStringList('watchlist')?.map((e) => int.parse(e)).toList() ?? [];
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites')?.map((e) => int.parse(e)).toList() ?? [];
  }
}
