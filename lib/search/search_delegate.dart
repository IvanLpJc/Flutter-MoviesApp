import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

/**
 * * Tenemos que implemetar estos métodos para que sea un SearchDelegate
 */
class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar película';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          /**
       * i Este método close() lo tenemos gracias al SearchDelegate.
       * i El primer parámetro es el context, que lo tenemos
       * i El segundo es lo que va a devolver como resultado de ejecutar
       * i la función showSearch()
       */
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  Widget _emptyContainer() {
    return const Center(
        child: Icon(Icons.movie_creation_outlined,
            color: Colors.black38, size: 130));
  }

  Widget _loadingBar() {
    return const Center(
        child: Icon(Icons.movie_creation_outlined,
            color: Colors.black38, size: 130));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /**
     * i $query proviene del SearchDelegate
     */
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);
    /**
     * i En un principio usaba este futureBUilder porque 
     * i no estaba utilizando el stream
     */
    // return FutureBuilder(
    //     future: moviesProvider.searchMovies(query),
    //     builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
    //       if (!snapshot.hasData) {
    //         return const LinearProgressIndicator(
    //           color: Colors.indigo,
    //         );
    //       }
    //       final movies = snapshot.data!;

    //       return ListView.builder(
    //         itemCount: movies.length,
    //         itemBuilder: (_, int index) => _MovieItem(movies[index]),
    //       );
    //     });

    return StreamBuilder(
        /**
       * i La petición se va a disparar solo cuando el moviesProvider lo diga
       * i en lugar de hacerlo cada vez que teclea el usuario
       */
        stream: moviesProvider.suggestionStream,
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator(
              color: Colors.indigo,
            );
          }
          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _MovieItem(movies[index]),
          );
        });
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem(this.movie);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          image: NetworkImage(movie.fullPosterImg),
          placeholder: const AssetImage('assets/no-image.jpg'),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () =>
          {Navigator.pushNamed(context, '/detailsScreen', arguments: movie)},
    );
  }
}
