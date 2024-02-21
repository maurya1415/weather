import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/services/weather_repository.dart';

import '../my_exception.dart';
import '../weathermodel.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<SearchWeatherEvent>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        WeatherModel weatherModel =
            await WeatherRepository().getDAta(event.latitude, event.longitude);

        if (weatherModel.elevation != null) {
          emit(WeatherLoadedState(weatherModel));
        } else {
          emit(WeatherErrorState("Data not found"));
        }
      } catch (e) {
        if (e is MyException) {
          emit(WeatherErrorState(e.toString()));
        }
      }
    });
  }
}
