import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../widgets/currency_dropdown.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CurrencyService _currencyService = CurrencyService();
  double _exchangeRate = 0.0;
  String _baseCurrency = 'USD';
  String _targetCurrency = 'EUR';
  List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD'];

  @override
  void initState() {
    super.initState();
    _updateExchangeRate();
  }

  void _updateExchangeRate() async {
    try {
      final rate = await _currencyService.fetchExchangeRate(_baseCurrency, _targetCurrency);
      setState(() {
        _exchangeRate = rate;
      });
    } catch (e) {
      print(e);
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _baseCurrency;
      _baseCurrency = _targetCurrency;
      _targetCurrency = temp;
      _updateExchangeRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter 3001'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CurrencyDropdown(
                    value: _baseCurrency,
                    currencies: _currencies,
                    onChanged: (value) {
                      setState(() {
                        _baseCurrency = value!;
                        _updateExchangeRate();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    iconSize: 30, //
                    icon: Icon(Icons.swap_horiz),
                    onPressed: _swapCurrencies,
                  ),
                ),
                Expanded(
                  child: CurrencyDropdown(
                    value: _targetCurrency,
                    currencies: _currencies,
                    onChanged: (value) {
                      setState(() {
                        _targetCurrency = value!;
                        _updateExchangeRate();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              '1 $_baseCurrency = $_exchangeRate $_targetCurrency',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateExchangeRate,
              child: Text('Refresh Rate'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
