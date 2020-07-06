import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Location({this.latitude, this.longitude});

  Future<Position> getLocation() async {
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return e;
    }
    return position;
  }
}
