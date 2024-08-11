import 'package:flutter/material.dart';
import 'package:weather_app/models/realtime_weather.dart';
import 'package:weather_app/widgets/custom_icon.dart';

class ExtraInfo extends StatelessWidget {
  const ExtraInfo({super.key,required this.values});
  final Values values;
  @override
  Widget build(BuildContext context) {
    String uv = 'Low';

    if(values.uvIndex!>=3 && values.uvIndex!<=5)
    {
        uv = 'Moderate';
    }
    else if(values.uvIndex!>5 && values.uvIndex!<=7)
    {
        uv = 'High';
    }
    else if(values.uvIndex!>=8)
    {
          uv = 'Very High';
    }
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width*0.90,
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black),
        borderRadius: BorderRadius.circular(16)

      ),
      child: Padding(
        padding:  const EdgeInsets.only(top: 20),
        child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),children:  [
                CustomIcon(icon: const Icon(Icons.sunny,color: Colors.blue,size: 30,),lable: 'UvIndex',value: uv,),
                CustomIcon(icon: const Icon(Icons.wind_power,color: Colors.blue,size: 30,),lable: 'Wind',value: '${values.windSpeed}km/h',),
                CustomIcon(icon: const Icon(Icons.water_drop_outlined,color: Colors.blue,size: 30,),lable: 'Humidity',value: '${values.humidity.toString()}%',),
                CustomIcon(icon: const Icon(Icons.thermostat_sharp,color: Colors.blue,size: 30,),lable: 'Dew Point',value: '${values.dewPoint.toString()}°',),
                CustomIcon(icon: const Icon(Icons.close_fullscreen_sharp,color: Colors.blue,size: 30,),lable: 'Pressure',value: '${values.pressureSurfaceLevel.toString()}mb',),
                CustomIcon(icon: const Icon(Icons.visibility,color: Colors.blue,size: 30,),lable: 'Visibility',value: '${values.visibility.toString()}km',),
        ],),
      ),
    );
  }
}