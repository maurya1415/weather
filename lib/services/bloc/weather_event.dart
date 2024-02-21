part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

// ignore: must_be_immutable
class SearchWeatherEvent extends WeatherEvent {
  double latitude;
  double longitude;
  SearchWeatherEvent(this.latitude, this.longitude);
}

// ignore: must_be_immutable
class ErrorWeatherEvent extends WeatherEvent {
  String error;
  ErrorWeatherEvent(this.error);
}
