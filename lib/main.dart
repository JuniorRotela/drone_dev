import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps/pages/request_permission_page.dart';
import 'package:google_maps/pages/splash_page.dart';
import 'package:google_maps/pedido/LoginScreen.dart';
import 'package:google_maps/pedido/join_screen.dart';
import 'package:google_maps/pedido/maps_screen.dart';
import 'package:http/http.dart';
import 'pages/home_page.dart';
import './widgets/realtime.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: JoinScreen(),
      //home: LoginScreen(),
      //home: JoinScreen()
      // home: SplashPage(),
      routes: {
        HomePage.routeName: (_) => HomePage(),
        RequestPermissionPage.routeName: (_) => RequestPermissionPage(),
      },
    );
  }
}
