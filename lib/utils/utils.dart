import 'dart:convert';
import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
//import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class AppUtil {
  static late final GlobalKey<NavigatorState> navigatorKey;
  static late final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  static bool isWebMobile = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  static bool isRealDevice() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
  static bool isEmulatorOrSimulator() {
    if (Platform.isAndroid) {
      return androidEmulatorCheck();
    } else if (Platform.isIOS) {
      return iosSimulatorCheck();
    }
    return false;
  }

  static bool androidEmulatorCheck() {
    // Check for common Android emulator properties
    return (Platform.environment['ANDROID_EMULATOR'] == 'true') ||
        (Platform.environment['EMULATED_STORAGE_SOURCE'] != null);
  }

  static bool iosSimulatorCheck() {
    // Check for common iOS simulator properties
    return Platform.environment['SIMULATOR_DEVICE_NAME'] != null;
  }

  static Size get size {
    return navigatorKey.currentContext != null
        ? MediaQuery.of(navigatorKey.currentContext!).size
        : const Size(0, 0);
  }

  static double parseStringToDouble(String input) {
    double result = 0.0;

    // Use int.tryParse to attempt parsing the string
    double? parsedValue = double.tryParse(input);

    // Check if parsing was successful
    if (parsedValue != null) {
      result = parsedValue;
    }

    return result;
  }

  static double get height {
    return navigatorKey.currentContext != null
        ? MediaQuery.of(navigatorKey.currentContext!).size.height
        : 0;
  }

  static double get width {
    return navigatorKey.currentContext != null
        ? MediaQuery.of(navigatorKey.currentContext!).size.width
        : 0;
  }

  static EdgeInsets get padding {
    return navigatorKey.currentContext != null
        ? MediaQuery.of(navigatorKey.currentContext!).viewPadding
        : EdgeInsets.zero;
  }

  static BuildContext? get context => navigatorKey.currentContext;

  static void snackBar(
      {required String message,
      BuildContext? context,
      Color? textColor = Colors.white,
      Color bgColor = Colors.black54,
      SnackBarAction? action}) {
    print("textColor: $textColor");
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: textColor)),
      action: action,
      backgroundColor: bgColor,
    );
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  static Future<OpenResult> openFile(String path) async {
    var result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      snackBar(message: result.message,textColor:Colors.white);
    }
    return result;
  }

  static Future<File?> readFile(List<String> allowedExtension) async {

      try {

          FilePickerResult? result =

          await FilePicker.platform.pickFiles(type: FileType.any);
          if (result != null) {
            String fileName = result.files.single.name!;

            Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
            String filePath = '${appDocumentsDirectory.path}/$fileName';
            if(!isEmulatorOrSimulator() || Platform.isAndroid){
              filePath = result.files.single.path!;
            }
            File files = File(filePath);

            return files;
          } else {
            return null;
          }

      } catch (e) {
        if (!await isStorageGranted()) {
          openAppSettings();
        }

        return null;
      }

  }



  static Future<bool> isStorageGranted() async {
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  static Future<bool> onCheckPermissionGranted() async {
    final granted = await CRFileSaver.requestWriteExternalStoragePermission();
    return granted;
   
  }

  static Future<bool> isCameraGranted() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static List<String> explodeString(String input, String delimiter) {
    List<String> result = input.split(delimiter);
    return result;
  }

  static Future<bool> openAppSettings() {
    return openAppSettings();
  }

  static String defaultTimeFormat(DateTime dateTime, {bool regular = false}) {
    return DateFormat(
            regular ? 'EEEE dd MMMM yyyy HH:mm' : 'EEEE,dd MMMM yyyy-HH:mm')
        .format(dateTime);
  }

  static String defaultTimeFormatStandard(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String defaultTimeFormatCustom(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static DateTime timeClockFormatToDateTime(String timeClock) {
    //19:00
    DateTime currentTime = DateTime.now();

    // Create a DateFormat object for parsing the time string
    DateFormat format = DateFormat.Hm();
    // Parse the time string into a DateTime object
    DateTime dateTime = format.parse(timeClock);
    DateTime dateTimeNew = DateTime(currentTime.year, currentTime.month,
        currentTime.day, dateTime.hour, dateTime.minute, dateTime.hour);
    return dateTimeNew;
  }

  static DateTime timeClockFormatToDateTimeStart(String timeClock) {
    //19:00
    DateTime currentTime = DateTime.now();

    // Create a DateFormat object for parsing the time string
    DateFormat format = DateFormat.Hm();
    // Parse the time string into a DateTime object
    DateTime dateTime = format.parse(timeClock);
    DateTime dateTimeNew = DateTime(currentTime.year, currentTime.month,
        currentTime.day - 1, dateTime.hour, dateTime.minute, dateTime.hour);
    return dateTimeNew;
  }

  static bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return num.tryParse(s) != null;
  }

  static void showLoading() {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
          child: Center(
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          onWillPop: () async => false),
    );
  }

  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String fixInvalidCharacters(String input) {
    StringBuffer output = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      int codeUnit = input.codeUnitAt(i);
      // Cek apakah karakter merupakan karakter yang valid dalam UTF-8
      if (codeUnit < 0x80 ||
          (codeUnit >= 0xC2 && codeUnit <= 0xF4 && codeUnit != 0xC0 && codeUnit != 0xC1 && codeUnit != 0xF5 && codeUnit != 0xF6 && codeUnit != 0xF7)) {
        output.writeCharCode(codeUnit);
      } else {
        // Ganti karakter yang tidak valid dengan karakter pengganti, misalnya '!'.
        output.write('');
      }
    }
    return output.toString();
  }

}

const String alphabet = "0123456789abcdef";
const hex = HexCodec();

class HexCodec extends Codec<List<int>, String> {
  const HexCodec();

  @override
  Converter<List<int>, String> get encoder => const HexEncoder();

  @override
  Converter<String, List<int>> get decoder => const HexDecoder();
}

class HexEncoder extends Converter<List<int>, String> {
  final bool upperCase;

  const HexEncoder({this.upperCase = false});

  @override
  String convert(List<int> input) {
    StringBuffer buffer = StringBuffer();
    for (int part in input) {
      if (part & 0xff != part) {
        throw const FormatException("Non-byte integer detected");
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    if (upperCase) {
      return buffer.toString().toUpperCase();
    } else {
      return buffer.toString();
    }
  }
}

/// A converter to decode hexadecimal strings into byte arrays.
class HexDecoder extends Converter<String, List<int>> {
  const HexDecoder();

  @override
  List<int> convert(String input) {
    String str = input.replaceAll(" ", "");
    str = str.toLowerCase();
    if (str.length % 2 != 0) {
      str = "0$str";
    }
    Uint8List result = Uint8List(str.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      int firstDigit = alphabet.indexOf(str[i * 2]);
      int secondDigit = alphabet.indexOf(str[i * 2 + 1]);
      if (firstDigit == -1 || secondDigit == -1) {
        throw FormatException("Non-hex character detected in $input");
      }
      result[i] = (firstDigit << 4) + secondDigit;
    }
    return result;
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    if (length == 0) {
      return "";
    } else if (length == 1) {
      return this[0].toUpperCase();
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String? capitalizeFirstofEach({Pattern? delimiter, String? separator}) {
    if (split(delimiter ?? " ").isEmpty) return null;
    return split(delimiter ?? " ")
        .map((str) => str.capitalizeFirst())
        .join(separator ?? " ");
  }

  String removeDecimalString() {
    if (!contains('.')) return this;
    return replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
  }

  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
}
