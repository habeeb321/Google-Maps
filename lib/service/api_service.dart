import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps/model/locations.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Locations> getGoogleOffices() async {
    const googleLocationsURL =
        'https://about.google/static/data/locations.json';

    // Retrieve the locations of Google offices
    try {
      final response = await http.get(Uri.parse(googleLocationsURL));
      if (response.statusCode == 200) {
        return Locations.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // Fallback for when the above HTTP request fails.
    return Locations.fromJson(
      json.decode(
        await rootBundle.loadString('assets/locations.json'),
      ) as Map<String, dynamic>,
    );
  }
}
