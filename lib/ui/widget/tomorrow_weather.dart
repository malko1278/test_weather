
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

import 'package:test_weather/util/utils.dart';
import 'package:test_weather/models/weather.dart';
import 'package:test_weather/ui/extra_weather.dart';

class TomorrowWeather extends StatelessWidget {
  final Weather tomorrowTemp;
  final Function() previousWeather;

  const TomorrowWeather({
    required this.tomorrowTemp,
    required this.previousWeather,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GlowContainer(
      // color: const Color(0xff00A1FF),
      glowColor: const Color(0xff00A1FF).withOpacity(0.5),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    previousWeather();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: const <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text(
                      ' 7 дней',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.transparent,    // Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 15.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(tomorrowTemp.image!),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "Завтра",
                      style: TextStyle(
                        fontSize: 30,
                        height: 0.1,
                      ),
                    ),
                    Container(
                      height: 105,
                      margin: const EdgeInsets.only(bottom: 10.0,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          GlowText(
                            tomorrowTemp.max.toString(),
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "/" + tomorrowTemp.min.toString() + "\u00B0",
                            style: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      getTemp(tomorrowTemp.name!),   // 'Дождь',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 40, left: 40,),
            child: Column(
              children: [
                const Divider(color: Colors.white),
                const SizedBox(height: 10,),
                ExtraWeather(tomorrowTemp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}