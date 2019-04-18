import 'package:rxdart/rxdart.dart';
import '../models/models.dart';
import '../resources/resources.dart';

class MovieDetailBloc {
  final Repository _repository = Repository();
  final PublishSubject<int> _movieId = PublishSubject<int>();
  final BehaviorSubject<Future<TrailerModel>> _trailers =
      BehaviorSubject<Future<TrailerModel>>();

  Function(int) get fetchTrailersById => _movieId.sink.add;

  Observable<Future<TrailerModel>> get movieTrailers => _trailers.stream;

  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
  }

  dispose() async {
    _movieId.close();
    await _trailers.drain();
    _trailers.close();
  }

  ScanStreamTransformer<int, Future<TrailerModel>> _itemTransformer() {
    return ScanStreamTransformer(
      (Future<TrailerModel> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailers(id);
        return trailer;
      },
    );
  }
}
