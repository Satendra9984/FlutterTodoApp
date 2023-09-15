import 'package:flutter/material.dart';

enum Status {
  assigned,
  working,
  pending,
  completed,
}

enum FilterOptions { oldest, all }

enum ScreenNumber {
  home,
  saved,
  profile,
  completed,
}

const double kBRad = 13;
final kBorderRadius = BorderRadius.circular(kBRad);
const double kElevation = 25;

final theme = ThemeData(
    primaryColor: Colors.lightBlue,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlueAccent));

BoxDecoration kContainerElevationDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey.shade300, width: 0.5),
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

TextStyle kHintTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade600,
);

TextStyle kFormWidgetLabelStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
