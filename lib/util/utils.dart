
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:test_weather/models/city.dart';

String findIcon(String name, bool type) {
  if(type) {
    switch(name) {
      case "Clouds":  return "assets/icones/sunny.png";
      case "Rain":  return "assets/icones/rainy.png";
      case "Drizzle":  return "assets/icones/rainy.png";
      case "Thunderstorm":  return "assets/icones/thunder.png";
      case "Snow":  return "assets/icones/snow.png";
      default:  return "assets/icones/sunny.png";
    }
  } else {
    switch(name) {
      case "Clouds":  return "assets/icones/sunny_2d.png";
      case "Rain":  return "assets/icones/rainy_2d.png";
      case "Drizzle":  return "assets/icones/rainy_2d.png";
      case "Thunderstorm":  return "assets/icones/thunder_2d.png";
      case "Snow":  return "assets/icones/snow_2d.png";
      default:  return "assets/icones/sunny_2d.png";
    }
  }
}

var cityJSON;

Future<City?> fetchCity(String cityName) async {
  if(cityJSON == null) {
    String link = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if(response.statusCode == 200){
      cityJSON = json.decode(response.body);
    }
  }
  for(var i = 0; i < cityJSON.length; i++) {
    if(cityJSON[i]["name"].toString().toLowerCase() == cityName.toLowerCase()) {
      return City(
        name:cityJSON[i]["name"].toString(),
        lat: double.parse(cityJSON[i]["latitude"]),
        lon: double.parse(cityJSON[i]["longitude"]),
      );
    }
  }
  return null;
}

String getTemp(String valeur) {
  String temperature = '';
  switch(valeur) {
    case 'Clouds':   temperature = 'Облачно';   break;
    case 'Snow':   temperature = 'Снег';   break;
    case 'Clear':   temperature = 'Солнечно';   break;
    case 'Rain':   temperature = 'Дождь';   break;
    // case 'Rain':   temperature = 'Сильный дождь';   break;
  }
  return temperature;
}

String getBackground(String valeur) {
  String imgBckgrd = '';
  switch(valeur) {
    case "Clouds":   imgBckgrd = 'assets/images/heavycloud.png';   break;
    case "Rain":   imgBckgrd = 'assets/images/heavyrain.png';   break;
    case "Clear":  imgBckgrd = 'assets/images/clear.png';   break;
  // case "Thunderstorm":  imgBckgrd = 'assets/images/clear.png';   break;
    case "Snow":  imgBckgrd = 'assets/images/snow.png';   break;
  }
  return imgBckgrd;
}

String getDay(String valeur) {
  late String day = '';
  switch(valeur) {
    case 'Thu':   day = 'Чт';   break;
    case 'Fri':   day = 'Пт';   break;
    case 'Sat':   day = 'Сб';   break;
    case 'Sun':   day = 'Вс';   break;
    case 'Mon':   day = 'Пн';   break;
    case 'Tue':   day = 'Вт';   break;
    case 'Wed':   day = 'Ср';   break;
  }
  return day;
}

String getRussianDate(String valeur) {
  late String date = '';
  late String week = '';
  late String day = '';
  late String month = '';
  // Tuesday 26 October == Вторник, 26 октября
  int i = 0, k = 0;
  do{
    if(k == 0) {
      if(valeur[i] != ' ') {
        week += valeur[i];
      } else {
        k++;
      }
    } else {
      if(k == 1) {
        if(valeur[i] != ' ') {
          day += valeur[i];
        } else {
          k++;
        }
      } else {
        if(valeur[i] != ' ') {
          month += valeur[i];
        }
      }
    }
    i++;
  }while(i < valeur.length);

  switch(week) {
    case 'Monday':   week = 'Понедельник,';   break;
    case 'Tuesday':   week = 'Вторник,';   break;
    case 'Wednesday':   week = 'Среда,';   break;
    case 'Thursday':   week = 'Четверг,';   break;
    case 'Friday':   week = 'Пятница,';   break;
    case 'Saturday':   week = 'Суббота,';   break;
    case 'Sunday':   week = 'Воскресенье,';   break;
  }
  switch(month) {
    case 'January':   month = 'Января';   break;
    case 'February':   month = 'Февраля';   break;
    case 'March':   month = 'Марта';   break;
    case 'April':   month = 'Апреля';   break;
    case 'May':   month = 'Мая';   break;
    case 'June':   month = 'Июня';   break;
    case 'July':   month = 'Июля';   break;
    case 'August':   month = 'Августа';   break;
    case 'September':   month = 'Сентября';   break;
    case 'October':   month = 'Октября';   break;
    case 'November':   month = 'Ноября';   break;
    case 'December':   month = 'Декабря';   break;
  }

  return week + ' ' + day + ' ' + month;
}