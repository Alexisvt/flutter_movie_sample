import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'dart:convert';

class MovieApiProvider {
  Client client = Client();
  final String _apiKey = 'your_api_key';

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
