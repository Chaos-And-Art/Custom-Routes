import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/tab_navigator.dart';
import 'capture_location_screen.dart';
import 'create_trip_screen.dart';
import 'display_location_screen.dart';
import 'location_map_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String _currentPage = "CaptureLocation";

  final List<String> _views = [
    "CaptureLocation",
    "LocationMap",
    "DisplayLocation"
  ];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "CaptureLocation": GlobalKey<NavigatorState>(),
    "LocationMap": GlobalKey<NavigatorState>(),
    "DisplayLocation": GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = _views[index];
        _currentIndex = index;
      });
    }
  }

/*
  Eventually we will have a login screen, so will need to move this logic to 
  the first time they create an account/login, since they will have to agree 
  to the terms and conditions
*/
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
      await [
        Permission.location
      ].request();
    }

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentState = _navigatorKeys[_currentPage]?.currentState;
        if (currentState == null) {
          // Handle case where currentState is null
          return true;
        }
        final isFirstRouteInCurrentTab = !(await currentState.maybePop());
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "CaptureLocation") {
            _selectTab("CaptureLocation", 1);

            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(widget.title),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            // elevation: 0,
          ),
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("CaptureLocation"),
            _buildOffstageNavigator("LocationMap"),
            _buildOffstageNavigator("DisplayLocation"),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTrip(),
                ),
              );
            },
            // backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blueAccent,
            onTap: (int index) {
              _selectTab(_views[index], index);
            },
            currentIndex: _currentIndex,
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
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
