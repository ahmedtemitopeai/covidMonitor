import 'package:covid19_tracker/location.dart';
import 'package:covid19_tracker/networking.dart';
import 'package:covid19_tracker/constants.dart';
import 'package:geolocator/geolocator.dart';

const worldCovidDataUrl =
    'https://coronavirus-monitor.p.rapidapi.com/coronavirus/worldstat.php';
const geoLocUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
const geocodingApiKey = '';
const countryCovidDataUrl =
    'https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php';
const newsApiKey = '';
const newsUrl = 'http://newsapi.org/v2/top-headlines';

class CovidModel {
  NetworkManager networkManager;
  Future<dynamic> getCovidData() async {
    try {
      networkManager = NetworkManager(url: worldCovidDataUrl, headers: {
        "x-rapidapi-host": "coronavirus-monitor-v2.p.rapidapi.com",
        "x-rapidapi-key": apiKey
      });
    } catch (e) {
      print(e);
    }

    var covidData = await networkManager.getData();
    return covidData;
  }

  Future<dynamic> getCountryData(String countryName) async {
    try {
      networkManager = NetworkManager(
          url: countryCovidDataUrl + "?country=$countryName",
          headers: {
            "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
            "x-rapidapi-key": apiKey,
          });
    } catch (e) {
      return e;
    }

    var countryData = await networkManager.getData();
    return countryData;
  }

  String countryName, cityName;
  Position position;

  Future<dynamic> getCountryName() async {
    try {
      Location loc = Location();
      position = await loc.getLocation();
      networkManager = NetworkManager(
          url:
              '$geoLocUrl?latlng=${position.latitude},${position.longitude}&key=$geocodingApiKey');
      var locationData = await networkManager.getData();

      return locationData;
    } catch (e) {
      print(e);
    }
  }

  Future<Placemark> getAddressFromLagLng() async {
    Placemark place;
    try {
      List<Placemark> p = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      place = p[0];
    } catch (e) {
      return e;
    }
    return place;
  }

  Future<dynamic> getNewsData(String countryName) async {
    try {
      networkManager = NetworkManager(
          url: newsUrl +
              "?q=corona+virus&country=$countryName&sortBy=relevancy&apiKey=" +
              newsApiKey);
      print(networkManager.url);
    } catch (e) {
      return e;
    }
    var newsData = await networkManager.getData();
    return newsData;
  }
}
