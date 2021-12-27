
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:test_weather/util/utils.dart';
import 'package:test_weather/models/city.dart';
import 'package:test_weather/models/weather.dart';
import 'package:test_weather/models/slide_model.dart';
import 'package:test_weather/ui/slide/slide_item.dart';
import 'package:test_weather/ui/widget/today_weather.dart';
import 'package:test_weather/ui/slide/weather_of_day.dart';
import 'package:test_weather/ui/slide/weather_next_day.dart';
import 'package:test_weather/service/weather_api_client.dart';

import 'current_weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<WeatherPage> {
  late bool isCharged;
  City? _currentCity;
  late String _language;
  Position? _currentPosit;
  Weather? _currentTemp;
  Weather? _tomorrowTemp;
  List<Weather>? _todayWeather;
  List<Weather>? _weatherSevenDay;

  CurrentWeather? _widgetCurrentWeather;
  TodayWeather? _widgetWeatherDay;
  late int _currentPage;
  late PageController _Controller;
  late List<SlideModel> _contentSlides;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCharged = false;
    _language = 'ru';
    _currentPage = 0;
    _Controller = PageController(initialPage: 0,);
    _getWeatherCity();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  Future<void> _getWeatherCity() async {
    _currentPosit = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(_currentPosit != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosit!.latitude,
          _currentPosit!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          _currentCity = City(
            name: place.locality!,
            lat: _currentPosit!.latitude,
            lon: _currentPosit!.longitude,
          );
          _getCurrentWeather(_currentCity!);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _getCurrentWeather(City city) async {
    fetchAllWeather(city, _language).then((value) {
      _currentTemp = value[0];
      _todayWeather = value[1];
      _tomorrowTemp = value[2];
      _weatherSevenDay = value[3];
      setState(() {
        _widgetCurrentWeather = CurrentWeather(
          currentCity: _currentCity!,
          currentTemp: _currentTemp!,
          changeCity: _changeCity,
        );
        _widgetWeatherDay = TodayWeather(
          tomorrowTemp: _tomorrowTemp!,
          todayWeather: _todayWeather!,
          weatherSevenDay: _weatherSevenDay!,
          nextWeather: _nextPage,
        );
        if(_currentTemp != null) {
          _contentSlides = <SlideModel>[];
          for(var i = 0; i < 2; i++) {
            _contentSlides.add(SlideModel(widgets: getWidget(i)));
          }
          isCharged = true;
        }
      });
    });
  }

  _changeCity(String nameCity) async {
    setState(() {
      isCharged = false;
    });
    City? newCity = await fetchCity(nameCity);
    if(newCity == null) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: const Color(0xff030317),
          backgroundColor: Colors.grey.shade400,
          title: const Text("Город не найден"),   // 'City not found'
          content: const Text("Пожалуйста, проверьте название города"),   // Please check the city name
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
        initState();
      });
      setState(() {
        isCharged = true;
      });
      initState();
    } else {
      setState(() {
        _currentCity = newCity;
        _getCurrentWeather(_currentCity!);
      });
    }
  }

  incrementPage() {
    setState(() {
      _currentPage++;
    });
  }

  decrementPage() {
    setState(() {
      _currentPage--;
    });
  }

  _nextPage() {
    setState(() {
      if(_currentPage == 0) {
        incrementPage();
        _Controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeIn,
        );
      }
    });
  }

  _previousPage() {
    setState(() {
      if(_currentPage == 1) {
        decrementPage();
        _Controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Widget getWidget(int index) {
    if(index == 0) {
      return WeatherOfDay(
        currentWeather: _widgetCurrentWeather!,
        weatherDay: _widgetWeatherDay!,
      );
    } else {
      if(index == 1) {
        return WeatherNextDay(
          tomorrowTemp: _tomorrowTemp!,
          sevenDay: _weatherSevenDay!,
          previousWeather: _previousPage,
        );
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    return isCharged == false
    ? const Center(
      child: CircularProgressIndicator(),
    ) : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(getBackground(_currentTemp!.name!)),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: _Controller,
          itemCount: _contentSlides.length,
          itemBuilder: (ctx, i) => SlideItem(
            index: i,
            listSlides: _contentSlides,
          ),
        )
      ),
    );
  }
}