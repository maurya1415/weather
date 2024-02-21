import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as httpClient;
import 'package:weather/services/bloc/weather_bloc.dart';

import 'my_exception.dart';

class Apihelper {
  Future<dynamic> getApi(String url) async {
    late dynamic jsonResponse;
    try {
      var response = await httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 2));
      jsonResponse = checkResponse(response);
      print("apihelper work");
      return jsonResponse != null
          ? jsonResponse as Map<dynamic, dynamic>
          : <String, dynamic>{};
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      print("apihelper work not");
      // Handle other exceptions here
      return <String, dynamic>{};
    }
  }

  dynamic checkResponse(httpClient.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJsonData = jsonDecode(response.body.toString());
        return responseJsonData;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw InvalidInputException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with the server with status code: ${response.statusCode.toString()}');
    }
  }
}
