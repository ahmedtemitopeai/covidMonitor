import 'package:flutter/material.dart';
import 'package:covid19_tracker/constants.dart';

class ReportContainer extends StatelessWidget {
  final Function onTap;
  final String reportTextTitle;
  final String reportTextContent;

  ReportContainer(
      {@required this.onTap,
      @required this.reportTextTitle,
      this.reportTextContent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kReportContainerColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                reportTextTitle,
                style: kGlobalTextStyle,
              ),
              kSizedBox,
              Text(
                reportTextContent,
                style: kTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
