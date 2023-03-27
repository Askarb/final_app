import 'package:final_app/bloc/app_bloc.dart';
import 'package:final_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dio_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => DioSettings()),
        RepositoryProvider(create: (context) => AppRepository(RepositoryProvider.of<DioSettings>(context).dio)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBloc(RepositoryProvider.of<AppRepository>(context))),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget? weather;
  Color bgColor = Colors.white;
  Color textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                if (state is WeatherChanged || state is ThemeChanged) {
                  final model = BlocProvider.of<AppBloc>(context).model;
                  if (model != null) {
                    weather = Text(
                      "${model.name}: ${model.main?.temp}",
                      style: TextStyle(color: textColor),
                    );
                  }
                }

                return weather ??
                    Text(
                      "Тут будет погода",
                      style: TextStyle(color: textColor),
                    );
              },
            ),
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(color: textColor),
            ),
            BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              return Text(
                '${BlocProvider.of<AppBloc>(context).counter}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textColor),
              );
            }),
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: BlocProvider.of<AppBloc>(context).counter >= 10
                      ? null
                      : () {
                          BlocProvider.of<AppBloc>(context).add(IncrementEvent());
                        },
                  child: const Text("+"),
                );
              },
            ),
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: BlocProvider.of<AppBloc>(context).counter <= 0
                      ? null
                      : () {
                          BlocProvider.of<AppBloc>(context).add(DecrementEvent());
                        },
                  child: const Text("-"),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AppBloc>(context).add(UpdateWeather());
              },
              child: const Text('Weather'),
            ),
            BlocListener<AppBloc, AppState>(
              listener: (context, state) {
                if (state is ThemeChanged) {
                  setState(() {
                    if (state.isDarkMode) {
                      bgColor = Colors.black;
                      textColor = Colors.white;
                    } else {
                      bgColor = Colors.white;
                      textColor = Colors.black;
                    }
                  });
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AppBloc>(context).add(ThemeEvent());
                },
                child: const Text('Dark(on/off)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
