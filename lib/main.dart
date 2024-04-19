import 'package:flutter/material.dart';
import 'package:startup_namer/page1.dart';
import 'package:startup_namer/page2.dart';
import 'package:startup_namer/home.dart';
import 'package:get/get.dart';
//import 'package:random_color/random_color.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // Get.put(LikeController()); // controller 등록
    return GetMaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.red),
              actionsIconTheme: IconThemeData(color: Colors.amber),
              centerTitle: true,
              titleTextStyle:
                  TextStyle(fontSize: 25.0, color: Colors.lightBlueAccent))),
      home: RandomWords(),  //home.dart
      getPages: [
        GetPage(name: '/page1', page: () => Page1()),
        GetPage(name: '/page2', page: () => Page2()),
        ],
    );
  }
}
