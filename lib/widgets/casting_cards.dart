import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            height: 200,
            child: const CupertinoActivityIndicator(),
          );
        }
        if (snapshot.data!.isEmpty) {
          return const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(child: Text('Cast not available')),
          );
        }
        final cast = snapshot.data!;
        return Container(
            margin: const EdgeInsets.only(bottom: 30, left: 10),
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) => _CastCard(cast[index]),
              itemCount: 10,
            ));
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;

  const _CastCard(this.cast);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      width: 110,
      height: 100,
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(cast.fullProfilePath),
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          cast.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
