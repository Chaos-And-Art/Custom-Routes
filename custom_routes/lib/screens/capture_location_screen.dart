import 'package:custom_routes/widgets/location_table.dart';
import 'package:custom_routes/models/location_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/countdown_timer.dart';

class CaptureLocation extends StatefulWidget {
  const CaptureLocation({super.key});

  @override
  State<CaptureLocation> createState() => _CaptureLocationState();
}

class _CaptureLocationState extends State<CaptureLocation> {
  String _locationData = 'No location data';
  final List<LocationEntry> _entries = [];

  Future<void> _getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final newEntry = LocationEntry(
        dateTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setState(() {
        _locationData =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        _entries.add(newEntry);
      });
    } catch (e) {
      // print('Error getting location: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      // Has Permission Already
    } else {
      //Does not have permission
    }

    final permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      _getLocation();
    } else {
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
    }

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final timerService = Provider.of<TimerService>(context, listen: false);

    // timerService.startTimer(timerFinished: () {
    //   _requestLocationPermission();
    // });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimerScreen(onRequestLocation: _requestLocationPermission),
        ElevatedButton(
          onPressed: _requestLocationPermission,
          child: const Text('Get Location'),
        ),
        const SizedBox(height: 20.0),
        Text(_locationData),
        SizedBox(
          height: 250,
          child: ListView(
            children: [LocationTable(entries: _entries)],
          ),
        ),
      ],
    );
  }
}
