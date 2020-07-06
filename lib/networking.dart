import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkManager {
  final String url;
  final Map<String, String> headers;

  NetworkManager({this.url, this.headers});

  Future<dynamic> getData() async {
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = json.decode(data);
        return decodedData;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return e;
    }
  }
}
