
import 'package:flutter/material.dart';

import 'package:test_weather/util/utils.dart';
import 'package:test_weather/models/weather.dart';
import 'package:test_weather/ui/widget/seven_day.dart';
import 'package:test_weather/ui/widget/tomorrow_weather.dart';

class WeatherNextDay extends StatelessWidget {
  final Weather tomorrowTemp;
  final List<Weather> sevenDay;
  final Function() previousWeather;

  const WeatherNextDay({
    required this.tomorrowTemp,
    required this.sevenDay,
    required this.previousWeather,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(getBackground(tomorrowTemp.name!)),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            TomorrowWeather(
              tomorrowTemp: tomorrowTemp,
              previousWeather: previousWeather,
            ),
            SevenDays(sevenDay: sevenDay,),
          ],
        ),
      ),
    );
  }
}