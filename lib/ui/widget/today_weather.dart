
import 'package:flutter/material.dart';

import 'package:test_weather/models/weather.dart';
import 'package:test_weather/ui/widget/weather_widget.dart';

class TodayWeather extends StatelessWidget {
  final Weather tomorrowTemp;
  final List<Weather> todayWeather;
  final List<Weather> weatherSevenDay;
  final Function() nextWeather;

  const TodayWeather({
    required this.tomorrowTemp,
    required this.todayWeather,
    required this.weatherSevenDay,
    required this.nextWeather,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Сегодня",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton (
                child: Row(
                  children: <Widget>[
                    Text(
                      '7 дней ',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey.shade800,
                      size: 15,
                    ),
                  ],
                ),
                onPressed: () {
                  /*Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      DetailPage(
                        tomorrowTemp: tomorrowTemp,
                        sevenDay: weatherSevenDay,
                      );
                    }),
                  );
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        tomorrowTemp: tomorrowTemp,
                        sevenDay: weatherSevenDay,
                      ),
                    ),
                    (route) => false,
                  );*/
                  nextWeather();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.black26;
                      }
                      return const Color(0xff00A1FF).withOpacity(0.5);
                    }
                  ),
                  // foregroundColor is red for all states.
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)
                          ||  states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 10;
                    },
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Container(height: 15, color: Colors.white,),
          Container(
            height: 120.0,
            margin: const EdgeInsets.only(top: 5.0, bottom: 10,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WeatherWidget(weatherDay: todayWeather[0],),
                WeatherWidget(weatherDay: todayWeather[1],),
                WeatherWidget(weatherDay: todayWeather[2],),
                WeatherWidget(weatherDay: todayWeather[3],),
              ],
            ),
          ),
        ],
      ),
    );
  }
}