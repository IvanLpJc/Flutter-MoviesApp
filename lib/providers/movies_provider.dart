import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

// i Debe extender de ChangeNotifier para que sea un provider
// i como es un provider, puedo tener acceso a sus metodos y atributos PUBLICOS
// i desde cualquier otro widget
class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '5e9c681c7b5102c65e9d0584476b9a78';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> moviesByClassification = [];
  List<Movie> recommendedMovies = [];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        child: Text('Populares'),
        value: 'popular',
      ),
      const DropdownMenuItem(
        child: Text('Próximamente'),
        value: 'upcoming',
      ),
      const DropdownMenuItem(
        child: Text('Mejor valoradas'),
        value: 'top_rated',
      ),
    ];

    return menuItems;
  }

  late String selectedClassification;

  // <id-pelicula>, cast
  Map<int, List<Cast>> moviesCast = {};

  int _classificationPage = 0;
  int _recommendedPage = 0;
  /**
   * i Tenemos que implementar el Debouncer
   */
  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  /**
   * i Aquí creamos el stream que devolvera una lista de películas
   * i Como el stream puede ser que lo estemos escuchando en varios objetos
   * i así que le hacemos un broadcast()
   * 
   */

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  /**
   * i Tenemos que crear el stream para poder manegar lo que ocurre en el streamcontroller
   * i y lo hacemos un getter para poder obtener la info
   */
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider inicializado');
    selectedClassification = 'popular';
    getOnDisplayMovies();
    getMoviesByClassification();
  }
  // ignore: slash_for_doc_comments
  /**
   * i Con el [int page =1] le indicamos que va a tener ese valor en caso de no
   * i recibir ninguno por parámetro
   */

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //final Map<String, dynamic> decodedData = json.decode(response.body);

    //onDisplayMovies = nowPlayingResponse.results;
    // i Usamos esta forma de asignar los resultados usando deestructuración
    // i del objeto
    onDisplayMovies = [...onDisplayMovies, ...nowPlayingResponse.results];
    /**
     * i El notifyListener le avisa a todos los widgets que esten escuchando
     * i para que redibuje cuando se hace una modificación en los datos
     */
    notifyListeners();
  }

  cleanSelection() {
    moviesByClassification = [];
    _classificationPage = 0;
    notifyListeners();
  }

  getMoviesByClassification() async {
    _classificationPage += 1;

    final jsonData = await _getJsonData(
        '3/movie/$selectedClassification', _classificationPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    //final Map<String, dynamic> decodedData = json.decode(response.body);

    //popularMovies = popularResponse.results;
    // i Usamos esta forma de asignar los resultados usando deestructuración
    // i del objeto, de este modo, mantenemos las películas anteriores cuando cargamos las nuevas
    moviesByClassification = [
      ...moviesByClassification,
      ...popularResponse.results
    ];
    /**
     * i El notifyListener le avisa a todos los widgets que esten escuchando
     * i para que redibuje cuando se hace una modificación en los datos
     */
    notifyListeners();
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    _recommendedPage += 1;

    final jsonData = await _getJsonData('3/movie/$movieId/similar');
    final recommendationsResponse = PopularResponse.fromJson(jsonData);

    return recommendationsResponse.results;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    /**
     * i Con esto comprobamos si el cast de película ya está en el vector de 
     * i cast, lo devolvemos del vector
     */
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  // ignore: slash_for_doc_comments
  /**
   * i Hay que modificar este método para que nos devuelva un string
   */

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  /**
   * * Este método inserta el valor del query al stream pero solo cuando el 
   * * debouncer lo dice, en este caso, cuando la persona deje de escribir
   */

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
