
import 'package:flutter/material.dart';
import 'package:test_weather/models/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weatherDay;
  const WeatherWidget({required this.weatherDay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0, bottom: 10.0,),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.4,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            weatherDay.current.toString() + "\u00B0",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Image(
            image: AssetImage(weatherDay.image!),
            width: 50,
            height: 50,
          ),
          Text(
            weatherDay.time!,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}