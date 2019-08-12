import 'package:cloud_music/home_page.dart';
import 'package:cloud_music/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.red,
      ),
      home: MainPage(),
      // onGenerateRoute: generateRoute,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (context) => HomePage());
    // case "hero_detail":
    //   return MaterialPageRoute(builder: (context) => HeroDetail(data: settings.arguments,));
    // case "settings":
    //   return MaterialPageRoute(builder: (context) => Settings());
    // default:
    //   assert(false);
    //   return MaterialPageRoute(builder: (context) => HomeView());
  }
}



















