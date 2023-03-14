import '../../models/trip_details_model.dart';

abstract class ManageTripState {}

class MyInitialState extends ManageTripState {}

class SendNewTripDataState extends ManageTripState {
  final TripDetails data;

  SendNewTripDataState({required this.data});

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendNewTripDataState && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

class CancelTripState extends ManageTripState {
  final String tripId;

  CancelTripState({required this.tripId});

  @override
  bool operator ==(Object other) => identical(this, other) || other is CancelTripState && runtimeType == other.runtimeType && tripId == other.tripId;

  @override
  int get hashCode => tripId.hashCode;
}

// class MyStateTwo extends MyState {}