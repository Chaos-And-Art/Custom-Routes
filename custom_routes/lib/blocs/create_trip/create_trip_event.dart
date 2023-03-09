import '../../models/trip_details_model.dart';

abstract class CreateTripEvent {}

class SendNewTripDataEvent extends CreateTripEvent {
  final TripDetails data;

  SendNewTripDataEvent(this.data);
}

// class MyEventOne extends CreateTripEvent {}

// class MyEventTwo extends CreateTripEvent {}