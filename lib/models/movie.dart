/// Model représentant un film récupéré de l'API OMDB.
class Movie {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String actors;
  final String plot;
  final String? poster;

  Movie({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    this.poster,
  });

  /// Factory constructor pour créer une instance de Movie à partir d'un JSON.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      rated: json['Rated'] ?? '',
      released: json['Released'] ?? '',
      runtime: json['Runtime'] ?? '',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? '',
      actors: json['Actors'] ?? '',
      plot: json['Plot'] ?? '',
      poster: json['Poster'] != null && json['Poster'] != 'N/A' ? json['Poster'] : null,
    );
  }

  /// Conversion d'une instance Movie en JSON.
  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'Rated': rated,
      'Released': released,
      'Runtime': runtime,
      'Genre': genre,
      'Director': director,
      'Actors': actors,
      'Plot': plot,
      'Poster': poster,
    };
  }
}
