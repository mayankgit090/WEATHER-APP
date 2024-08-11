


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/realtime_weather.dart';
import 'package:weather_app/models/weather_forecast.dart';
import 'package:weather_app/screens/forecast_screen.dart';
import 'package:weather_app/widgets/extra_info.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';
import 'package:weather_app/widgets/search_dialog.dart';
import 'package:weather_app/widgets/todayweathercontainer.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  Position? _currentPosition;
  String locationname = 'Location';
  String? cityname;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw ('Location permissions are denied');
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      placemarkFromCoordinates(position.latitude, position.longitude).then((placem) {
        setState(() {
          locationname = placem[0].locality.toString();
        });
      });

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      throw ('Error getting location: $e');
    }
  }

  Future<WeatherRealTime> loaddata(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.tomorrow.io/v4/weather/realtime?location=$lat,$lon&apikey=XSgu7bbgiVea5JPrFb9upYf8KB45Js5s'),
        headers: {'accept': 'application/json'},
      );

      final body = jsonDecode(response.body);
      final output = WeatherRealTime.fromJson(body);

      return output;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<WeatherForecast> getforecast(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.tomorrow.io/v4/weather/forecast?location=$lat,$lon&timesteps=hourly&apikey=XSgu7bbgiVea5JPrFb9upYf8KB45Js5s'),
        headers: {'accept': 'application/json'},
      );

      final body = jsonDecode(response.body);

      return WeatherForecast.fromJson(body);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<WeatherRealTime> loaddataByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.tomorrow.io/v4/weather/realtime?location=$city&apikey=XSgu7bbgiVea5JPrFb9upYf8KB45Js5s'),
        headers: {'accept': 'application/json'},
      );

      final body = jsonDecode(response.body);
      final output = WeatherRealTime.fromJson(body);

      return output;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<WeatherForecast> getforecastByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.tomorrow.io/v4/weather/forecast?location=$city&timesteps=hourly&apikey=XSgu7bbgiVea5JPrFb9upYf8KB45Js5s'),
        headers: {'accept': 'application/json'},
      );

      final body = jsonDecode(response.body);
      

      return WeatherForecast.fromJson(body);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> getUsername() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc['username'];
      } else {
        throw ('No such document!');
      }
    } catch (e) {
      throw ('Error getting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now().hour;
    String toshow = 'Good Morning';
    String label = 'Have a good day!';
    bool day = true;
    if (time >= 12 && time <= 16) {
      toshow = 'Good Afternoon';
      label = 'How you are doing!';
    } else if (time >= 16 && time <= 23) {
      toshow = 'Good Evening';
      label = 'How was your day?';
    }

    if (time >= 18 || time <= 5) {
      day = false;
    }

    return FutureBuilder(
      future: getUsername(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_currentPosition == null && cityname == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' $toshow, ${snapshot.data}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 90, 83, 83), fontSize: 15),
                  )
                ],
              ),
              actions: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SearchDialog(
                          takeinput: (city) {
                            setState(() {
                              cityname = city;
                              locationname = city;
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1.5),
                        borderRadius: BorderRadius.circular(18)),
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 18,
                            color: Colors.blue,
                          ),
                          Text(
                            locationname,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: FutureBuilder(
                future: cityname == null
                    ? loaddata(_currentPosition!.latitude, _currentPosition!.longitude)
                    : loaddataByCity(cityname!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Invalid city name or error fetching data'),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data;
                  return Center(
                    child: Column(
                      children: [
                        WeatherContainer(
                          temperature: data!.data!.values!.temperature!,
                          temperatureApparent:
                              data.data!.values!.temperatureApparent!,
                          weathercode: data.data!.values!.weatherCode!.toInt(),
                          isday: day,
                        ),
                        FutureBuilder(
                            future: cityname == null
                                ? getforecast(_currentPosition!.latitude, _currentPosition!.longitude)
                                : getforecastByCity(cityname!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Invalid city name or error fetching forecast');
                              }
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Today',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      TextButton.icon(
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.blue,
                                        ),
                                        label: const Text(
                                          'Next 24 Hours',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return ForecastScreen(
                                                forecast: snapshot.data!,
                                                isday: day,
                                              );
                                            },
                                          ));
                                        },
                                        iconAlignment: IconAlignment.end,
                                      ),
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (int i = 0; i < 6; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Hourly(
                                              forecast: snapshot
                                                  .data!.timelines!.hourly![i],
                                              isday: day,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ExtraInfo(
                            values: data.data!.values!,
                          ),
                        )
                      ],
                    ),
                  );
                }),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Text(snapshot.error.toString());
      },
    );
  }
}

// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:weather_app/models/realtime_weather.dart';
// import 'package:weather_app/models/weather_forecast.dart';
// import 'package:weather_app/screens/forecast_screen.dart';
// import 'package:weather_app/widgets/extra_info.dart';
// import 'package:weather_app/widgets/hourly_forecast.dart';
// import 'package:weather_app/widgets/search_dialog.dart';
// import 'package:weather_app/widgets/todayweathercontainer.dart';
// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? username;
//   Position? _currentPosition;
//   String locationname = 'Location';
//   String ? cityname;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         throw ('Location permissions are denied');
//       }
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//       placemarkFromCoordinates(position.latitude, position.longitude).then((placem)
//       {
        
//               setState(() {
//                   locationname = placem[0].locality.toString();
                
//               });
//       });

//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       throw ('Error getting location: $e');
//     }
//   }

//   Future<WeatherRealTime> loaddata(double lat, double lon) async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.tomorrow.io/v4/weather/realtime?location=$lat,$lon&apikey=87AcUU3v406SjvPAetEoAeENwbqe3JyK'),
//         headers: {'accept': 'application/json'},
//       );

//       final body = jsonDecode(response.body);
//       final output = WeatherRealTime.fromJson(body);

//       return output;
//     } catch (e) {
//       throw (e.toString());
//     }
//   }

//   Future<WeatherForecast> getforecast(double lat, double lon) async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.tomorrow.io/v4/weather/forecast?location=$lat,$lon&timesteps=hourly&apikey=87AcUU3v406SjvPAetEoAeENwbqe3JyK'),
//         headers: {'accept': 'application/json'},
//       );

//       final body = jsonDecode(response.body);

//       return WeatherForecast.fromJson(body);
//     } catch (e) {
//       throw (e.toString());
//     }
//   }

//   Future<String> getUsername() async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();

//       if (doc.exists) {
//         return doc['username'];
//       } else {
//         throw ('No such document!');
//       }
//     } catch (e) {
//       throw ('Error getting document: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final time = DateTime.now().hour;
//     String toshow = 'Good Morning';
//     String label = 'Have a good day!';
//     bool day = true;
//     if (time >= 12 && time <= 16) {
//       toshow = 'Good Afternoon';
//       label = 'How you are doing!';
//     } else if (time >= 16 && time <= 23) {
//       toshow = 'Good Evening';
//       label = 'How was your day?';
//     }

//     if (time >= 18 || time <= 5) {
//       day = false;
//     }

//     return FutureBuilder(
//       future: getUsername(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (_currentPosition == null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return Scaffold(
//             appBar: AppBar(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     ' $toshow, ${snapshot.data}',
//                     style: const TextStyle(
//                         fontSize: 25, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     label,
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 90, 83, 83), fontSize: 15),
//                   )
//                 ],
//               ),
//               actions: [
//                 InkWell(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return  SearchDialog(takeinput: (city) {
//                                 cityname = city;
//                         },);
//                       },
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue, width: 1.5),
//                         borderRadius: BorderRadius.circular(18)),
//                     child:  Center(
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.location_pin,
//                             size: 18,
//                             color: Colors.blue,
//                           ),
//                           Text(
//                             locationname,
//                             style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             body: FutureBuilder(
//                 future: loaddata(_currentPosition!.latitude, _currentPosition!.longitude),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(snapshot.error.toString()),
//                     );
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }

//                   final data = snapshot.data;
//                   return Center(
//                     child: Column(
//                       children: [
//                         WeatherContainer(
//                           temperature: data!.data!.values!.temperature!,
//                           temperatureApparent:
//                               data.data!.values!.temperatureApparent!,
//                           weathercode: data.data!.values!.weatherCode!.toInt(),
//                           isday: day,
//                         ),
//                         FutureBuilder(
//                             future: getforecast(_currentPosition!.latitude, _currentPosition!.longitude),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               } else if (snapshot.hasError) {
//                                 return Text(snapshot.error.toString());
//                               }
//                               return Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Padding(
//                                         padding: EdgeInsets.only(left: 20),
//                                         child: Text(
//                                           'Today',
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                       TextButton.icon(
//                                         icon: const Icon(
//                                           Icons.arrow_forward,
//                                           color: Colors.blue,
//                                         ),
//                                         label: const Text(
//                                           'Next 24 Hours',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                         onPressed: () {
//                                           Navigator.push(context,
//                                               MaterialPageRoute(
//                                             builder: (context) {
//                                               return ForecastScreen(
//                                                 forecast: snapshot.data!,
//                                                 isday: day,
//                                               );
//                                             },
//                                           ));
//                                         },
//                                         iconAlignment: IconAlignment.end,
//                                       ),
//                                     ],
//                                   ),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Row(
//                                       children: [
//                                         for (int i = 0; i < 6; i++)
//                                           Padding(
//                                             padding: const EdgeInsets.all(8),
//                                             child: Hourly(
//                                               forecast: snapshot
//                                                   .data!.timelines!.hourly![i],
//                                               isday: day,
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 20),
//                           child: ExtraInfo(
//                             values: data.data!.values!,
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 }),
//           );
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return Text(snapshot.error.toString());
//       },
//     );
//   }
// }



