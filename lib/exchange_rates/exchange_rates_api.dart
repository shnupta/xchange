import 'package:http/http.dart' as http;

import 'dart:convert';

class ExchangeRatesAPI {
  static const String BASE_URL = "api.exchangeratesapi.io";
  static const String LATEST_URL = "/latest";

  ExchangeRatesAPI();

  Future<double> getExchangeRate(String base, String comp) async {
    Map<String, String> params = Map<String, String>();
    params['base'] = base;
    params['symbols'] = [comp].join(',');
    Uri uri = Uri.https(BASE_URL, LATEST_URL, params);
    http.Response response = await http.get(uri);
    if(response.statusCode == 200) {
      return Future.value(json.decode(response.body)['rates'][comp]);
    } else {
      return Future.value(-1);
    }
  }
}