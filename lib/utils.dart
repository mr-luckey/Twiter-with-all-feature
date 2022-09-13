// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/mConstants.dart';
//import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

enum UtilToast { center, top, bottom, left, right }

class Utils {
  static void toast2(
    BuildContext context,
    String msg, {
    int duration = 2000,
    UtilToast position = UtilToast.bottom,
    Color? colorText,
    Color? backgroundColor,
  }) {
    /* final List _positioned = [
      StyledToastPosition.center,
      StyledToastPosition.top,
      StyledToastPosition.bottom,
      StyledToastPosition.left,
      StyledToastPosition.right,
    ]; */
    /* final titleColor =
        colorText == null ? style : style.copyWith(color: colorText); */

    /*  showToast(msg,
        context: context,
        duration: Duration(milliseconds: duration),
        position: _positioned[position.index],
        backgroundColor: backgroundColor,
        textStyle: titleColor); */
  }

  /*  static get positionedCenter => StyledToastPosition.center;
  static get positionedTop => StyledToastPosition.top;
  static get positionedBottom => StyledToastPosition.bottom;
  static get positionedLeft => StyledToastPosition.left;
  static get positionedRight => StyledToastPosition.right; */

  /* static void toast(
    BuildContext context,
    String msg, {
    int duration = 2000,
    StyledToastPosition position = StyledToastPosition.bottom,
    Color? colorText,
    Color? backgroundColor,
  }) {
    final titleColor =
        colorText == null ? style : style.copyWith(color: colorText);

    showToast(msg,
        context: context,
        duration: Duration(milliseconds: duration),
        position: position,
        backgroundColor: backgroundColor,
        textStyle: titleColor);
  } */

  static void snackBar(BuildContext context, String msg,
      {Color? colorText, Color? backgroundColor}) {
    try {
      final snackTitleColor =
          colorText == null ? style : style.copyWith(color: colorText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: Text(
            msg,
            style: snackTitleColor,
          ),
        ),
      );
    } on Exception catch (_) {}
  }

  static String numberEngeenerFormat(int value, [int decimals = 1]) {
    if (value >= 1000 && value < 1000000) {
      final v = Utils.limitDecimal(value / 1000, decimals);
      return '${v}K';
    } else if (value >= 1000000) {
      final v = Utils.limitDecimal(value / 1000000, decimals);
      return '${v}M';
    } else {
      return '$value';
    }
  }

  //  From Epoch to dateTime
  static DateTime epochToDateTime(int epoch) {
    final DateTime timeStamp =
        DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return timeStamp;
  }

// limit decimal and chance . -> ,
  static String limitDecimal(double amount, [int maxDecimals = 4]) {
    String aux3 = amount.toStringAsFixed(maxDecimals).toString();
    final ent = aux3.split(".")[0];
    final dec = aux3.split(".")[1];
    return ent + "," + dec;
  }

  // limit decimal and chance . -> ,
  static double limitDecimalDouble(double amount, [int maxDecimals = 2]) {
    String aux = amount.toStringAsFixed(maxDecimals).toString();
    try {
      var value = double.parse(aux);
      return value;
    } catch (_) {
      return amount;
    }
  }

  // function time value example: 20:12
  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

