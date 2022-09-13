import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kronosss/mConstants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? titleAppBar;
  final String url;
  final bool showAppBar;

  WebViewPage({required this.url, this.titleAppBar, this.showAppBar = true});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _stream = StreamController<int>();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.titleAppBar ?? APP_NAME),
              backgroundColor: Colorskronoss.background_application_dark,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios_new)),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // webiview
            WebView(
              initialUrl: widget.url.isEmpty ? WebOfficial : widget.url,
              backgroundColor: Colorskronoss.background_application_dark,
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (int progress) {
                print("progress: $progress%");
                _stream.sink.add(progress);
              },
            ),
            // stream loading
            /* StreamBuilder<int>(
                initialData: 0,
                builder: (_, snap) {
                  if (snap.data! < 99) {
                    return Container(
                      color: Colors.black45,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //progress
                          Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                          //text progress
                          Text(
                            "${snap.data}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ), */
          ],
        ),
      ),
    );
  }
}
