import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:peliculas/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * i Con esto busca instancias de MoviesProvider, si no encuentra ninguna
     * i creeará una siempre y cuando el método ChangeNotifierProvider esté
     * i implementado.
     * 
     * ? Como funciona
     * i Va al arbol de widgets (usando el context) y trae las instancias que
     * i encuentres de MoviesProvider y esa instancia colocala en moviesProvider
     * 
     * ! El listen:true le dice al provider que redibuje cuando haya un cambio en los datos
     * i El listen: false cuando se encuentra dentro de algún método porque daría un error
     */
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
              /**
             * i El showSearch es un método ya disponible en toda la app
             * i tenemos que crear un delegate para la búsqueda
             */
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CardSwiper(
            movies: moviesProvider.onDisplayMovies,
          ),
          MovieSlider(
            movies: moviesProvider.popularMovies,
            title: 'Populares', //opcional
            onNextPage: () => moviesProvider.getPopularMovies(),
          ),
        ]),
      ),
    );
  }
}
