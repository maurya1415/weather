import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/services/api_helper.dart';
import 'package:weather/services/weathermodel.dart';
import 'package:http/http.dart' as httpClient;
import 'dart:convert';
import 'dart:io';

import 'my_exception.dart';

class WeatherRepository {
  Future<WeatherModel> getDAta(double mlatitude, double mlongitude) async {
    await Future.delayed(const Duration(seconds: 1));
    var url =
        "https://api.open-meteo.com/v1/forecast?latitude=$mlatitude&longitude=$mlongitude&hourly=temperature_2m,relativehumidity_2m,precipitation,rain,weathercode,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum&current_weather=true&timezone=auto";
    try {
      var data = await Apihelper().getApi(url);

      print("yes");
      return WeatherModel.fromJson(data);
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      print("not $e");

      return WeatherModel();
    }
  }

  Future<List<List<double>>> convertAddressToCoordinates(String address) async {
    final url = "https://geocode.maps.co/search?q={$address}";
    final response = await httpClient.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final List<List<double>> coordinatesList = [];

        for (final place in data) {
          final latitude = double.tryParse(place["lat"]);
          final longitude = double.tryParse(place["lon"]);
          if (latitude != null && longitude != null) {
            coordinatesList.add([latitude, longitude]);
          }
        }

        return coordinatesList;
      } else {
        print("Failed to fetch data.");
        return [];
      }
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      return [];
    }
  }

  // Future<List<double>> convertAddressToCoordinates(String address) async {
  //   final url = Uri.parse(
  //       'https://nominatim.openstreetmap.org/search?format=json&q=$address');

  //   try {
  //     final response = await httpClient.get(url);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);

  //       if (data.isNotEmpty) {
  //         final location =
  //             data[0]; // Assuming you're interested in the first location
  //         final latitude = double.parse(location['lat']);
  //         final longitude = double.parse(location['lon']);

  //         return [latitude, longitude];
  //       } else {
  //         print('No location data found for the address');
  //         return [];
  //       }
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print("Error converting address: $e");
  //     return [];
  //   }
  // }

  //SharedPreferences prefs;
  Future<String> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key) ??
        ''; // Return an empty string if the key doesn't exist
    return value;
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
