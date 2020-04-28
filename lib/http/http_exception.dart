import 'package:http/http.dart';

class HttpException implements Exception {
  final Response _respose;

  const HttpException(this._respose);

  Map<String, String> get headers => this._respose.headers;

  int get statusCode => this._respose.statusCode;

  String get body => this._respose.body;
}
