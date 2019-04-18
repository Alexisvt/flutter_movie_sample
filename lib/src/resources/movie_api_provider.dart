import 'package:http/http.dart' show Client;
import '../models/models.dart';
import 'dart:convert';

class MovieApiProvider {
  Client client = Client();
  final String _apiKey = '5026d453d2adf1c01e3ad706180ba90e';
  final String _baseUrl = "http://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList() async {
    final response = await client
        .get('http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    final response =
        await client.get('$_baseUrl/$movieId/videos?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
