class LocationSuggestion {
  final String placeId;
  final String description;

  LocationSuggestion(this.placeId, this.description);

  static LocationSuggestion empty() {
    return LocationSuggestion('', '');
  }

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
