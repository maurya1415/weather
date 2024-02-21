part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoadingState extends WeatherState {}

final class WeatherLoadedState extends WeatherState {
  WeatherModel weather;
  WeatherLoadedState(this.weather);
}

final class WeatherErrorState extends WeatherState {
  String? errormsg;
  WeatherErrorState(this.errormsg);
}
