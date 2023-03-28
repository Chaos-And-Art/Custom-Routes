import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:custom_routes/models/trip_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/manage_trips/manage_trip_bloc.dart';
import '../blocs/manage_trips/manage_trip_state.dart';

class CurrentTrip extends StatefulWidget {
  const CurrentTrip({super.key});

  @override
  State<CurrentTrip> createState() => _CurrentTripState();
}

class _CurrentTripState extends State<CurrentTrip> {
  final _headerStyle = const TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageTripBloc, ManageTripState>(
      builder: (context, state) {
        if (state is SendNewTripDataState) {
          return Accordion(
            disableScrolling: true,
            maxOpenSections: 2,
            headerBackgroundColorOpened: Colors.black54,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
            children: [
              AccordionSection(
                isOpen: true,
                leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                headerBackgroundColor: Colors.black,
                headerBackgroundColorOpened: Colors.red,
                header: Text(state.data.name ?? "-----", style: _headerStyle),
                contentHorizontalPadding: 10,
                contentVerticalPadding: 2,
                contentBorderWidth: 1,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Trip Name:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.name ?? "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Start Date/Time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.startDateTime?.toString().isNotEmpty == true ? state.data.startDateTime.toString() : "Waiting to Start...",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Date/Time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.endDateTime?.toString().isNotEmpty == true ? state.data.endDateTime.toString() : "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Origin:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.origin ?? "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Destination:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.destination ?? "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Distance:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.distance ?? "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Expected Duration:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            state.data.expectedDuration ?? "---",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            TripDetails currentTrip = TripDetails(
                              tripID: state.data.tripID,
                              name: state.data.name,
                              startDateTime: state.data.startDateTime,
                              endDateTime: state.data.endDateTime,
                              origin: state.data.origin,
                              destination: state.data.destination,
                              distance: state.data.distance,
                              expectedDuration: state.data.expectedDuration,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTrip(tripDetails: currentTrip),
                              ),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            final myBloc = BlocProvider.of<ManageTripBloc>(context);
                            myBloc.add(CancelTripEvent("")); //WILL NEED TO PASS IN CORRECT ID
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                          child: const Text('Delete'),
                        ),
                      ],
                    )
                  ],
                ),
                // onOpenSection: () => print('onOpenSection ...'),
                // onCloseSection: () => print('onCloseSection ...'),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 0,
          );
        }
      },
    );
  }
}
