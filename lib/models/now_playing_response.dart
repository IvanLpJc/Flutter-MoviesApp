// To parse this JSON data, do
//
//     final nowPlaying = nowPlayingFromMap(jsonString);

/// i Cuando tenemos que crear una clase para la response de una petición http
/// i podemos utilizar la página web https://app.quicktype.io/
/// i Copiamos el JSON con los resultados y la página crea la clase

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class NowPlayingResponse {
  NowPlayingResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

// ignore: slash_for_doc_comments
/**
 * i Esto es un factory constructor. El NowPlayingResponse.fromJson es un factory constructor
 * i que recibe un string y devuelve una instrancia de NowPlayingResponse.fromMap(json.decode(str))
*/
  factory NowPlayingResponse.fromJson(String str) =>
      NowPlayingResponse.fromMap(json.decode(str));

  //i Toma la instancia de la clase y lo crea como un Mapa, aunque ahora no es necesario
  // String toJson() => json.encode(toMap());

  // ignore: slash_for_doc_comments
  /**
   * i Esto es un factory constructor. El NowPlayingResponse.fromMap es un factory constructor
   * i que recibe un mapa llamado json y devuelve una instrancia de NowPlayingResponse.fromMap(json.decode(str))
  */
  factory NowPlayingResponse.fromMap(Map<String, dynamic> json) =>
      NowPlayingResponse(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results:
            /**
         * i Esto leerá los resultados y los alamacenará
         * i se crea un listado de instancias de Movie
         */
            List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  // i Con este metodo creamos el mapa necesario para el caso de querer hacer un
  // i post
  // Map<String, dynamic> toMap() => {
  //       "dates": dates.toMap(),
  //       "page": page,
  //       "results": List<dynamic>.from(results.map((x) => x.toMap())),
  //       "total_pages": totalPages,
  //       "total_results": totalResults,
  //     };
}

class Dates {
  Dates({
    required this.maximum,
    required this.minimum,
  });

  DateTime maximum;
  DateTime minimum;

  /// i Con estos dos métodos tengo de sobra
  factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );
}

/**
 * ! Originalmente había aqui una cl clase se llama resultados
 * i Pero nosotro lo renombramos a Movie
 * 
 * i La clase resultante la movemos a un archivo aparte
 * 
 */
