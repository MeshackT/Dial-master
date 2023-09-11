import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});

  // Factory constructor for non-constant default value
  factory PlaceLocation.defaultLocation() {
    return PlaceLocation(latitude: 37.422, longitude: -122.084, address: '');
  }
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.location,
  }) : id = uuid.v4();
}
