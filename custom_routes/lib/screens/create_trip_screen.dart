import 'package:custom_routes/models/trip_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../blocs/create_trip/create_trip_bloc.dart';
import '../blocs/create_trip/create_trip_event.dart';
import '../models/location_place.dart';
import '../models/location_suggestion.dart';
import '../services/search_location_service.dart';
import '../widgets/search_location.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final _tripNameController = TextEditingController();
  final _startingPointController = TextEditingController();
  final _destinationController = TextEditingController();

  TripDetails tripDetails = TripDetails();
  late LocationPlace startingLocation;
  final sessionToken = const Uuid().v4();
  String estimatedArrival = "";
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _getStartingPointLocation();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tripNameController.dispose();
    _startingPointController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  _getStartingPointLocation() async {
    SearchLocationService searchLocationService = SearchLocationService(sessionToken: sessionToken);
    final suggestedStartingLocation = await searchLocationService.fetchSuggestionsOnPosition();
    startingLocation = await searchLocationService.getPlaceDetailFromId(suggestedStartingLocation.placeId);
    tripDetails.origin = "${startingLocation.streetNumber ?? ''} ${startingLocation.street ?? ''}, ${startingLocation.city ?? ''}, ${startingLocation.state ?? ''}";
    if (!_isDisposed) {
      _startingPointController.text = tripDetails.origin!;
    }
  }

  void _createNewTrip() {
    final myBloc = BlocProvider.of<CreateTripBloc>(context);
    myBloc.add(SendNewTripDataEvent(tripDetails));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(""),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueGrey[100],
                        ),
                        child: const Center(
                          child: Text(
                            "Enter Trip Information",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Trip:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _tripNameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  onTap: () async {},
                  decoration: const InputDecoration(
                    hintText: "Enter name of Trip",
                    contentPadding: EdgeInsets.only(left: 8.0),
                  ),
                  onChanged: (value) {
                    tripDetails.name = value;
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Starting Point:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _startingPointController,
                  readOnly: true,
                  onTap: () async {
                    final LocationSuggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken, _startingPointController.text),
                    );
                    if (result != null) {
                      tripDetails.origin = result.description;
                      final tempDetails = await SearchLocationService(sessionToken: sessionToken).getTravelTime(tripDetails.origin, tripDetails.destination);
                      if (tempDetails.distance != null && tempDetails.expectedDuration != null) {
                        tripDetails.distance = tempDetails.distance;
                        tripDetails.expectedDuration = tempDetails.expectedDuration;
                      }
                      setState(() {
                        _startingPointController.text = result.description;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your Starting Point",
                    contentPadding: EdgeInsets.only(left: 8.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Destination:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _destinationController,
                  readOnly: true,
                  onTap: () async {
                    final LocationSuggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken, _destinationController.text),
                    );
                    if (result != null) {
                      tripDetails.destination = result.description;
                      final tempDetails = await SearchLocationService(sessionToken: sessionToken).getTravelTime(tripDetails.origin, tripDetails.destination);
                      if (tempDetails.distance != null && tempDetails.expectedDuration != null) {
                        tripDetails.distance = tempDetails.distance;
                        tripDetails.expectedDuration = tempDetails.expectedDuration;
                      }
                      setState(() {
                        _destinationController.text = result.description;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your Destination",
                    contentPadding: EdgeInsets.only(left: 8.0),
                  ),
                ),
                const SizedBox(height: 35.0),
                const Text(
                  "Distance:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: tripDetails.distance?.isNotEmpty == true ? Text(tripDetails.distance!, style: Theme.of(context).inputDecorationTheme.labelStyle) : const Text("Waiting to calculate...", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Estimated Duration:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: tripDetails.expectedDuration?.isNotEmpty == true ? Text(tripDetails.expectedDuration!, style: Theme.of(context).inputDecorationTheme.labelStyle) : const Text("Waiting to calculate...", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _createNewTrip(),
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.grey),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text(
                        'Create New Trip!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
