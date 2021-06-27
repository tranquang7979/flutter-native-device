import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_device/helpers/db_helper.dart';
import 'package:native_device/helpers/location_helper.dart';
import 'package:native_device/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id){
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {

    final address = pickedLocation == null
        ? ''
        : await LocationHelper.getPlaceAddress(
            pickedLocation.latitude,
            pickedLocation.longitude,
          );
print(address);
    final updatedLocation = pickedLocation == null
        ? PlaceLocation(
            latitude: 37.422,
            longitude: -122.084,
            address: address,
          )
        : PlaceLocation(
            latitude: pickedLocation.latitude,
            longitude: pickedLocation.longitude,
            address: address,
          );

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: updatedLocation,
    );

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': updatedLocation.latitude,
      'loc_lng': updatedLocation.longitude,
      'address': updatedLocation.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (e) => Place(
              id: e['id'],
              title: e['title'],
              image: File(e['image']),
              location: PlaceLocation(
                  latitude: e['loc_lat'],
                  longitude: e['loc_lng'],
                  address: e['address'])),
        )
        .toList();
    notifyListeners();
  }
}
