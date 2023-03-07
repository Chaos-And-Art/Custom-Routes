class LocationPlace {
  String? streetNumber;
  String? street;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  LocationPlace({
    this.streetNumber,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, city: $state, city: $country, zipCode: $zipCode)';
  }
}
