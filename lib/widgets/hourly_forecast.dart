import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_codes.dart';
import 'package:weather_app/models/weather_forecast.dart';


class Hourly extends StatelessWidget {
  const Hourly({super.key,required this.forecast,required this.isday});

  final HourlyData forecast;
  final bool isday;
  @override
  Widget build(BuildContext context) {
    String daynight = 'day';
    if(!isday)
    {
        daynight = 'night';
    }
    return Container(
        height: 200,
        width: 130,
        decoration: BoxDecoration(
          border: Border.all(width: 1.2,color: Colors.grey),
          borderRadius: BorderRadius.circular(20)
        ),

        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              Text(forecast.time!.substring(11),style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17
            ),),
            Image.asset('assets/icons/${forecast.values!.weatherCode!.toInt()}_$daynight.png',height: 70),
             Text('${forecast.values!.temperature!}°/${forecast.values!.temperatureApparent}°',style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19
            ),),
             Text(weatherCode[forecast.values!.weatherCode!.toInt().toString()]!,style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),)
          ],
        ),
    );
  }
}