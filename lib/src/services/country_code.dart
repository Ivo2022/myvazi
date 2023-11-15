import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class Country {
  final String countryName;
  final String countryCode;
  final String phoneCode;

  Country({required this.countryName, required this.countryCode, required this.phoneCode});
}

class CountryCode extends StatefulWidget {
  const CountryCode({super.key});

  @override
  State<CountryCode> createState() => _CountryCodeState();

}

class _CountryCodeState extends State<CountryCode> {
  List<Country> countries = [];
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Load and parse the JSON data
    loadCountryData();
  }

  Future<void> loadCountryData() async {
    String jsonString = await rootBundle.loadString('assets/data/country_phone_codes.json');
    List<dynamic> jsonList = jsonDecode(jsonString);

    setState(() {
      countries = jsonList.map((item) => Country(
        countryName: item['countryName'],
        countryCode: item['countryCode'],
        phoneCode: item['phoneCode'],
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<Country>(
          value: _selectedCountry,
          onChanged: (Country? newValue) {
            setState(() {
              _selectedCountry = newValue;
            });
          },
          items: countries.map<DropdownMenuItem<Country>>((Country country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Text('(${country.phoneCode})'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
