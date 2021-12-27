
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:test_weather/models/city.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:test_weather/models/weather.dart';
import 'package:test_weather/util/utils.dart';

import 'extra_weather.dart';

class CurrentWeather extends StatefulWidget {
  final City currentCity;
  final Weather currentTemp;
  final Function(String) changeCity;
  const CurrentWeather({
    required this.currentCity,
    required this.currentTemp,
    required this.changeCity,
    Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState(
    currentCity, currentTemp, changeCity
  );
}

class InitState extends State<CurrentWeather> {
  City _currentCity;
  Weather _currentTemp;
  Function(String) _onChangeCity;


  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  InitState(
    this._currentCity, this._currentTemp, this._onChangeCity
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentCity = widget.currentCity;
    _currentTemp = widget.currentTemp;
    _onChangeCity = widget.changeCity;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if(searchBar) {
          setState(() {
            searchBar = false;
          });
        }
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 198,    // 190
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
        glowColor: const Color(0xff00A1FF).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        spreadRadius: 5,
        child: Column(
          children: <Widget>[
            Container(
              child: searchBar? TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // fillColor: const Color(0xff030317),
                  fillColor: Colors.grey.shade400,
                  filled: true,
                  hintText: "Введите название города",    // Enter a city Name
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async {
                  setState(() {
                    updating = true;
                    print('La chaine introduite est :: $value');
                    _onChangeCity(value);
                  });
                },
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.map_fill,
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          searchBar = true;
                          setState(() {});
                          focusNode.requestFocus();
                        },
                        child: Text(
                          _currentCity.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.white),
                borderRadius: BorderRadius.circular(30),),
              child: Text(
                updating? "Обновление": "Обновлено",  // "Готовое обновление":"выполнено обновление", "Updating" : "Updated",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 400.0,
              child: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage(_currentTemp.image!),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          GlowText(
                            _currentTemp.current.toString(),
                            style: const TextStyle(
                              height: 0.1,
                              fontSize: 150,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getTemp(_currentTemp.name!),
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            getRussianDate(_currentTemp.day!),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white,),
            const SizedBox(height: 6,),
            ExtraWeather(_currentTemp),
          ],
        ),
      ),
    );
  }
}