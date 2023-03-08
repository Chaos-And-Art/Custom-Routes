import 'package:custom_routes/models/trip_details_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/location_place.dart';
import '../models/location_suggestion.dart';
import '../services/search_location_service.dart';
import '../widgets/search_location.dart';
import 'capture_location_screen.dart';

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
    tripDetails.startingPoint = "${startingLocation.streetNumber ?? ''} ${startingLocation.street ?? ''}, ${startingLocation.city ?? ''}, ${startingLocation.state ?? ''}";
    if (!_isDisposed) {
      _startingPointController.text = tripDetails.startingPoint!;
    }
  }

//May be able to remove these handles
  void _handleTextFieldTapped(TextEditingController controller) {
    FocusScope.of(context).requestFocus(FocusNode());
    controller.clear();
  }

  void _handleEditingComplete(TextEditingController controller) {
    FocusScope.of(context).unfocus();
  }

  void _createNewTrip(TripDetails trip) {
    Navigator.pop(context, {
      'tripDetails': tripDetails
    });
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   '/home_page',
    //   (route) => false, // remove all routes on the stack
    //   arguments: trip, // pass data to the new route
    // );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CaptureLocation(
    //       tripDetails: tripDetails,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                GestureDetector(
                  onTap: () => _handleTextFieldTapped(_tripNameController),
                  child: TextField(
                    controller: _tripNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter name of Trip",
                      contentPadding: EdgeInsets.only(left: 8.0),
                    ),
                    onEditingComplete: () => _handleEditingComplete(_tripNameController),
                  ),
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
                    // generate a new token here
                    // final sessionToken = const Uuid().v4();
                    final LocationSuggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken),
                    );
                    // This will change the text displayed in the TextField
                    if (result != null) {
                      tripDetails.startingPoint = result.description;
                      final tempDetails = await SearchLocationService(sessionToken: sessionToken).getTravelTime(tripDetails.startingPoint, tripDetails.destination);
                      if (tempDetails.distance != null && tempDetails.duration != null) {
                        tripDetails.distance = tempDetails.distance;
                        tripDetails.duration = tempDetails.duration;
                      }
                      setState(() {
                        _startingPointController.text = result.description;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your Starting Point",
                    // border: InputBorder.none,
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
                      delegate: AddressSearch(sessionToken),
                    );
                    // This will change the text displayed in the TextField
                    if (result != null) {
                      tripDetails.destination = result.description;
                      final tempDetails = await SearchLocationService(sessionToken: sessionToken).getTravelTime(tripDetails.startingPoint, tripDetails.destination);
                      if (tempDetails.distance != null && tempDetails.duration != null) {
                        tripDetails.distance = tempDetails.distance;
                        tripDetails.duration = tempDetails.duration;
                      }
                      setState(() {
                        _destinationController.text = result.description;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your Destination",
                    // border: InputBorder.none,
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
                  child: tripDetails.duration?.isNotEmpty == true ? Text(tripDetails.duration!, style: Theme.of(context).inputDecorationTheme.labelStyle) : const Text("Waiting to calculate...", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _createNewTrip(tripDetails),
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 1, color: Colors.grey), //border width and color
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Text(
                          'Create New Trip!',
                          style: TextStyle(fontSize: 20),
                        ),
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
