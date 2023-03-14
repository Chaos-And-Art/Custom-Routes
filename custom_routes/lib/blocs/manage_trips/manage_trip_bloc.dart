import 'dart:async';
import 'package:custom_routes/blocs/manage_trips/manage_trip_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/trip_details_model.dart';
import 'manage_trip_event.dart';

class ManageTripBloc extends Bloc<ManageTripEvent, ManageTripState> {
  ManageTripBloc() : super(MyInitialState()) {
    on<SendNewTripDataEvent>((event, emit) {
      emit(SendNewTripDataState(data: event.data));
    });

    on<CancelTripEvent>((event, emit) {
      // Perform cancellation/deletion of the trip with the given tripId

      emit(CancelTripState(tripId: event.tripId));
    });
  }

  final _myStreamController = StreamController<SendNewTripDataState>();
  Stream<SendNewTripDataState> get myStream => _myStreamController.stream;

  void triggerDataEvent(TripDetails data) => add(SendNewTripDataEvent(data));

  void triggerCancelTripEvent(String tripId) => add(CancelTripEvent(tripId));
}

class CreateTripState {}
