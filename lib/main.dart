import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pedido/join_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps/pages/request_permission_page.dart';
import 'package:google_maps/pages/splash_page.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: SplashPage(),
      //home: JoinScreen()
      // home: SplashPage(),
      routes: {
        HomePage.routeName: (_) => HomePage(),
        RequestPermissionPage.routeName: (_) => RequestPermissionPage(),
      },
    );
  }
}
