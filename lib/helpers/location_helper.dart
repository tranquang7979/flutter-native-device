import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyAKRTd35t_AjscQXhJgm3rZZuuKYwhSCdc';

class LocationHelper with ChangeNotifier {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
