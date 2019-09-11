import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRepository {
  login(data) async {
    var responseJson = await authenticateUser(data);
    return responseJson;
  }

  static dynamic authenticateUser(Object data) async {
    var uri = "http://meanstack.stagingsdei.com:4565/api/users/login";
    try {
      final response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));

      final responseJson = json.decode(response.body);
      print(responseJson);
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
