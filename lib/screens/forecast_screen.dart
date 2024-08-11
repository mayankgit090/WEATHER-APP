import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_forecast.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key,required this.forecast,required this.isday});
  final WeatherForecast forecast;
  final bool isday;
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('24 Hour Forecast',style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
      body: GridView.builder(
        itemCount: 24,
        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio:0.8,mainAxisSpacing: 0.5,crossAxisSpacing: 0.5 ), itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hourly(forecast: forecast.timelines!.hourly![index],isday: isday,),
                );
      },),
    );
  }
}