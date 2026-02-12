import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:drawer_auth/models/movie.dart';

class MovieSearchViewModel extends ChangeNotifier {
  late final String _apiKey;

  MovieSearchViewModel() {
    // Récupérer la clé API depuis la variable de compilation Dart
    // Utilisation: flutter run --dart-define=API_KEY=your_api_key
    _apiKey = const String.fromEnvironment('API_KEY');
  }

  String _movieTitle = '';
  Movie? _movieData;
  bool _loading = false;
  String? _errorMessage;

  // Getters
  String get movieTitle => _movieTitle;
  Movie? get movieData => _movieData;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  /// Met à jour le titre du film à rechercher.
  void setMovieTitle(String title) {
    _movieTitle = title;
    notifyListeners();
  }

  /// Recherche un film en utilisant l'API OMDB.
  Future<void> searchMovie() async {
    if (_movieTitle.isEmpty) {
      _errorMessage = 'Veuillez entrer un titre de film';
      _movieData = null;
      notifyListeners();
      return;
    }

    _loading = true;
    _errorMessage = null;
    _movieData = null;
    notifyListeners();

    try {
      final query = _movieTitle.replaceAll(' ', '+');
      final url = 'https://www.omdbapi.com/?apikey=$_apiKey&t=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['Response'] == 'True') {
          _movieData = Movie.fromJson(decodedResponse);
          _errorMessage = null;
        } else {
          _movieData = null;
          _errorMessage = decodedResponse['Error'] ?? 'Film non trouvé';
        }
      } else {
        _movieData = null;
        _errorMessage =
            'Erreur lors de la requête (code ${response.statusCode})';
      }
    } catch (e) {
      _movieData = null;
      _errorMessage = 'Erreur: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Réinitialise les données et les erreurs.
  void clearSearch() {
    _movieTitle = '';
    _movieData = null;
    _errorMessage = null;
    _loading = false;
    notifyListeners();
  }
}
