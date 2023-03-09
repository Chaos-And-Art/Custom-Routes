import 'dart:convert';
import 'dart:io';
import 'package:custom_routes/models/location_place.dart';
import 'package:custom_routes/models/location_suggestion.dart';
import 'package:custom_routes/models/trip_details_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';

class SearchLocationService {
  final client = Client();

  SearchLocationService({this.sessionToken});

  final Object? sessionToken;

  static String? androidKey = dotenv.env['ANDROID_GOOGLE_MAPS_API'];
  static String? iosKey = dotenv.env['IOS_GOOGLE_MAPS_API'];
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<LocationSuggestion>> fetchSuggestionsOnSearch(String input, String lang) async {
    // get user's current location
    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryCode = placemarks.first.isoCountryCode;

    final request = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:$countryCode&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions'].map<LocationSuggestion>((p) => LocationSuggestion(p['place_id'], p['description'])).toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<LocationSuggestion> fetchSuggestionsOnPosition() async {
    // get user's current location
    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryCode = placemarks.first.isoCountryCode;
    final suggestedLocation = await getPlaceDetailsFromPosition(position);
    //Had trouble trying to put a position into the query and get the suggestedPosition, so instead we send in an input, which seems to work
    final input = "${suggestedLocation.streetNumber}  ${suggestedLocation.street}, ${suggestedLocation.city} ${suggestedLocation.state}";

    final request = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=en&components=country:$countryCode&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final prediction = result['predictions'].first;
        return LocationSuggestion(prediction['place_id'], prediction['description']);
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return LocationSuggestion.empty();
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<LocationPlace> getPlaceDetailFromId(String placeId) async {
    LocationPlace locationPlace = LocationPlace();
    if (placeId.isNotEmpty) {
      final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
      final response = await client.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['status'] == 'OK') {
          final components = result['result']['address_components'] as List<dynamic>;

          // build result
          for (var c in components) {
            final List type = c['types'];
            if (type.contains('street_number')) {
              locationPlace.streetNumber = c['long_name'];
            }
            if (type.contains('route')) {
              locationPlace.street = c['long_name'];
            }
            if (type.contains('locality')) {
              locationPlace.city = c['long_name'];
            }
            //State
            if (type.contains('administrative_area_level_1')) {
              locationPlace.state = c['short_name'];
            }
            if (type.contains('country')) {
              locationPlace.country = c['short_name'];
            }
            if (type.contains('postal_code')) {
              locationPlace.zipCode = c['long_name'];
            }
          }
          return locationPlace;
        }
        throw Exception(result['error_message']);
      } else {
        throw Exception('Failed to fetch suggestion');
      }
    }
    return locationPlace;
  }

  Future<LocationPlace> getPlaceDetailsFromPosition(Position position) async {
    LocationPlace locationPlace = LocationPlace();
    final request = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      if (result['status'] == 'OK') {
        final components = result['results'][0]['address_components'] as List<dynamic>;
        // build result
        for (var c in components) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            locationPlace.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            locationPlace.street = c['long_name'];
          }
          if (type.contains('locality')) {
            locationPlace.city = c['long_name'];
          }
          //State
          if (type.contains('administrative_area_level_1')) {
            locationPlace.state = c['short_name'];
          }
          if (type.contains('country')) {
            locationPlace.country = c['short_name'];
          }
          if (type.contains('postal_code')) {
            locationPlace.zipCode = c['long_name'];
          }
        }
        return locationPlace;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

//BUG If you choose Destination first then starting destination if you clear starting destination
  Future<TripDetails> getTravelTime(String? origin, String? destination) async {
    TripDetails tripDetails = TripDetails();

    if (origin != null && destination != null) {
      final request = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&sessiontoken=$sessionToken';

      final response = await client.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['status'] == 'OK') {
          final route = result['routes'][0];
          final leg = route['legs'][0];

          tripDetails.distance = formatDistance(leg['distance']['value']);
          tripDetails.expectedDuration = formatDuration(leg['duration']['value']);

          return tripDetails;
        } else {
          throw Exception(result['error_message']);
        }
      } else {
        throw Exception('Failed to get travel time');
      }
    }
    return tripDetails;
  }

  String formatDistance(int meters) {
    double miles = meters / 1609.34;
    return "${miles.toStringAsFixed(2)} miles";
  }

  String formatDuration(int secs) {
    final duration = Duration(seconds: secs);

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final parts = [];

    if (days > 0) {
      parts.add('$days day${days == 1 ? '' : 's'}');
    }

    if (hours > 0) {
      parts.add('$hours hour${hours == 1 ? '' : 's'}');
    }

    if (minutes > 0) {
      parts.add('$minutes minute${minutes == 1 ? '' : 's'}');
    }

    if (seconds > 0) {
      parts.add('$seconds second${seconds == 1 ? '' : 's'}');
    }

    return parts.join(', ');
  }
}
