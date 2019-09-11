import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:midastouch/data/data.dart';

class Repository {
  Future<User> getUser() async {
    await Future.delayed(Duration(seconds: 2));
    return User(name: 'John', surname: 'Smith');
  }

  getCountries() async {
    var responseJson = await getCountriesList();
    return responseJson;
  }

  static dynamic getCountriesList() async {
    var uri =
        "http://meanstack.stagingsdei.com:4565/api/countries/getCountries";
    try {
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'AuthError';
      } else {
        return null;
      }
    }
  }
}
