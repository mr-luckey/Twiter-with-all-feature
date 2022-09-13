import 'dart:convert';

import 'package:kronosss/encrypt_data.dart';
import 'package:flutter/material.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  //---- is connection internet
  /*  static Future<bool> hasConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  } */

  //---- HEADERs
  // ignore: non_constant_identifier_names
  static final HEADERS_SIMPLE = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static Map<String, String> HEADERS_AUTH(String token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": token,
    };
  }

  //---- URL
  static Uri getUrl({required url, required endpoint, dynamic params}) =>
      params != null
          ? Uri.https(url, endpoint, params)
          : Uri.https(url, endpoint);
  //--------
  static getBody(http.Response response) {
    String b = utf8.decode(response.bodyBytes);
    final json = jsonDecode(b);
    return json;
  }

  // GET

  static Future<http.Response?> GET({
    required Uri url,
    bool printResp = false,
    Map<String, String>? header,
    int timeout = 80,
  }) async {
    try {
      var response = await http
          .get(
            url,
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeout));
      debugPrint('Response status: ${response.statusCode} || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

  // POST

  static Future<http.Response?> POST({
    required Uri url,
    required bodyy,
    bool printResp = false,
    Map<String, String>? header,
    int timeOut = 80,
    bool feel = true,
  }) async {
    try {
      var body = await EncryptData.encryptAESObj2(bodyy);
      var response = await http
          .post(
            url,
            body: jsonEncode(feel ? body : bodyy),
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}  || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

  // PUT

  static Future<http.Response?> PUT({
    required Uri url,
    required bodyy,
    bool printResp = false,
    Map<String, String>? header,
    int timeOut = 80,
    bool feel = true,
  }) async {
    try {
      var body = EncryptData.encryptAESObj2(bodyy);
      var response = await http
          .put(
            url,
            body: jsonEncode(feel ? body : bodyy),
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}  || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

// DELETE

  static Future<http.Response?> DELETE({
    required Uri url,
    bool printResp = false,
    Map<String, String>? header,
    int timeout = 300,
  }) async {
    try {
      var response = await http
          .delete(
            url,
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeout));
      debugPrint('Response status: ${response.statusCode} || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

  /* static Future<String> fcm(String plainText,
      {bool encryptMode = true, String? key}) async {
    var _key = key ?? await SharedPrefs.getString(shared_myDevice) ?? '';

    var encrypted = Encryptor.encrypt(_key, plainText);
    var decrypted = Encryptor.decrypt(_key, encrypted);

    //print(encrypted);
    //print(decrypted);
    return encryptMode ? encrypted : decrypted;
  } */

// notificaction push services
  static Future<void> sendMenssageFirebaseCloud(
      {required String tokenSend,
      required String authorization,
      String title = '',
      String content = '',
      Map<String, dynamic>? data,
      bool printResp = false,
      int timeOut = 300}) async {
    // header
    Map<String, String> headersAuth = {
      "Authorization": authorization,
      "Content-Type": 'application/json',
    };

    // body send
    Map<String, dynamic> body = {
      "to": tokenSend,
      "notification": {"title": title, "body": content},
      "data": data ?? {}
    };

    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http
          .post(
            url,
            body: jsonEncode(body),
            headers: headersAuth,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}');
      if (printResp) debugPrint('Response body: ${response.body}');
    } catch (_) {}
  }
}//....
