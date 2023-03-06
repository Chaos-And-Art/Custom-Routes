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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const CaptureLocation(),
    const LocationMap(),
    const DisplayLocation(),
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      // Has Permission Already
    } else {
      //Does not have permission
    }

    final permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      // _captureCurrentLocation();
    } else {
      await [Permission.location].request();
    }

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          // elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_views[_currentIndex]],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'First View',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Second View',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Third View',
            ),
          ],
        ),
      ),
    );
  }
}
