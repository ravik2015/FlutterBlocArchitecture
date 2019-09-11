import 'package:meta/meta.dart';

class User {
  User({
    @required this.name,
    @required this.surname,
  });

  final String name;
  final String surname;
}

class Country {
  Country({
    @required this.id,
    @required this.name,
    @required this.code,
    @required this.currencyCode,
  });

  final String id;
  final String name;
  final String code;
  final String currencyCode;
}

class CountryListModel {
  final String name;
  final String id;
  final String code;
  final String currencyCode;

  CountryListModel(this.name, this.id, this.code, this.currencyCode);

  CountryListModel.fromJson(Map json)
      : name = json['name'],
        code = json['code'],
        currencyCode = json['currencyCode'],
        id = json['_id'];

  Map toJson() =>
      {'name': name, 'email': id, 'code': code, "currencyCode": currencyCode};
}
