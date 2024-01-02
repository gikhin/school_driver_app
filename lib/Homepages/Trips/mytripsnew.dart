import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Utils/Appurls/appurl.dart';

class PlaceAutocomplete extends StatefulWidget {
  @override
  _PlaceAutocompleteState createState() => _PlaceAutocompleteState();
}

class _PlaceAutocompleteState extends State<PlaceAutocomplete> {
  TextEditingController _searchController = TextEditingController();
  List<String> _predictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Autocomplete'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search for a place',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_predictions[index]),
                  onTap: () {
                    // Handle the selected place
                    _onPlaceSelected(_predictions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    // Call the Google Places API to get predictions
    _getPlacePredictions(query);
  }

  Future<void> _getPlacePredictions(String input) async {

    String apiKey = AppUrl.gKey;
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final predictions = json.decode(response.body)['predictions'];
      setState(() {
        _predictions = predictions.map((prediction) {
          return prediction['description'];
        }).cast<String>().toList();
      });
    } else {
      throw Exception('Failed to load place predictions');
    }
  }

  void _onPlaceSelected(String place) {
    // Fill the selected place in the TextField
    setState(() {
      _searchController.text = place;
      // Optionally, you can close the suggestions list here
      _predictions.clear();
    });
  }
}
