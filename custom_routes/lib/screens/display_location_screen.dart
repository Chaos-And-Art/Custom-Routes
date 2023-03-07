import 'package:custom_routes/widgets/current_trip.dart';
import 'package:flutter/material.dart';

class DisplayLocation extends StatefulWidget {
  const DisplayLocation({super.key});

  @override
  State<DisplayLocation> createState() => _DisplayLocationState();
}

class _DisplayLocationState extends State<DisplayLocation> {
  @override
  Widget build(BuildContext context) {
    return const CurrentTrip();
  }
}
