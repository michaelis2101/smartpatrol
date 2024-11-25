import 'package:flutter/material.dart';

// colors
const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color.fromARGB(255, 13, 72, 161);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);
const Color kGreyLight = Color(0xFF9E9E9E);
const Color kGreySelected = Color(0xFFE4E4E4);
const Color textBlack = Color(0xFF424242);

const Color kBlueButton = Color(0xFF124CA1);
const Color kBlueTeal = Color(0xFF0D47A1);
const Color kBlueTealPrimary = Color(0xFF124CA1);
const Color kBlueAccent = Color(0xFF0097D8);
const Color kTextBlue = Color(0xFF3178BD);
const Color kGreen = Color(0xFFB6D442);
const Color kGreenPrimary = Color(0xFF6AC800);
const Color kRedDark = Color(0xFFFF0000);
const Color kRedBlack = Color(0xFFE20000);
const Color kRedBgGrey = Color(0xFFE0E0E0);

const Color kBlueItasoft = Color(0xff1f5d92);

BoxDecoration containerToolbarDecoration = const BoxDecoration(
    gradient: LinearGradient(colors: [
  kBlueTealPrimary,
  kGreenPrimary,
]));

BoxDecoration buttonNFCDecoration = const BoxDecoration(
    shape: BoxShape.circle, // circular shape
    gradient: LinearGradient(colors: [
      kBlueTealPrimary,
      kGreenPrimary,
    ]));

BoxDecoration buttonPageNFCDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.black26, //                   <--- border color
      width: 5.0,
    ),
    gradient: const LinearGradient(colors: [
      kBlueTealPrimary,
      kGreenPrimary,
    ]));

const kColorScheme = ColorScheme(
  primary: kRedBlack,
  primaryContainer: kMikadoYellow,
  secondary: Colors.black,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  background: Colors.white,
  error: kRedDark,
  onPrimary: Colors.black,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);
