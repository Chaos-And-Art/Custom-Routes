import 'package:custom_routes/blocs/manage_trips/manage_trip_event.dart';
import 'package:custom_routes/widgets/current_trip.dart';
import 'package:custom_routes/widgets/location_table.dart';
import 'package:custom_routes/models/location_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../blocs/manage_trips/manage_trip_bloc.dart';
import '../blocs/manage_trips/manage_trip_state.dart';
import '../services/timer_service.dart';
import '../widgets/countdown_timer.dart';

final List<LocationEntry> _entries = [];

class CaptureLocation extends StatefulWidget {
  const CaptureLocation({super.key});

  @override
  State<CaptureLocation> createState() => _CaptureLocationState();
}

class _CaptureLocationState extends State<CaptureLocation> {
  bool _tripStarted = false;

  Future<void> _captureCurrentLocation() async {
    _tripStarted = true;
    try {
      final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      final newEntry = LocationEntry(key: null, dateTime: DateTime.now(), latitude: position.latitude, longitude: position.longitude, isSelected: false);
      setState(() {
        _entries.add(newEntry);
      });
    } catch (e) {
      // print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageTripBloc, ManageTripState>(
      builder: (context, state) {
        if (state is SendNewTripDataState) {
          //NEED TO INSERT POPUP HERE STATING IF YOU CREATE A NEW TRIP THE CURRENT TRIP WILL BE CANCELED
          return Scaffold(
            body: ListView(
              children: [
                TimerScreen(onRequestLocation: _captureCurrentLocation),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _captureCurrentLocation,
                      child: const Text('Add Location'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Extra Button'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final myBloc = BlocProvider.of<ManageTripBloc>(context);
                        myBloc.add(CancelTripEvent("")); //WILL NEED TO PASS IN CORRECT ID
                        final timerService = Provider.of<TimerService>(context, listen: false);
                        timerService.resetTimer();
                        TimerScreen.displayResetButton.value = false;
                        _entries.clear();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                      child: const Text('Cancel Trip'),
                    ),
                  ],
                ),
                const CurrentTrip(),
                _entries.isNotEmpty ? LocationTable(entries: _entries) : const SizedBox(),
                const SizedBox(
                  height: 75,
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 0);
        }
      },
    );
  }
}
