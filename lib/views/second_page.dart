import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawer_auth/viewmodels/movie_search_viewmodel.dart';
import 'package:drawer_auth/widgets/app_drawer.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieSearchViewModel(),
      child: MovieSearchPageContent(),
    );
  }
}

class MovieSearchPageContent extends StatefulWidget {
  @override
  _MovieSearchPageContentState createState() => _MovieSearchPageContentState();
}

class _MovieSearchPageContentState extends State<MovieSearchPageContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de Films'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de texte pour la recherche
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Entrez le titre du film',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.movie),
              ),
              onChanged: (value) {
                context.read<MovieSearchViewModel>().setMovieTitle(value);
              },
            ),
            SizedBox(height: 10),

            // Bouton de recherche
            Consumer<MovieSearchViewModel>(
              builder: (context, viewModel, _) {
                return ElevatedButton.icon(
                  onPressed: viewModel.searchMovie,
                  icon: Icon(Icons.search),
                  label: Text('Rechercher'),
                );
              },
            ),
            SizedBox(height: 20),

            // Corps de la page avec les résultats
            Expanded(
              child: Consumer<MovieSearchViewModel>(
                builder: (context, viewModel, _) {
                  if (viewModel.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    // Si il y a un message d'erreur
                  } else if (viewModel.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            viewModel.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                    // Si le film existe
                  } else if (viewModel.movieData != null) {
                    final movie = viewModel.movieData!;
                    return ListView(
                      children: [
                        // Affiche du film
                        if (movie.poster != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: Image.network(
                                movie.poster!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                          ),

                        // Titre du film
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Détails du film
                        _buildDetailRow('Année:', movie.year),
                        _buildDetailRow('Classification:', movie.rated),
                        _buildDetailRow('Date de sortie:', movie.released),
                        _buildDetailRow('Durée:', movie.runtime),
                        _buildDetailRow('Genre:', movie.genre),
                        _buildDetailRow('Réalisateur:', movie.director),
                        _buildDetailRow('Acteurs:', movie.actors),
                        SizedBox(height: 12),

                        // Synopsis
                        Text(
                          'Synopsis:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie.plot,
                          style: TextStyle(height: 1.5),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Entrez un titre de film et cliquez sur "Rechercher"',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper pour afficher le détail d'un film.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
