import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:sweet_title/sweet_title.dart';

import '../models/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
//agregar todo esto
    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.62,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SweetTitle(title: 'En cartelera', fontSize: 30),
          Swiper(
            itemCount: movies.length,
            layout: SwiperLayout.STACK,
            itemWidth: size.width * 0.6,
            itemHeight: size.height * 0.45,
            itemBuilder: (BuildContext context, int index) {
              final movie = movies[index];

              movie.heroId = 'swiper-${movie.id}';

              // i GestureDetector - Nos permite ponerle una acción al widget
              // i en este caso hacemo que vaya a la pantalla detailsScreen
              return GestureDetector(
                onTap: (() => Navigator.pushNamed(context, '/detailsScreen',
                    arguments: movie)),
                child: Hero(
                  tag: movie.heroId!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(movie.fullPosterImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
