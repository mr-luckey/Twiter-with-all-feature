import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:kronosss/Auth/user_model.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

enum TypeWidgetCategories {
  text,
  select,
  number,
  text_edit,
  list,
}

class CategoriesModel {
  final String id;
  final String name;
  final String icon;
  final String decription;
  Widget? iconWidget;
  String typeCategories;
  Object? infoExtra;
  List? subCategories;

  CategoriesModel({
    required this.id,
    required this.name,
    this.icon = '',
    this.iconWidget,
    this.typeCategories = '',
    this.decription = '',
    this.subCategories,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['_id'],
      name: json['name'],
      icon: json['resource']['url'],
      decription: json['description'] ?? '',
      subCategories: json['subCategories'] ?? [],
    );
  }

  static CategoriesModel fromJsonProfile(Map<String, dynamic> json) {
    //print('type categories: ${json['active']}');
    return CategoriesModel(
      id: json['_id'],
      name: json['name'],
      icon: json['resource']['url'],
      decription: json['description'] ?? '',
      subCategories: json['subCategories'] ?? [],
      typeCategories: (json['active'] ?? false) ? 'profile' : 'normal',
    );
  }

  Map<String, dynamic>? toJson(CategoriesModel? model) {
    if (model != null) {
      return <String, dynamic>{
        'id': model.id,
        'name': model.name,
        'icon': model.icon,
        'subCategories': model.subCategories,
        'description': model.decription,
      };
    } else {
      return null;
    }
  }

  static String toStrings(CategoriesModel model) => jsonEncode({
        'id': model.id,
        'name': model.name,
        'icon': model.icon,
      });

  static Map<String, dynamic> fromStrings(String source) => jsonDecode(source);

  //----- URL
  // data get categoires
  static Future<List<CategoriesModel>> getListCategories(
      {bool typeNormal = false}) async {
    try {
      final user = await SharedPrefs.getString(shared_user) ?? '';
      final model = UserModel.fromStrings(user);
      final token = model['token'];

      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_categories);

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<CategoriesModel> list = [];
      for (var item in body) {
        var model = CategoriesModel.fromJson(item);
        if (typeNormal) model.typeCategories = 'normal';
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }

  // data get categoires for id
  static Future<Map<String, dynamic>?> getCategoriesForId(String id) async {
    try {
      final user = await SharedPrefs.getString(shared_user) ?? '';
      final model = UserModel.fromStrings(user);
      final token = model['token'];

      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_categories + '/$id');

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      //debugPrint('$body');
      return body[0];
    } catch (_) {
      debugPrint('Se crashea');
      return null;
    }
  }

  // data fake categoires
  static Future<List<CategoriesModel>> getListCategoriesProfile() async {
    try {
      final user = await SharedPrefs.getString(shared_user) ?? '';
      final model = UserModel.fromStrings(user);
      final token = model['token'];

      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_categoriesGeneral);

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<CategoriesModel> list = [];
      for (var item in body) {
        var model = CategoriesModel.fromJsonProfile(item);
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }
}//
