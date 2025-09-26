import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/movie_provider.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<void>(
        future: movieProvider.fetchMovies(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred while loading movies.'),
            );
          } else {
            return ListView.builder(
              itemCount: movieProvider.movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movieProvider.movies.reversed.toList()[index];
                return ListTile(
                  title: Text(movie.title +
                      movie.movieId.toString() +
                      index.toString()),
                  subtitle: Text(movie.releaseYear),
                  onTap: () {
                    movieProvider.selectMovie(movie.movieId);
                    // movie.title
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
