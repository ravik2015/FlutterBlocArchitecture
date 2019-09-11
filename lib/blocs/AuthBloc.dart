import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midastouch/repositories/AuthRepository.dart';
import 'package:midastouch/screens/UserBlocScreen.dart';

class AuthBloc {
  AuthBloc(this._repository);

  final AuthRepository _repository;

  // declare streams
  final _authStreamController = StreamController<AuthState>();

  // init streams to work with Widget
  Stream<AuthState> get loginUser => _authStreamController.stream;

  // making api call to get countries data from server and sink it back to widget using stream
  void authenticateUser(data, context) {
    _authStreamController.sink.add(AuthState._countryLoading());
    _repository.login(data).then((country) {
      if (country['statusCode'] == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserBlocScreen()),
        );
        _authStreamController.sink
            .add(AuthState._countriesData(country['data']));
      } else {
        print(country['message']);
        print('=====================?????????');
        _authStreamController.sink
            .add(AuthState._countryError(country['message'].toString()));
      }
    });
  }

  void dispose() {
    // Close all instances of `dart.core.Sink`
    _authStreamController.close();
  }
}

// manage country different states for widget rendering
class AuthState {
  AuthState();
  factory AuthState._countriesData(country) = AuthDataState;
  factory AuthState._countryLoading() = AuthLoadingState;
  factory AuthState._countryError(String data) = AuthErrorState;
}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  AuthErrorState(this.message);
  final String message;
}

class AuthDataState extends AuthState {
  AuthDataState(this.country);
  final country;
}
