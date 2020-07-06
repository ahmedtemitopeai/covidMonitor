import 'package:covid19_tracker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid19_tracker/covid_data.dart';
import 'package:covid19_tracker/location.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double lat = 0.0, lng = 0.0;
  Location loc;

  @override
  void initState() {
    super.initState();
    checkGeolocatorStatus();
    getLongLat();
    getCovidGlobalData();
  }

  Future checkGeolocatorStatus() async {
    GeolocationStatus geolocationStatus;
    try {
      geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
      return geolocationStatus;
    } catch (e) {
      return e;
    }
  }

  void getLongLat() async {
    Position position;
    try {
      loc = Location();
      position = await loc.getLocation();
      lat = position.latitude;
      lng = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  void getCovidGlobalData() async {
    CovidModel covidModel = CovidModel();
    var covidData = await covidModel.getCovidData();
    var locationData = await covidModel.getCountryName();
    var place = await covidModel.getAddressFromLagLng();
    // var countryData = await covidModel.getCountryData();
    getLongLat();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                place: place,
                covidData: covidData,
                locationData: locationData,
                // countryData: countryData,
                lat: lat,
                lng: lng,
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
