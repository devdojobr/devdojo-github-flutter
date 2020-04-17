import 'dart:convert';

import 'package:github/http/http_exception.dart';
import 'package:http/http.dart' as http;

abstract class HttpProvider {
  static const int TIME_OUT = 60;
  static const int MIM_STATUS_CODE_ERROR = 400;

  static Future<http.Response> delete(String url) async {
    var headers = Map<String, String>();
    var response = await http.delete(url, headers: headers).timeout(Duration(seconds: TIME_OUT));
    if (response.statusCode >= MIM_STATUS_CODE_ERROR) {
      print(response.body);
      throw HttpException(response);
    }
    return response;
  }

  static Future<http.Response> get(String url) async {
    var headers = Map<String, String>();
    var response = await http.get(url, headers: headers).timeout(Duration(seconds: TIME_OUT));
    if (response.statusCode >= MIM_STATUS_CODE_ERROR) {
      print(response.body);
      throw HttpException(response);
    }
    return response;
  }

  static Future<http.Response> post({String url, Object body, Map<String, String> headers}) async {
    var myHeaders = {"Content-Type": "application/json"};
    if (headers != null) {
      myHeaders.addAll(headers);
    }
    var response = await http.post(url, body: json.encode(body), headers: myHeaders).timeout(Duration(seconds: TIME_OUT));
    if (response.statusCode >= MIM_STATUS_CODE_ERROR) {
      print(response.body);
      throw HttpException(response);
    }
    return response;
  }

  static Future<http.Response> put(String url, Object body) async {
    var headers = {"Content-Type": "application/json"};
    var response = await http.put(url, body: json.encode(body), headers: headers).timeout(Duration(seconds: TIME_OUT));
    if (response.statusCode >= MIM_STATUS_CODE_ERROR) {
      print(response.body);
      throw HttpException(response);
    }
    return response;
  }
}
