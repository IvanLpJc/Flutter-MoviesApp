import 'package:flutter/material.dart';
import 'package:peliculas/models/backgrounds.dart';
import 'package:carousel_slider/carousel_slider.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: (() => Navigator.pushReplacementNamed(context, '/home')),
      child: CarouselSlider(
        options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeIn,
            autoPlay: true),
        items: backgrounds.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: double.infinity,
                child: Image(image: AssetImage(i['image']), fit: BoxFit.cover),
              );
            },
          );
        }).toList(),
      ),
    ));
  }
}
