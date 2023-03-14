class TripDetails {
  int? tripID;
  String? name;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? origin;
  String? destination;
  String? distance;
  String? expectedDuration;

  TripDetails({this.tripID, this.name, this.startDateTime, this.endDateTime, this.origin, this.destination, this.distance, this.expectedDuration});
}
