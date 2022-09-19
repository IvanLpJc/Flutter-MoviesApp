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
      body: Column(children: [
        _DropDownButton(
          moviesProvider: moviesProvider,
        ),
        Expanded(
          child: GridView.builder(
              padding: EdgeInsets.only(top: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 100),
              itemCount: moviesProvider.onDisplayMovies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = moviesProvider.onDisplayMovies[index];
                return MoviePoster(movie, 'slider-${movie.id}');
              }),
        ),
      ]),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverFillRemaining(
      //       hasScrollBody: false,
      //       child: Column(children: [
      //         CardSwiper(
      //           movies: moviesProvider.onDisplayMovies,
      //         ),
      //         _DropDownButton(moviesProvider: moviesProvider),
      //         MovieSlider(
      //           movies: moviesProvider.moviesByClassification,
      //           onNextPage: () => moviesProvider.getMoviesByClassification(),
      //         ),
      //       ]),
      //     )
      //   ],
      // ),
    );
  }
}

class _DropDownButton extends StatefulWidget {
  const _DropDownButton({
    Key? key,
    required this.moviesProvider,
  }) : super(key: key);

  final MoviesProvider moviesProvider;

  @override
  State<_DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<_DropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      isExpanded: true,
      enableFeedback: true,
      borderRadius: BorderRadius.circular(25),
      style: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      items: widget.moviesProvider.dropdownItems,
      onChanged: (String? value) {
        if (widget.moviesProvider.selectedClassification != value) {
          widget.moviesProvider.selectedClassification =
              value ?? widget.moviesProvider.selectedClassification;
          widget.moviesProvider.cleanSelection();
          widget.moviesProvider.getMoviesByClassification();
          setState(() {});
        }
      },
      value: widget.moviesProvider.selectedClassification,
    );
  }
}
