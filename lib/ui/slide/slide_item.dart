

import 'package:flutter/material.dart';
import 'package:test_weather/models/slide_model.dart';

class SlideItem extends StatelessWidget {
  final int index;
  final List<SlideModel> listSlides;
  const SlideItem({
    required this.index,
    required this.listSlides,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listSlides.elementAt(index).widgets;
  }
}