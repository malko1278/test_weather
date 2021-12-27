
import 'package:flutter/material.dart';

import 'package:test_weather/ui/widget/today_weather.dart';

import '../current_weather.dart';

class WeatherOfDay extends StatefulWidget {
  final CurrentWeather currentWeather;
  final TodayWeather weatherDay;
  const WeatherOfDay({
    required this.currentWeather,
    required this.weatherDay,
    Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState(currentWeather, weatherDay);
}

class InitState extends State<WeatherOfDay> {
  CurrentWeather _currentWeather;
  TodayWeather _weatherDay;

  InitState(this._currentWeather, this._weatherDay);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentWeather = widget.currentWeather;
    _weatherDay = widget.weatherDay;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _currentWeather,
          _weatherDay,
        ],
      ),
    );
  }
}