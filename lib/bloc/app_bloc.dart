import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../models/weather_model.dart';
import '../repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.repository) : super(AppInitial()) {
    on<IncrementEvent>((event, emit) async {
      if (_isDarkMode) {
        counter += 2;
      } else {
        counter++;
      }
      normilizeCunter();

      emit(CounterChanged(counter));
    });
    on<DecrementEvent>((event, emit) {
      if (_isDarkMode) {
        counter -= 2;
      } else {
        counter--;
      }
      normilizeCunter();
      emit(CounterChanged(counter));
    });
    on<ThemeEvent>((event, emit) {
      _isDarkMode = !_isDarkMode;
      emit(ThemeChanged(_isDarkMode));
    });
    on<UpdateWeather>((event, emit) async {
      final position = await _determinePosition();
      model = await repository.getWeather(position.latitude, position.longitude);
      emit(WeatherChanged(model!));
    });
  }

  bool _isDarkMode = false;
  int counter = 0;
  WeatherModel? model;
  final AppRepository repository;
  normilizeCunter() {
    counter = max(min(10, counter), 0);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
