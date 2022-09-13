import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WalletPaymentModel {
  final double cuantity;
  final double block;
  final String id;
  final String userId;
  final String code;
  //final int createdDate;
  //final int updatedDate;
  //final int deletedDate;

  WalletPaymentModel(
      {this.cuantity = 0.0,
      this.block = 0.0,
      this.id = '',
      this.code = '',
      this.userId = ''});

  factory WalletPaymentModel.fromJson(Map<String, dynamic> json) {
    return WalletPaymentModel(
      cuantity: double.parse(json['cuantity'].toString()),
      block: double.parse(json['block'].toString()),
      id: json['_id'],
      code: json['code'],
      userId: json['users'],
    );
  }

  Map<String, dynamic> toJson(WalletPaymentModel model) {
    return <String, dynamic>{
      'id': model.id,
      'cuantity': model.cuantity,
      'block': model.block,
      'code': model.code,
      'users': model.userId,
    };
  }

  static Future<Response?> getWallet() async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_accounts);
      final response = await ApiServices.GET(url: _url, header: headers);
      //final json = ApiServices.getBody(response!);
      //print(json);
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<Response?> sendPaypment(final body,
      [String method = 'paypal']) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);
      late Uri _url;

      switch (method.toLowerCase().trim()) {
        case 'paypal':
          var _urlPaypal = Uri.parse(Constants.url_paypalpays);
          _url = _urlPaypal;
          break;
        case 'stripe':
          var _urlStripe = Uri.parse(Constants.url_stripepays);
          _url = _urlStripe;
          break;
        case 'dracmas':
          var _url_operations = Uri.parse(Constants.url_operations);
          _url = _url_operations;
          break;
        default:
          var _urlPaypal = Uri.parse(Constants.url_paypalpays);
          _url = _urlPaypal;
      }

      final response =
          await ApiServices.POST(url: _url, bodyy: body, header: headers);
      final json = ApiServices.getBody(response!);
      print(json);
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<Response?> removeCoins(double ammount) async {
    var body = {"cuantity", ammount};

    final token = await SharedPrefs.getString(shared_token) ?? "";
    final headers = await ApiServices.HEADERS_AUTH(token);
    final _url = Uri.parse(Constants.url_removeCoins);

    final response =
        await ApiServices.POST(url: _url, bodyy: body, header: headers);

    debugPrint(response?.body ?? ' remove coins null');
    debugPrint('Code: ${response?.statusCode ?? 0}');
    return response;
  }

  // stripe payment
  static Future<Response?> getTokenStripe(Map<String, dynamic>? body) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);
      //var _url = Uri.http('192.99.167.185:5000', 'stripepays', params);

      var _url = Uri.parse(Constants.url_stripeIntent);
      final response = await ApiServices.POST(
        url: _url,
        header: headers,
        bodyy: body,
      );

      return response;
    } catch (e) {
      return null;
    }
  }
}
