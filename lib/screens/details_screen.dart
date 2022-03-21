import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * i Aquí tenemos que especifiar el tipo de objeto que le está llegando,
     * i para que lo trate como una película
     */
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      // Un scroll que nos permite usar los slivers
      body: CustomScrollView(
        // Slivers: Son widgets con cierto comportamiento pre-programado cuando se hace scroll en el contenido del padre
        slivers: <Widget>[
          _CustomAppBar(
            movie,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(
              movie: movie,
            ),
            _Overview(overview: movie.overview),
            CastingCards(
              movieId: movie.id,
            ),
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  //const _CustomAppBar({Key? key, required this.movie}) : super(key: key);
  // O en su lugar odemos hacer el constructor posicional con solo esto:
  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.indigo,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.black26,
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Text(
              movie.title,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )),
        background: FadeInImage(
            placeholder: const AssetImage("assets/loading.gif"),
            image: NetworkImage(movie.fullBackdropPath),
            fit: BoxFit.cover),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: movie.heroId!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullBackdropPath),
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                movie.originalTitle,
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_outline,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(movie.voteAverage.toString(), style: textTheme.caption),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class _Overview extends StatelessWidget {
  final String? overview;
  const _Overview({Key? key, this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Text(
          overview == null ? 'No data' : overview!,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.subtitle1,
        ));
  }
}
