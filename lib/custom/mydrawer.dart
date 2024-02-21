import 'package:flutter/material.dart';
import 'package:weather/custom/customtextstyle.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff5842A9),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Developed By',
                      style: CustomTextStyle(color: Colors.white, fontSize: 20)
                          .textStyle),
                  Text('Ajay kumar',
                      style: CustomTextStyle(
                              color: Colors.amberAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)
                          .textStyle),
                ],
              ),
            ),
          ),

          // Add more list tiles for additional options
        ],
      ),
    );
  }
}
