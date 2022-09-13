import 'dart:convert';

import 'package:aescryptojs/aescryptojs.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class EncryptData {
  final String key;
  EncryptData(this.key);

// encriptado
  String encryptAES(String strBase) {
    final pass = this.key;
    final enc = encryptAESCryptoJS(strBase, pass);
    return enc;
  }

  // encriptado object
  Map<String, dynamic> encryptAESObj(String strBase) {
    final pass = this.key;
    final enc = encryptAESCryptoJS(strBase, pass);
    final json = {"feel": enc};
    return json;
  }

  // Future des obj
  static Future encryptAESObj2(jsonBody) async {
    try {
      final pass = await SharedPrefs.getString(shared_myDevice) ?? "";
      final body = jsonEncode(jsonBody);
      final enc = encryptAESCryptoJS(body, pass);
      final json = {"feel": enc};
      return json;
    } on Exception catch (e) {
      debugPrint('Descrypt error: $e');
      return jsonBody;
    }
  }

// desencriptado
  String descryptAES(String enc) {
    final pass = this.key;
    final des = decryptAESCryptoJS(enc, pass);
    return des;
  }

// desencriptado object
  descryptAESObj(String enc) {
    final pass = this.key;
    final des = decryptAESCryptoJS(enc, pass);
    final json = jsonDecode(des);
    return json;
  }

  // Future des obj
  static Future descryptAESObj2(body) async {
    try {
      final pass = await SharedPrefs.getString(shared_myDevice) ?? "";
      final des = decryptAESCryptoJS(body['feel'], pass);
      final json = jsonDecode(des);
      return json;
    } on Exception catch (e) {
      debugPrint('Descrypt error: $e');
      return body;
    }
  }
}
