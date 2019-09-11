import 'dart:async';

import 'package:midastouch/data/data.dart';
import 'package:midastouch/repositories/Repository.dart';

class UserBloc {
  UserBloc(this._repository);

  final Repository _repository;

  // declare streams
  final _userStreamController = StreamController<UserState>();

  // init streams to work with Widget
  Stream<UserState> get user => _userStreamController.stream;

  // making api call to get user data from server and sink it back to widget using stream
  void loadUserData() {
    _userStreamController.sink.add(UserState._userLoading());
    _repository.getUser().then((user) {
      _userStreamController.sink.add(UserState._userData(user));
    });
  }

  void dispose() {
    // Close all instances of `dart.core.Sink`
    _userStreamController.close();
  }
}

// manage user different states for widget rendering
class UserState {
  UserState();
  factory UserState._userData(User user) = UserDataState;
  factory UserState._userLoading() = UserLoadingState;
}

class UserInitState extends UserState {}

class UserLoadingState extends UserState {}

class UserDataState extends UserState {
  UserDataState(this.user);
  final User user;
}
