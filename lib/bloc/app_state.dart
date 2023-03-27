part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class CounterChanged extends AppState {
  final int counter;

  CounterChanged(this.counter);
}

class WeatherChanged extends AppState {
  final WeatherModel model;

  WeatherChanged(this.model);
}

class WeatherError extends AppState {
  final String message;

  WeatherError(this.message);
}

class ThemeChanged extends AppState {
  final bool isDarkMode;

  ThemeChanged(this.isDarkMode);
}
