import '../../models/trip_details_model.dart';

abstract class CreateTripState {}

class MyInitialState extends CreateTripState {}

class SendNewTripDataState extends CreateTripState {
  final TripDetails data;

  SendNewTripDataState({required this.data});

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendNewTripDataState && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}


// class MyStateOne extends MyState {}

// class MyStateTwo extends MyState {}