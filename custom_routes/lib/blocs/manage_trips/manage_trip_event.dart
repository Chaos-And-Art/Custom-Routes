import '../../models/trip_details_model.dart';

abstract class ManageTripEvent {}

class SendNewTripDataEvent extends ManageTripEvent {
  final TripDetails data;

  SendNewTripDataEvent(this.data);
}

class CancelTripEvent extends ManageTripEvent {
  final String tripId;

  CancelTripEvent(this.tripId);
}

// class MyEventTwo extends CreateTripEvent {}