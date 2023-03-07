import 'package:accordion/accordion.dart';
import 'package:custom_routes/widgets/current_trip.dart';
import 'package:custom_routes/widgets/location_table.dart';
import 'package:custom_routes/models/location_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/countdown_timer.dart';

final List<LocationEntry> _entries = [];

class CaptureLocation extends StatefulWidget {
  const CaptureLocation({super.key});

  @override
  State<CaptureLocation> createState() => _CaptureLocationState();
}

class _CaptureLocationState extends State<CaptureLocation> {
  Future<void> _captureCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      final newEntry = LocationEntry(
        dateTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setState(() {
        _entries.add(newEntry);
      });
    } catch (e) {
      // print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: ListView(
          children: [
            TimerScreen(onRequestLocation: _captureCurrentLocation),
            ElevatedButton(
              onPressed: _captureCurrentLocation,
              child: const Text('Get Location'),
            ),
            const SizedBox(height: 20.0),
            const CurrentTrip(),
            const SizedBox(height: 20.0),
            LocationTable(entries: _entries),
          ],
        ),
      ),
    );
  }
}
