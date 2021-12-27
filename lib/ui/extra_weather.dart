
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:test_weather/models/weather.dart';

class ExtraWeather extends StatelessWidget {
  final Weather temp;
  const ExtraWeather(this.temp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            const Icon(
              CupertinoIcons.wind,
              color: Colors.white,
            ),
            const SizedBox(height: 5.0,),
            Text(
              temp.wind.toString() + " Kм/ч",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5.0,),
            const Text(
              "Ветер",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const Icon(
              CupertinoIcons.drop,
              color: Colors.white,
            ),
            const SizedBox(height: 5.0,),
            Text(
              temp.humidity.toString() + " %",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5.0,),
            const Text(
              'Влажность',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const Icon(
              CupertinoIcons.cloud_rain,
              color: Colors.white,
            ),
            const SizedBox(height: 5.0,),
            Text(
              temp.chanceRain.toString() + " %",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5.0,),
            const Text(
              'Дождь',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            )
          ],
        ),
      ],
    );
  }
}