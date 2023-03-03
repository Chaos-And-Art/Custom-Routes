import 'package:flutter/material.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Second View'),
    );
  }
}
