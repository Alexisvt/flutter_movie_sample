import 'package:flutter/material.dart';
import '../blocs/./movies_bloc.dart';
import '../models/models.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    bloc.fetchAllMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: StreamBuilder<ItemModel>(
        stream: bloc.allMovies,
        builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            // TODO: do something with the data
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            // TODO: do something with the error
            return Text(snapshot.error.toString());
          }
          // TODO: the data is not ready, show a loading indicator
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.results.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
