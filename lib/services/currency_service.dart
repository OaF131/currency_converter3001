import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  final String apiKey = 'fca_live_dVV2BD1729fsRUQNqg4Bhg8RC1Owd3f4vYU9mPrG';
  final String baseUrl = 'https://api.freecurrencyapi.com/v1/latest';

  Future<double> fetchExchangeRate(String fromCurrency,
      String toCurrency) async {
    final url = Uri.parse('$baseUrl?apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var rate = jsonResponse['data'][toCurrency];
      var baseRate = jsonResponse['data'][fromCurrency];

      double finalRate;

      if (fromCurrency == 'USD') {
        finalRate = rate is int ? rate.toDouble() : rate;
      } else if (toCurrency == 'USD') {
        finalRate = 1 / (baseRate is int ? baseRate.toDouble() : baseRate);
      } else {
        double rateToUSD = 1 / (baseRate is int ? baseRate.toDouble() : baseRate);
        double rateFromUSD = rate is int ? rate.toDouble() : rate;
        finalRate = rateToUSD * rateFromUSD;
      }

      // Округление до шестого знака после запятой
      return double.parse(finalRate.toStringAsFixed(6));
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load exchange rate');
    }
  }
}