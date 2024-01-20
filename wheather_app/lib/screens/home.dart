import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_wheather_app/constants/constants.dart';
import 'package:new_wheather_app/main.dart';
import 'package:new_wheather_app/services/wheather_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCity = 'İzmir'; // Başlangıçta seçili olan şehir
  late DateTime nowDatetime;
  late String formattedDate;
  String? city;
  String? mainWheather;
  String? wheatherStatus;
  String? wind;
  double? rainRate;
  int? cloudRate;
  bool dataChecked = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    nowDatetime = DateTime.now();
    formattedDate = DateFormat('MMM dd yyyy').format(nowDatetime);
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return dataChecked
        ? Scaffold(
            appBar: AppBar(
              title: AppBarApp(
                  selectedCity: selectedCity,
                  onCityChanged: _onCityChanged,
                  isDarkMode: isDarkMode,
                  toggleDarkMode: _toggleDarkMode,
                  city: city),
            ),
            body: AnimatedOpacity(
              opacity: dataChecked ? 1.0 : 0.0,
              duration: Duration(milliseconds: 4000),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 4000),
                padding: EdgeInsets.symmetric(horizontal: dataChecked ? 25 : 0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: (wheatherStatus?.toLowerCase() == "clear")
                            ? Image.asset(
                                'assets/images/sunny-removebg-preview.png')
                            : Image.asset(
                                'assets/images/rainy-removebg-preview.png'),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: mainWheather != null
                            ? Text('$mainWheather°C', style: textStyle(60))
                            : Text("veri"),
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: wheatherStatus != null
                              ? Text("$wheatherStatus")
                              : Text("Null")),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('$formattedDate')),
                      const Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                wind != null ? Text("% $wind") : Text('123'),
                                Text('rüzgar'),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text('12'),
                                Text('oran'),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                cloudRate != null
                                    ? Text("% $cloudRate")
                                    : Text('12'),
                                Text('bulut'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ))
        : Scaffold(
            body: Center(
                child: LoadingAnimationWidget.prograssiveDots(
                    color: Colors.blue.shade500, size: 200)),
          );
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _onCityChanged(String? newValue) {
    setState(() async {
      selectedCity = newValue;
      await WeatherService.getWeatherData(selectedCity!);
    });
  }

  Future<Map<String, double>?> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //Kullanıcı izin vermedi
        print("Kullanıcı izin vermedi");
        return {'latitude': 37.4219983, "longitude": -122.084};
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double lat = position.latitude;
      double long = position.longitude;
      getLocationName(lat, long);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      return {'latitude': lat, 'longitude': long};
    } catch (e) {
      print("Konum bilgisi alınamadı : $e");
    }
    return null;
  }

  Future<String?> getLocationName(double latitude, double longtude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longtude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String cityName = placemark.locality ?? '';
        print(cityName);
        dynamic weatherData = await WeatherService.getWeatherData(cityName);
        print(weatherData["name"]);
        setState(() {
          mainWheather =
              weatherData["main"]["temp"].toDouble().toInt().toString();
          wheatherStatus = weatherData["weather"][0]["main"];
          wind = weatherData["wind"]["speed"].toDouble().toInt().toString();
          cloudRate = weatherData["clouds"]["all"];
          city = weatherData["name"];
          dataChecked = true;
        });
        return cityName;
      } else {
        return null;
      }
    } catch (e) {
      print("Şehir adı alınamadı: $e");
      return null;
    }
  }
}

class AppBarApp extends StatelessWidget {
  final String? selectedCity;
  final void Function(String?)? onCityChanged;
  final String? city;
  final void Function() toggleDarkMode; // toggleDarkMode ekledik

  final bool isDarkMode;

  const AppBarApp({
    required this.selectedCity,
    required this.onCityChanged,
    required this.city,
    required this.isDarkMode,
    Key? key,
    required this.toggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (!isDarkMode)
              ? Container(
                  child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  child: Icon(
                    Icons.nightlight_round,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    toggleDarkMode();
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme();
                  },
                ))
              : Container(
                  child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    toggleDarkMode();
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme();
                  },
                )),
          Container(
            child: Row(
              children: [Icon(Icons.location_on), Text("$city")],
            ),
          )
        ],
      ),
    );
  }
}
