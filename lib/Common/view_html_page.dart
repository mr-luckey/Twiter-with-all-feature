import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/apiServices.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewHtmlPage extends StatefulWidget {
  final String? myHtml;
  const ViewHtmlPage({this.myHtml, Key? key}) : super(key: key);

  @override
  _ViewHtmlPageState createState() => _ViewHtmlPageState();
}

class _ViewHtmlPageState extends State<ViewHtmlPage> {
  final _streamLoading = StreamController<bool>.broadcast();
  final _streamText = StreamController<bool>.broadcast();
  final _ctr_url = TextEditingController();
  late WebViewController _viewController;
  bool isStatusOK = false;

  _ViewHtmlPageState() {
    _ctr_url.addListener(() {
      _streamText.add(_ctr_url.text.isNotEmpty);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _streamLoading.close();
    _streamText.close();
    super.dispose();
  }

  _getHTML(String url) async {
    _streamLoading.add(true);
    Uri _url = Uri.parse(url);
    await ApiServices.GET(url: _url).then((response) {
      if (response != null) {
        setState(() {
          isStatusOK = response.statusCode == 200 || response.statusCode == 201;
        });
      }
    });
    _streamLoading.add(false);
  }

  void loadLocalHTML(String html) async {
    final url = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    _viewController.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: StreamBuilder<bool>(
              stream: _streamLoading.stream,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data!) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'consultando ${_ctr_url.text}',
                        style: style.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return TextField(
                  controller: _ctr_url,
                  style: style.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 0, right: 15),
                    //focusedBorder: InputBorder.none,
                    //enabledBorder: InputBorder.none,
                    hintStyle: style.copyWith(color: Colors.grey),
                    hintText: 'Escriba aquí: http://www.google.com',
                  ),
                );
              }),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () => _getHTML(_ctr_url.text),
                icon: StreamBuilder<bool>(
                    stream: _streamText.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Icon(
                        snapshot.data! ? Icons.send : Icons.search,
                        color: Colors.white,
                      );
                    })),
          ],
        ),
        body: isStatusOK
            ? WebView(
                initialUrl: _ctr_url.text,
                javascriptMode: JavascriptMode.unrestricted,
                /* onWebViewCreated: (controller) {
                  _viewController = controller;
                }, */
              )
            : Container(
                child: Center(
                  child: StreamBuilder<bool>(
                      stream: _streamLoading.stream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.data!) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Text(
                          '404 Page not found',
                          style: style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        );
                      }),
                ),
              ),
      ),
    );
  }
}
