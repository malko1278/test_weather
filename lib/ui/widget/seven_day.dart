
import 'package:flutter/material.dart';

import 'package:test_weather/models/weather.dart';
import 'package:test_weather/util/utils.dart';

class SevenDays extends StatelessWidget {
  final List<Weather> sevenDay;
  const SevenDays({required this.sevenDay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView.builder(
        itemCount: sevenDay.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 240.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getDay(sevenDay[index].day!),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(
                                sevenDay[index].image!,
                              ),
                              width: 40,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              getTemp(sevenDay[index].name!),
                              style: const TextStyle(fontSize: 20,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (sevenDay[index].max)! > 0 ? "+" + sevenDay[index].max.toString() + "\u00B0" :
                      sevenDay[index].max.toString() + "\u00B0",
                      // "+" + sevenDay[index].max.toString() + "\u00B0",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      (sevenDay[index].min)! > 0 ? "/+" + sevenDay[index].min.toString() + "\u00B0" :
                      "/" + sevenDay[index].min.toString() + "\u00B0",
                      // "/" + sevenDay[index].min.toString() + "\u00B0",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}