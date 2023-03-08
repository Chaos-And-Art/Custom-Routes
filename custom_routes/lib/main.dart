import 'package:custom_routes/models/trip_details_model.dart';
import 'package:custom_routes/screens/create_trip_screen.dart';
import 'package:custom_routes/screens/my_home_page_screen.dart';
import 'package:custom_routes/services/timer_service.dart';
import 'package:custom_routes/screens/capture_location_screen.dart';
import 'package:custom_routes/screens/display_location_screen.dart';
import 'package:custom_routes/screens/location_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Routes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Custom Routes'),
      routes: {
        '/capture_location': (context) => const CaptureLocation(),
      },
      initialRoute: "/",
    );
  }
}
