part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class IncrementEvent extends AppEvent {}

class DecrementEvent extends AppEvent {}

class UpdateWeather extends AppEvent {}

class ThemeEvent extends AppEvent {}
