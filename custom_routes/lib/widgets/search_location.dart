import 'package:flutter/material.dart';
import '../models/location_suggestion.dart';
import '../services/search_location_service.dart';

class AddressSearch extends SearchDelegate<LocationSuggestion> {
  AddressSearch(this.sessionToken) : searchLocationService = SearchLocationService(sessionToken: sessionToken);

  final Object sessionToken;
  final SearchLocationService searchLocationService;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, LocationSuggestion.empty());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text(
        'No results found',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == "" ? null : searchLocationService.fetchSuggestionsOnSearch(query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Enter a location/address',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text((snapshot.data![index]).description),
                    onTap: () {
                      close(context, snapshot.data![index]);
                    },
                  ),
                  itemCount: snapshot.data?.length,
                )
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
    );
  }
}
