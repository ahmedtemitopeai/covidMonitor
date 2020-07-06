import 'package:covid19_tracker/country_data.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CountryChange extends StatefulWidget {
  final String cNamee;

  CountryChange({this.cNamee});

  @override
  _CountryChangeState createState() => _CountryChangeState();
}

class _CountryChangeState extends State<CountryChange> {
  CountryFlag c = CountryFlag();
  String countryName;

  @override
  void initState() {
    super.initState();
    countryName = widget.cNamee;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black54,
        appBarTheme: AppBarTheme(color: Colors.black12),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text('Change Country'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchableDropdown.single(
        displayClearIcon: false,
        isExpanded: true,
        value: countryName,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        onChanged: (newValue) {
          setState(() {
            countryName = newValue;
            print(countryName);
            Navigator.pop(context, countryName);
          });
        },
        items: c.countries.keys
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            child: Text(value),
            value: value,
          );
        }).toList(),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
