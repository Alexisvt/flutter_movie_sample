import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../models/models.dart';

class MovieDetail extends StatefulWidget {
  final String posterUrl;
  final String description;
  final String releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail({
    this.description,
    this.posterUrl,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.movieId,
  });

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  MovieDetailBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.fetchTrailersById(widget.movieId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.posterUrl}',
                  fit: BoxFit.cover,
                )),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                    ),
                    Text(
                      widget.voteAverage,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                    ),
                    Text(
                      widget.releaseDate,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                ),
                Text(widget.description),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(
                  "Trailer",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                ),
                buildStreamBuilder()
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<Future<TrailerModel>> buildStreamBuilder() {
    return StreamBuilder<Future<TrailerModel>>(
      stream: bloc.movieTrailers,
      builder:
          (BuildContext context, AsyncSnapshot<Future<TrailerModel>> snapshot) {
        if (snapshot.hasData) {
          // TODO: do something with the data
          return buildFutureBuilder(snapshot);
        } else {
          // TODO: the data is not ready, show a loading indicator
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  FutureBuilder<TrailerModel> buildFutureBuilder(
      AsyncSnapshot<Future<TrailerModel>> snapshot) {
    return FutureBuilder<TrailerModel>(
      future: snapshot.data,
      builder:
          (BuildContext context, AsyncSnapshot<TrailerModel> itemSnapShot) {
        if (itemSnapShot.hasData) {
          if (itemSnapShot.data.results.length > 0)
            return trailerLayout(itemSnapShot.data);
          else
            return noTrailer(itemSnapShot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget noTrailer(TrailerModel data) {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget trailerLayout(TrailerModel data) {
    if (data.results.length > 1) {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
          trailerItem(data, 1),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
        ],
      );
    }
  }

  trailerItem(TrailerModel data, int index) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5.0),
            height: 100.0,
            color: Colors.grey,
            child: Center(child: Icon(Icons.play_circle_filled)),
          ),
          Text(
            data.results[index].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
