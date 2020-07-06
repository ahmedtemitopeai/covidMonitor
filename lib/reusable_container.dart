import 'package:flutter/material.dart';
import 'package:covid19_tracker/constants.dart';
import 'package:covid19_tracker/reusable_text.dart';

class ReusableContainer extends StatelessWidget {
  ReusableContainer({
    @required this.totalCases,
    @required this.newCases,
    @required this.totalDeaths,
    @required this.newDeaths,
    @required this.totalRecovered,
    @required this.lastUpdated,
    this.countriesDropdown,
    this.containerTitle,
    this.countryImage,
  });

  final String totalCases;
  final String newCases;
  final String totalDeaths;
  final String newDeaths;
  final String totalRecovered;
  final DateTime lastUpdated;
  final String containerTitle;
  final GestureDetector countriesDropdown;
  final Text countryImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C1E1F),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coronavirus Global Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: countryImage,
                ),
                Text(
                  containerTitle,
                  style: kTextStyle,
                ),
                Container(
                  child: countriesDropdown,
                ),
              ],
            ),
            kSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ReusableText(
                      text: 'Total Cases',
                      colour: Colors.blueGrey,
                    ),
                    kSizedBox,
                    ReusableText(
                      text: totalCases,
                      colour: Colors.lightBlueAccent,
                      fsize: 24.0,
                    ),
                    kSizedBox,
                    Row(
                      children: [
                        ReusableText(
                          text: 'New ',
                          colour: Colors.blueGrey,
                        ),
                        ReusableText(
                          text: "+$newCases",
                          colour: Colors.lightBlueAccent,
                          fsize: 12.0,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    ReusableText(
                      text: 'Deaths',
                      colour: Colors.blueGrey,
                    ),
                    kSizedBox,
                    ReusableText(
                      text: totalDeaths,
                      colour: Colors.redAccent,
                      fsize: 24.0,
                    ),
                    kSizedBox,
                    Row(
                      children: [
                        ReusableText(
                          text: 'New ',
                          colour: Colors.blueGrey,
                        ),
                        ReusableText(
                          text: "+$newDeaths",
                          colour: Colors.redAccent,
                          fsize: 12.0,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    ReusableText(
                      text: 'Recovered',
                      colour: Colors.blueGrey,
                    ),
                    kSizedBox,
                    ReusableText(
                      text: "$totalRecovered",
                      colour: Colors.greenAccent,
                      fsize: 24.0,
                    ),
                    kSizedBox,
                    Row(
                      children: [
                        // ReusableText(
                        //   text: 'New ',
                        //   colour: Colors.blueGrey,
                        // ),
                        // ReusableText(
                        //   text: '+7.962',
                        //   colour: Colors.greenAccent,
                        //   fsize: 12.0,
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            kSizedBox,
            ReusableText(
              text: 'Last updated: $lastUpdated',
              colour: Colors.blueGrey,
              fsize: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
