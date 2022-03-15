import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/popular_response.dart';

// i Debe extender de ChangeNotifier para que sea un provider
// i como es un provider, puedo tener acceso a sus metodos y atributos PUBLICOS
// i desde cualquier otro widget
class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '5e9c681c7b5102c65e9d0584476b9a78';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0
;

  MoviesProvider() {
    print('MoviesProvider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
  }
  // ignore: slash_for_doc_comments
  /**
   * i Con el [int page =1] le indicamos que va a tener ese valor en caso de no
   * i recibir ninguno por parámetro
   */

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
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

  getPopularMovies() async {
    _popularPage += 1;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    //final Map<String, dynamic> decodedData = json.decode(response.body);

    //popularMovies = popularResponse.results;
    // i Usamos esta forma de asignar los resultados usando deestructuración
    // i del objeto, de este modo, mantenemos las películas anteriores cuando cargamos las nuevas
    popularMovies = [...popularMovies, ...popularResponse.results];
    /**
     * i El notifyListener le avisa a todos los widgets que esten escuchando
     * i para que redibuje cuando se hace una modificación en los datos
     */
    notifyListeners();
  }
}
