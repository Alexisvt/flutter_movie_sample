import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'dart:convert';

class MovieApiProvider {
  Client client = Client();
  final String _apiKey = '5026d453d2adf1c01e3ad706180ba90e';

  Future<ItemModel> fetchMovieList() async {
    print('entered');
    final response = await client
        .get('http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey');
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