//  From dateTime To String Date
  static String dateTimeToStringDate(DateTime date, [int selected = 0]) {
    final M = date.month.toString().padLeft(2, '0');
    final D = date.day.toString().padLeft(2, '0');
    final Y = date.year.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    final ss = date.second.toString().padLeft(2, '0');
    final a = date.hour >= 12 ? "PM" : "AM";

    var string = '$Y-$M-$D $hh:$mm';
    switch (selected) {
      case -1:
        string = '$Y-$M-$D $hh:$mm:$ss';
        break;
      case 0:
        string = '$Y-$M-$D $hh:$mm';
        break;
      case 1:
        string = '$Y-$M-$D';
        break;
      case 2:
        string = '$hh:$mm';
        break;
      case 3:
        string = '$Y-$M-$D $hh:$mm';
        break;
      case 4:
        string = '${MONTH[date.month - 1]} $D, $hh:$mm';
        break;
      case 5:
        string = '$Y.$M.$D - $hh:$mm';
        break;
      case 6:
        string = '${MONTH[date.month - 1]} $D, $hh:$mm $a';
        break;
      case 7:
        string = '$D ${MONTH[date.month - 1]}';
        break;
      default:
    }
    return string;
  }

  //  From Epoch to String Date
  static String epochToStringDate(int epoch,
      [int selected = 0, bool settings = false]) {
    final date = epochToDateTime(epoch);
    final string = dateTimeToStringDate(date, selected);
    if (settings) {
      var to = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var today = dateTimeToStringDate(epochToDateTime(to), 4).split(',').first;
      return string.contains(today) ? string.split(',').last : string;
    }
    return string;
  }

  // scan
  /* static Future<String> scanQR() async {
    final respQR = await FlutterBarcodeScanner.scanBarcode(
        '#000000', 'Cancel', true, ScanMode.QR);
    print("QR value: $respQR");
    return (respQR == "-1") ? "" : respQR;
  } */

  static double calcScale({
    required double srcWidth,
    required double srcHeight,
    required double minWidth,
    required double minHeight,
  }) {
    var scaleW = srcWidth / minWidth;
    var scaleH = srcHeight / minHeight;

    double max(double v1, double v2) => v1 > v2 ? v1 : v2;
    double min(double v1, double v2) => v1 > v2 ? v2 : v1;

    var scale = max(1.0, min(scaleW, scaleH));

    return scale;
  }

  static Future<File?> testCompressAndGetFile(File file, String targetPath,
      {quality = 95, rotate = 0}) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      rotate: rotate,
    );

    debugPrint('${file.lengthSync()}');
    debugPrint('${result?.lengthSync()}');

    return result;
  }

  static Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  static Future<File> networkImageToFile(String srcUrl) async {
    http.Response response = await http.get(Uri.parse(srcUrl));
    final bytes = response.bodyBytes;

    final ext = srcUrl.split('.').last;
    final dir1 = await getApplicationDocumentsDirectory();
    final epoch = DateTime.now().millisecondsSinceEpoch.toString();

    File file = File("${dir1.path}/" + epoch + ".$ext");
    File _file = await file.writeAsBytes(bytes);
    return _file;
  }

  static Future<bool> downloadFileUrl(String fileurl) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = fileurl.split('/').last;
        String savePath = dir.path + "/$savename";
        // ignore: avoid_print
        print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(fileurl, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              // ignore: avoid_print
              print((received / total * 100).toStringAsFixed(0) + "%");
              //you can build progressbar feature too
            }
          });
          // ignore: avoid_print
          print("File is saved to download folder.");
          return true;
        } on DioError catch (e) {
          // ignore: avoid_print
          print(e.message);
          return false;
        }
      } else {
        return false;
      }
    } else {
      // ignore: avoid_print
      print("No permission to read and write.");
      return false;
    }
  }

  static Future<File> createFileFromUint8List(Uint8List bytes, String ext,
      [String auxName = '']) async {
    final dir1 = await getApplicationDocumentsDirectory();
    //var dir2 = await DownloadsPathProvider.downloadsDirectory;
    final epoch = DateTime.now().millisecondsSinceEpoch.toString();
    File
        file = /*  dir2 != null
        ? File("${dir2.path}/" + auxName + epoch + ".$ext")
        : */
        File("${dir1.path}/" + auxName + epoch + ".$ext");
    File f = await file.writeAsBytes(bytes);
    return f;
  }

  static Future<String> createFileFromString(
      String encodedStr, String ext) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var dir2 = await DownloadsPathProvider.downloadsDirectory;
    final epoch = DateTime.now().millisecondsSinceEpoch.toString();
    File file = dir2 != null
        ? File("${dir2.path}/" + epoch + ".$ext")
        : File("$dir/" + epoch + ".$ext");
    File f = await file.writeAsBytes(bytes);
    return f.path;
  }

  static Future<bool> base64toFile(String base64, String ext) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        var ep = dateTimeToStringDate(DateTime.now(), -1);
        String savename = generateRandomString(10) + ep + '.$ext';
        String savePath = dir.path + "/$savename";
        // ignore: avoid_print
        print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          var uint8list = base64Decode(base64);
          var buffer = uint8list.buffer;
          ByteData byteData = ByteData.view(buffer);
          await File(dir.path).writeAsBytes(buffer.asUint8List(
              byteData.offsetInBytes, byteData.lengthInBytes));
          return true;
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return false;
        }
      } else {
        return false;
      }
    } else {
      // ignore: avoid_print
      print("No permission to read and write.");
      return false;
    }
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static int generateRandomInt([int max = 9999]) {
    var rng = Random();

    return rng.nextInt(max);
  }

  static List<int> getScaleFromSize(Size size, {bool debug = true}) {
    int w = size.width.toInt();
    int h = size.height.toInt();

    int ww = 1;
    int hh = 1;

    try {
      if (w == h) {
        if (debug) debugPrint("x 1,1");
      } else if (w > h) {
        hh = int.parse((h / h).toStringAsFixed(0));
        ww = int.parse((w / h).toStringAsFixed(0));

        if (debug) debugPrint("< $ww,$hh");
        return [
          int.parse(ww.toStringAsFixed(0)),
          int.parse(hh.toStringAsFixed(0))
        ];
      } else {
        hh = int.parse((h / w).toStringAsFixed(0));
        ww = int.parse((w / w).toStringAsFixed(0));

        if (debug) debugPrint("> $ww,$hh");
        return [
          int.parse(ww.toStringAsFixed(0)),
          int.parse(hh.toStringAsFixed(0))
        ];
      }
    } catch (_) {}

    return [
      int.parse(ww.toStringAsFixed(0)),
      int.parse(hh.toStringAsFixed(0)),
    ];
  }

  static Future<Size> getSizeFromImage(String url,
      {File? file, bool debug = true}) async {
    print("Calculando resolución: (width, height) ");
    try {
      File image;
      if (file == null) {
        var strURL = Uri.parse(url);
        final http.Response responseData = await http.get(strURL);
        var uint8list = responseData.bodyBytes;
        var buffer = uint8list.buffer;
        ByteData byteData = ByteData.view(buffer);
        final tempDir = await getApplicationDocumentsDirectory();
        image = await File('${tempDir.path}/img').writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      } else {
        image = file;
      }

      //File image = new File('image.png'); // Or any other way to get a File instance.
      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
      final double width = decodedImage.width.toDouble();
      final double height = decodedImage.height.toDouble();
      Size size = Size(width, height);
      if (debug) debugPrint("Size(${width.toInt()} - ${height.toInt()})");

      // others
      //final bytes = image.readAsBytesSync().lengthInBytes;
      //final kb = bytes / 1024;
      //final mb = kb / 1024;

      return size;
    } catch (e) {
      print(e);
      return Size(0, 0);
    }
  }

  static Future<String> fileToBase64(File file,
      {bool addAuxString = false}) async {
    try {
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String aux = addAuxString ? auxB64 : "";
      //print(base64Image);
      return aux + base64Image;
    } catch (e) {
      print(e);
      return "";
    }
  }

  static void clipboardData(BuildContext context, String value,
      {String textCopy = "Copiado al portapapeles.",
      String dialogMessage = 'Check out my pubication',
      String errorMessage = 'No puede copiar un texto vacio',
      bool share = false,
      String? subject}) {
    if (value.isNotEmpty) {
      debugPrint("Copiado: $value");
      Clipboard.setData(ClipboardData(text: value));
      /* Utils.toast(
        context,
        textCopy,
        position: Utils.positionedCenter,
      ); */
      if (share) Share.share(dialogMessage + ' $value', subject: subject);
    } else {
      /*  Utils.toast(
        context,
        errorMessage,
        backgroundColor: Colorskronoss.red_snackbar_error,
        position: Utils.positionedCenter,
      ); */
    }
  }

  static Future<File> croppedImageFile(File imageFile,
      {List<CropAspectRatioPreset>? aspectRatio,
      CropAspectRatioPreset? initAspectRatio}) async {
    File croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            aspectRatioPresets: aspectRatio ??
                [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Ajustes de imagen',
                toolbarColor: Colorskronoss.background_application_medium,
                toolbarWidgetColor: Colors.white,
                initAspectRatio:
                    initAspectRatio ?? CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            )) ??
        imageFile;
    return croppedFile;
  }

  static void dialogBottomGeneral({
    required BuildContext context,
    Widget? bottons,
    double? elevation = 4,
    bool isNotImage = false,
    bool isNotTitle = false,
    String message = '',
    String? title,
    Widget? iconTitle,
    Widget? content,
    String? replaceImageAssets,
    double sizeIconDefault = 50,
    Color colorTitle = Colors.white,
    Color colorTextContent = Colors.white,
    Color? colorBG,
    Color barrierColor = Colors.transparent,
    Function()? onpressed,
    bool dissmiss = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool paddingButtonAdd = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.5,
    double maxChildSize = 1.0,
  }) {
    iconTitle = isNotImage ? SizedBox() : null;
    showModalBottomSheet(
        context: context,
        isDismissible: dissmiss,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        enableDrag: enableDrag,
        backgroundColor: Colors.transparent,
        barrierColor: (dissmiss && (barrierColor == Colors.transparent))
            ? barrierColor
            : Colors.black12,
        elevation: elevation,
        builder: (ctx) => Container(
              decoration: BoxDecoration(
                color: colorBG ?? Colors.black,
                //border: Border.all(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: initialChildSize,
                  minChildSize: minChildSize,
                  maxChildSize: maxChildSize,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          //image
                          iconTitle ??
                              Container(
                                  width: sizeIconDefault,
                                  height: sizeIconDefault,
                                  child: Image.asset(
                                    replaceImageAssets ?? IMAGE_LOGO,
                                    fit: BoxFit.contain,
                                  )),
                          // titulo
                          isNotTitle
                              ? SizedBox()
                              : Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    title ?? APP_NAME,
                                    style: TextStyle(
                                        color: colorTitle,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(height: 10),
                          //contenido
                          content ??
                              SizedBox(
                                height: 400,
                                child: Center(
                                  child: Text(
                                    message,
                                    style: style,
                                  ),
                                ),
                              ),
                          SizedBox(height: 10),
                          //boton
                          bottons ?? SizedBox(),
                        ],
                      ),
                    );
                  }),
            ));
  }

  // modal to no redim height
  static void dialogBottomAdaptative({
    required BuildContext context,
    Widget? bottons,
    double? elevation = 4,
    bool isNotImage = false,
    bool isNotTitle = false,
    String message = '',
    String? title,
    Widget? iconTitle,
    Widget? content,
    String? replaceImageAssets,
    double sizeIconDefault = 50,
    Color colorTitle = Colors.white,
    Color colorTextContent = Colors.white,
    Color? colorBG,
    Color barrierColor = Colors.transparent,
    Function()? onpressed,
    bool dissmiss = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool paddingButtonAdd = true,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
  }) {
    iconTitle = isNotImage ? SizedBox() : null;
    showModalBottomSheet(
        context: context,
        isDismissible: dissmiss,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        enableDrag: enableDrag,
        backgroundColor: Colors.transparent,
        barrierColor: (dissmiss && (barrierColor == Colors.transparent))
            ? barrierColor
            : Colors.black12,
        elevation: elevation,
        builder: (ctx) => Container(
              decoration: BoxDecoration(
                color: colorBG ?? Colors.black,
                //border: Border.all(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: DraggableScrollableSheet(
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          //image
                          iconTitle ??
                              Container(
                                  width: sizeIconDefault,
                                  height: sizeIconDefault,
                                  child: Image.asset(
                                    replaceImageAssets ?? IMAGE_LOGO,
                                    fit: BoxFit.contain,
                                  )),
                          // titulo
                          isNotTitle
                              ? SizedBox()
                              : Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    title?.toUpperCase() ?? APP_NAME,
                                    style: TextStyle(
                                        color: colorTitle,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(height: 10),
                          //contenido
                          content ??
                              SizedBox(
                                height: 400,
                                child: Center(
                                  child: Text(
                                    message,
                                    style: style,
                                  ),
                                ),
                              ),
                          SizedBox(height: 10),
                          //boton
                          bottons ?? SizedBox(),
                        ],
                      ),
                    );
                  }),
            ));
  }
}
