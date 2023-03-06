class LocationPlace {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;

  LocationPlace({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}
