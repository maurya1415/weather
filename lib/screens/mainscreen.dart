import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:weather/screens/weatherdetail.dart';
import 'package:weather/services/my_exception.dart';

import '../custom/customtextstyle.dart';
import '../custom/mydrawer.dart';
import '../services/bloc/weather_bloc.dart';
import '../services/weather_repository.dart';
import '../services/weathermodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String searchValue = "Agra";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();
  late WeatherModel weather;
  bool cityCheckboxValue = false;
  late List<List<double>> coordinates;

  double latitude = 0.0;
  double longitude = 0.0;
  var latitudeLongitudeError = "";
  @override
  void initState() {
    someFunction(searchValue);
    super.initState();
  }

  void someFunction(String address) async {
    var sharedData = await WeatherRepository().getData('mysearchvalue');

    if (sharedData.isEmpty) {
      await WeatherRepository().saveData('mysearchvalue', 'Agra');
      searchValue = 'Agra';
    } else {
      searchValue = await WeatherRepository().getData('mysearchvalue');
      setState(() {});
    }

    try {
      coordinates =
          await WeatherRepository().convertAddressToCoordinates(searchValue);
      if (coordinates.isNotEmpty) {
        latitude = coordinates[0][0].toDouble();
        longitude = coordinates[0][1].toDouble();

        print('Latitude: $latitude');
        print('Longitude: $longitude');

        hitApi(latitude, longitude);
      } else {
        print('Coordinates not available');
        hitApi(90, 180);
      }
    } catch (e) {
      if (e is MyException) {
        latitudeLongitudeError = e.toString();
      } else {
        latitudeLongitudeError = "error";
      }
      setState(() {});
    }
  }

  void hitApi(double latitude, double longitude) {
    BlocProvider.of<WeatherBloc>(context)
        .add(SearchWeatherEvent(latitude, longitude));
  }

  Future<void> showAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search'),
          content: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Enter your city',
                ),
              ),
              // Row(
              //   children: [
              //     Checkbox(
              //       value: cityCheckboxValue,
              //       onChanged: (value) {
              //         cityCheckboxValue = value!;
              //         setState(() {});
              //       },
              //     ),
              //     Text("Set City")
              //   ],
              // )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                // You can use the 'searchValue' for further processing

                Navigator.of(context).pop();

                if (searchController.text.isNotEmpty) {
                  setState(() {
                    // Update the state here
                    searchValue = searchController.text.toString();
                  });

                  await WeatherRepository()
                      .saveData('mysearchvalue', searchValue);
                  someFunction(searchValue);
                  // ignore: avoid_print
                  print('Search query: $searchValue');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const MyDrawer(),
      backgroundColor: const Color(0xff5842A9),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 18, top: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xff331C71),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(
                              size: 27,
                              color: Colors.white,
                              Icons.menu_outlined),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showAlert(context);
                        },
                        child: Text(
                          searchValue,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          someFunction(searchValue);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xff331C71),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(
                              size: 27,
                              color: Colors.white,
                              Icons.refresh_sharp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherLoadingState) {
                        return const SizedBox(
                            width: 200,
                            height: 200,
                            child: RiveAnimation.asset(
                                "assets/images/loadingriv.riv"));
                      } else if (state is WeatherLoadedState) {
                        weather = state.weather;
                        print(
                            "${weather.currentWeather!.temperature!.toInt()}");
                        return Column(
                          children: [
                            Text("mostly Sunny",
                                style: CustomTextStyle(color: Colors.white)
                                    .textStyle),
                            Stack(
                              children: [
                                Text(
                                    "${weather.currentWeather!.temperature!.toInt()}°",
                                    style: CustomTextStyle(
                                            color: Colors.white,
                                            fontSize: 150,
                                            fontWeight: FontWeight.bold)
                                        .textStyle),
                                Opacity(
                                    opacity: 0.9,
                                    child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 60, top: 80),
                                        child: SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: RiveAnimation.asset(
                                                "assets/images/cloud.riv"))
                                        // Image(
                                        //     height: 120,
                                        //     image: AssetImage("assets/images/cloud.png")),
                                        ))
                              ],
                            ),
                            // Replace the "T" with a space
                            Text(
                                weather.currentWeather!.time
                                    .toString()
                                    .replaceFirst("T", " "),
                                style: CustomTextStyle(
                                  color: Colors.white,
                                ).textStyle),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 100,
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xff331C71)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 12, left: 8),
                                    child: Column(
                                      children: [
                                        const Image(
                                            height: 30,
                                            image: AssetImage(
                                                'assets/images/umbrella.jpg')),
                                        Text(
                                            "${weather.hourly!.precipitation![0]}°",
                                            style: CustomTextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)
                                                .textStyle),
                                        const Text(
                                          "Precipition°",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 12, left: 8),
                                    child: Column(
                                      children: [
                                        const Image(
                                            height: 30,
                                            image: AssetImage(
                                                'assets/images/waterdrop.jpg')),
                                        Text("20°",
                                            style: CustomTextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)
                                                .textStyle),
                                        const Text(
                                          "Humidity",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, right: 8),
                                    child: Column(
                                      children: [
                                        const Image(
                                            height: 30,
                                            image: AssetImage(
                                                'assets/images/winds.jpg')),
                                        Text(
                                            "${weather.currentWeather!.windspeed!.toDouble()}km/h",
                                            style: CustomTextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)
                                                .textStyle),
                                        const Text(
                                          "Wind Speed",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Today",
                                    style: CustomTextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)
                                        .textStyle),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WeatherDetail(
                                              latitude, longitude),
                                        ));
                                  },
                                  child: Text("7-Day Forecasts >",
                                      style: CustomTextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)
                                          .textStyle),
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text("10 AM",
                                                style: CustomTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .textStyle),
                                          ),
                                          const Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/cloud.png')),
                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![10].toInt()}",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text("01 PM",
                                                style: CustomTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .textStyle),
                                          ),
                                          const SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: RiveAnimation.asset(
                                                  "assets/images/sunny.riv")),

                                          // Image(
                                          //     height: 30,
                                          //     image:
                                          //         AssetImage('assets/images/sunny.png')),

                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![13].toInt()}°",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              "06 PM",
                                              style: CustomTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  .textStyle,
                                            ),
                                          ),
                                          const Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/rain.png')),
                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![18].toInt()}°",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text("07 PM",
                                                style: CustomTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .textStyle),
                                          ),
                                          const Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/cloud.png')),
                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![19].toInt()}°",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text("09 PM",
                                                style: CustomTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .textStyle),
                                          ),
                                          const Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/cloud.png')),
                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![21].toInt()}°",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    height: 120,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff331C71),
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text("11 PM",
                                                style: CustomTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .textStyle),
                                          ),
                                          const Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/cloud.png')),
                                          Center(
                                            child: Text(
                                                "${weather.hourly!.temperature2m![23].toInt()}°",
                                                style: CustomTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ).textStyle),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is WeatherErrorState) {
                        var msg = state.errormsg;
                        return Text(
                          "$msg",
                          style: CustomTextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)
                              .textStyle,
                        );
                      } else {
                        return Container(
                          child: Text("$latitudeLongitudeError"),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
