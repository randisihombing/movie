import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _apiKey = 'ed49ff986009899bc976c88cca46671c';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  //take all now playing movies
  Future<List<dynamic>> fetchNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'].take(6).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  //take all popular movie
  Future<List<dynamic>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'].take(20).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  //take detail movie
  Future<dynamic> fetchMovieDetail(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  //take all similar movie
  Future<List<dynamic>> fetchSimilarMovies(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId/similar?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load similar movies');
    }
  }
}
