import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:weather/screens/mainscreen.dart';
import '../custom/customtextstyle.dart';
import '../services/bloc/weather_bloc.dart';
import '../services/weathermodel.dart';

class WeatherDetail extends StatefulWidget {
  double latitude;
  double longitude;

  WeatherDetail(this.latitude, this.longitude, {super.key});

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  @override
  void initState() {
    // TODO: implement initState
    // hitApi();
    super.initState();
  }

  void hitApi() {
    BlocProvider.of<WeatherBloc>(context)
        .add(SearchWeatherEvent(widget.latitude, widget.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff331c71),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: const Color(0Xff5842A9),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(
                            size: 27, color: Colors.white, Icons.arrow_back),
                      ),
                    ),
                    const Text(
                      "7 Days",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color(0Xff5842A9),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(
                          size: 27, color: Colors.white, Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                  WeatherModel weather1 = WeatherModel();
                  if (state is WeatherLoadingState) {
                    return const SizedBox(
                        width: 200,
                        height: 200,
                        child: RiveAnimation.asset(
                            "assets/images/loadingriv.riv"));
                  } else if (state is WeatherLoadedState) {
                    weather1 = state.weather;
                    print(
                        " my data ${weather1.daily!.temperature2mMax![1].toInt()}");
                    print(
                        " my data ${weather1.daily!.temperature2mMin![1].toInt()}");
                    return Column(
                      children: [
                        Container(
                          height: 320,
                          width: 350,
                          decoration: BoxDecoration(
                              color: const Color(0XFF5842A9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image(
                                            height: 150,
                                            image: AssetImage(
                                                'assets/images/cloud.png')),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Tomarow",
                                            style: CustomTextStyle(
                                                    color: Colors.white)
                                                .textStyle,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Mostly Cloud",
                                            style: CustomTextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)
                                                .textStyle,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 120, top: 100),
                                    child: Text(
                                      "${weather1.daily!.temperature2mMax![1].toInt()}°",
                                      style: CustomTextStyle(
                                              color: Colors.white,
                                              fontSize: 70,
                                              fontWeight: FontWeight.bold)
                                          .textStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 200, top: 140),
                                    child: Text(
                                      " / ${weather1.daily!.temperature2mMin![1].toInt()}°",
                                      style: CustomTextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)
                                          .textStyle,
                                    ),
                                  )
                                ],
                              ),
                              Row(
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
                                            "${weather1.daily!.precipitationSum![1].toInt()}°",
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
                                        Text("${weather1.hourly!.rain![24]}°",
                                            style: CustomTextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)
                                                .textStyle),
                                        const Text(
                                          "Rain",
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
                                            "${weather1.hourly!.windspeed10m![24].toString()} km/h°",
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${weather1.daily!.time![2].toString()}     ",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/cloud.png')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Windy",
                                        style:
                                            CustomTextStyle(color: Colors.grey)
                                                .textStyle,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMax![2].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMin![2].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${weather1.daily!.time![3].toString()}     ",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/sunny.png')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Sunny",
                                        style:
                                            CustomTextStyle(color: Colors.grey)
                                                .textStyle,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMax![3].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMin![3].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${weather1.daily!.time![4].toString()}      ",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/rain.png')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Windy",
                                        style:
                                            CustomTextStyle(color: Colors.grey)
                                                .textStyle,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMax![4].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMin![4].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${weather1.daily!.time![5].toString()}      ",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/cloud.png')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Windy",
                                        style:
                                            CustomTextStyle(color: Colors.grey)
                                                .textStyle,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMax![5].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMin![5].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${weather1.daily!.time![6].toString()}       ",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/cloud.png')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Windy",
                                        style:
                                            CustomTextStyle(color: Colors.grey)
                                                .textStyle,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMax![6].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                  Text(
                                    "${weather1.daily!.temperature2mMin![6].toInt()}°",
                                    style: CustomTextStyle(color: Colors.white)
                                        .textStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
