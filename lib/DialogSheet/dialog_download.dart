import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

// DialogDownLoad(context, 'url').show();

class DialogDownLoad {
  final BuildContext context;
  String url;

  DialogDownLoad(this.context, this.url);

  void show() {
    DialogsUtils(context).showDialogChildWidget(
      child: DownloadFileGenerics(url: url),
      marginBotton: false,
    );

    /* DialogGenerics(
      context,
      child: DownloadFileGenerics(url: url),
    ); */
  }
}

class DownloadFileGenerics extends StatefulWidget {
  final String url;

  const DownloadFileGenerics({required this.url, Key? key}) : super(key: key);

  @override
  State<DownloadFileGenerics> createState() => _DownloadFileGenericsState();
}

class _DownloadFileGenericsState extends State<DownloadFileGenerics> {
  double progress = 0.0;
  bool downloading = false;
  String strProgress =
      'Para descargar el siguiente recurso presiona "Descargar"';

  @override
  void initState() {
    super.initState();
    strProgress = widget.url.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: !downloading
                ? SizedBox(height: 4, width: double.maxFinite)
                : LinearProgressIndicator(
                    value: progress,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              strProgress,
              style: style.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (!downloading) {
                //downloadFAKE(widget.url);

                await downloadFileUrl(widget.url);
                Navigator.of(context).pop();
              }
            },
            child: progress == 0.0
                ? _button('Descargar')
                : SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                          progress < 1.0
                              ? 'Espere mientras finaliza la descarga'
                              : '',
                          style: style),
                    ),
                  ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> downloadFAKE(String url) async {
    setState(() => downloading = true);
    while (progress < 1.0) {
      setState(() {
        progress = progress + 0.0017;
        strProgress = (progress * 100).toStringAsFixed(2) + "%";
      });
      await Future.delayed(Duration(milliseconds: 10));
    }
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => strProgress = 'ARCHIVO DESCARGADO!');
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.of(context).pop();
  }

  Future<bool> downloadFileUrl(String fileurl) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      setState(() => downloading = true);
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = fileurl.split('/').last;
        String savePath = dir.path + "/$savename";
        // ignore: avoid_print
        debugPrint(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(fileurl, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                progress = (received / total);
                strProgress = (progress * 100).toStringAsFixed(2) + "%";
              });
              // debugPrint((received / total * 100).toStringAsFixed(0) + "%");
              //you can build progressbar feature too
            }
          });
          // ignore: avoid_print
          setState(() => strProgress = 'ARCHIVO DESCARGADO!');
          await Future.delayed(Duration(milliseconds: 1000));
          print("File is saved to download folder.");
          setState(() => downloading = false);
          return true;
        } on DioError catch (e) {
          // ignore: avoid_print
          print(e.message);
          setState(() => downloading = false);
          return false;
        }
      } else {
        setState(() => downloading = false);
        return false;
      }
    } else {
      // ignore: avoid_print
      print("No permission to read and write.");
      setState(() => downloading = false);
      return false;
    }
  }

  Widget _button(String title) {
    return Container(
      width: double.maxFinite,
      height: 50,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: decoCircle,
      child: Center(
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}
