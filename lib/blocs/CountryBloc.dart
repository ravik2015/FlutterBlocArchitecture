import 'dart:async';

import 'package:midastouch/data/data.dart';
import 'package:midastouch/repositories/Repository.dart';

class CountryBloc {
  CountryBloc(this._repository);

  final Repository _repository;

  // declare streams
  final _countriesStreamController = StreamController<CountryState>();

  // init streams to work with Widget
  Stream<CountryState> get countries => _countriesStreamController.stream;

  // making api call to get countries data from server and sink it back to widget using stream
  void loadCountries() {
    _countriesStreamController.sink.add(CountryState._countryLoading());
    _repository.getCountries().then((country) {
      if (country['statusCode'] == 200) {
        var postList = ((country['data']) as List)
            .map((data) => new CountryListModel.fromJson(data))
            .toList();
        _countriesStreamController.sink
            .add(CountryState._countriesData(postList));
      } else {
        _countriesStreamController.sink.add(CountryState._countryError());
      }
    });
  }

  void dispose() {
    // Close all instances of `dart.core.Sink`
    _countriesStreamController.close();
  }
}

// manage country different states for widget rendering
class CountryState {
  CountryState();
  factory CountryState._countriesData(country) = CountryDataState;
  factory CountryState._countryLoading() = CountryLoadingState;
  factory CountryState._countryError() = CountryErrorState;
}

class CountryInitState extends CountryState {}

class CountryLoadingState extends CountryState {}

class CountryErrorState extends CountryState {}

class CountryDataState extends CountryState {
  CountryDataState(this.country);
  final country;
}
