import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/trip_details_model.dart';
import 'create_trip_event.dart';
import 'create_trip_state.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {
  CreateTripBloc() : super(MyInitialState()) {
    on<SendNewTripDataEvent>((event, emit) {
      emit(SendNewTripDataState(data: event.data));
    });

    // on<MyEventOne>((event, emit) {
    //   emit(MyStateOne());
    // });

    // on<MyEventTwo>((event, emit) {
    //   emit(MyStateTwo());
    // });
  }

  final _myStreamController = StreamController<SendNewTripDataState>();
  Stream<SendNewTripDataState> get myStream => _myStreamController.stream;

  void triggerDataEvent(TripDetails data) => add(SendNewTripDataEvent(data));

  // void triggerEventOne() => add(MyEventOne());
  // void triggerEventTwo() => add(MyEventTwo());
}
