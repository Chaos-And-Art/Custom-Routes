import 'package:custom_routes/screens/capture_location_screen.dart';
import 'package:custom_routes/screens/display_location_screen.dart';
import 'package:custom_routes/screens/location_map_screen.dart';
import 'package:flutter/material.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
//   static const String detail = '/detail';
// }

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "CaptureLocation") {
      child = const CaptureLocation();
    } else if (tabItem == "LocationMap") {
      child = const LocationMap();
    } else if (tabItem == "DisplayLocation") {
      child = const DisplayLocation();
    } else {
      child = Container();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
