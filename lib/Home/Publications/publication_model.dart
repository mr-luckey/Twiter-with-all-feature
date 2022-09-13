import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kronosss/Home/Publications/file_model.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class PublicationModel {
  final String id;
  final String title;
  final String desciption;
  final String resource;
  final List<String>? resources;
  final List<FilePublicationModel>? resources_optionals;
  final List<Map>? categories;
  //final List<String>? type;
  final double price;
  //final int views;
  int stock;
  final bool up;
  final bool copyR;
  //final List<String>? monetizacion;
  //final List<String>? questions;
  final List<String>? hashtags;
  final List<String>? mentions;
  final String userCreate;
  final String imageUser;
  final String nameUser;
  int level;
  final String? ubication;
  final bool donation;
  int comment; // 0,
  int like; // 0,
  int views; // 0,
  int impresion; // 0,
  int shared; // 0,
  List? userViews; // [],
  List? userShared; // [],
  List? userLike; // [],
  int valoracion; // 0,
  int numberSave; // 0,
  int numberDowland; // 0,
  int numberOpinion; // 0,
  String pdf;
  List? listConfiguration;
  final int dateEpoch;

  PublicationModel({
    required this.id,
    this.title = "",
    this.desciption = "",
    this.resource = "",
    this.resources,
    this.resources_optionals,
    this.categories,
    //this.type,
    this.price = 0.0,
    this.comment = 0,
    this.up = false,
    this.copyR = false,
    this.stock = 1,
    //this.monetizacion,
    //this.questions,
    this.hashtags,
    this.mentions,
    this.userCreate = "",
    this.imageUser = "",
    this.nameUser = "",
    this.level = 0,
    this.ubication,
    this.donation = false,
    this.like = 0,
    this.views = 0,
    this.impresion = 0,
    this.shared = 0,
    this.userViews,
    this.userShared,
    this.userLike,
    this.valoracion = 0,
    this.numberSave = 0,
    this.numberDowland = 0,
    this.numberOpinion = 0,
    this.pdf = '',
    this.listConfiguration,
    this.dateEpoch = 0,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    final isdataUser = _isContainValue(json.toString(), 'dataUser');
    List listconf = [];
    try {
      var jj =
          json['configurations'] ?? <String, dynamic>{"n0": true, "n1": 'ok'};
      listconf = [
        jj["view"] ?? false,
        jj["info"] ?? false,
        jj["chat"] ?? false,
        jj["comment"] ?? true,
      ];
    } catch (_) {}
    //print(isdataUser);
    return PublicationModel(
      id: json['_id'],
      dateEpoch: json['createdDate'],
      title: json['title'],
      desciption: json['description'],
      categories: List.from(json['Categories'] ?? []),
      //type: json['type'] ?? [],
      price: double.parse((json['price'] ?? '0.0').toString()),
      //views: json['numberView'],
      up: json['up'],
      copyR: json['copyR'],
      stock: json['stock'],
      ubication: json['ubications'],
      /* ubication: _isContainValue(json['ubications'].toString(), 'ubications')
          ? json['ubications']
          : 'Sin Ubicación.', */
      donation: json['donation'],
      pdf: json['pdf']?['url'] ?? '',
      //monetizacion: json['monetizacion'] ?? [],
      //questions: json['questions'] ?? [],
      level: isdataUser ? json['dataUser']['level'] : 0,
      imageUser: _dataUserPhoto(json['dataUser']),
      nameUser: isdataUser
          ? (json['dataUser']['name'] + " " + json['dataUser']['lastname'])
          : "",
      hashtags: List.from(json['words'] ?? []),
      mentions: List.from(json['mentions'] ?? []),
      listConfiguration: List.from(listconf),
      userCreate: json['userCreate'],
      resource: _isContainValue(json['resource'].toString(), 'url')
          ? _resource(json['resource'])
          : "",
      resources: _getListResource(json['resource']),
      resources_optionals: _getListOptional(json['resource']),
      like: json['infos']?['like'] ?? 0,
      views: json['infos']?['views'] ?? 0,
      impresion: json['infos']?['impresion'] ?? 0,
      shared: json['infos']?['shared'] ?? 0,
      numberSave: json['infos']?['numberSave'] ?? 0,
      valoracion: json['infos']?['valoracion'] ?? 0,
      numberDowland: json['infos']?['numberDowland'] ?? 0,
      numberOpinion: json['infos']?['numberOpinion'] ?? 0,
      //userViews: json['infos']['userViews'] ?? [],
      //userShared: json['infos']['userViews'] ?? [],
      //userLike: json['infos']['userViews'] ?? [],
    );
  }

  static String _dataUserPhoto(var json) {
    try {
      var value = json?['resource']?['url'] ?? '';

      return value;
    } on Exception catch (_) {
      return '';
    }
  }

  static String _resource(var json) {
    String value = '';
    try {
      value = json?[0]?['url'] ?? '';
    } on Exception catch (_) {}
    return value;
  }

  static List<FilePublicationModel> _getListOptional(List listJson) {
    List<FilePublicationModel> list = [];
    try {
      for (var item in listJson) {
        list.add(FilePublicationModel.fromJson(item));
      }
    } on Exception catch (_) {}
    return list;
  }

  static List<String> _getListResource(List listJson) {
    List<String> list = [];
    try {
      for (var item in listJson) {
        list.add(item['url']);
      }
    } on Exception catch (_) {}
    return list;
  }

  static bool _isContainValue(String json, String key) {
    return json.contains(key);
  }

  Map<String, dynamic>? toJson(PublicationModel? model) {
    if (model != null) {
      return <String, dynamic>{
        'id': model.id,
        'title': model.title,
        'resources': model.resources,
      };
    } else {
      return null;
    }
  }

  static String toStrings(PublicationModel model) => jsonEncode({
        'id': model.id,
        'title': model.title,
        'desciption': model.desciption,
        'categories': model.categories,
        'price': model.price,
        'up': model.up,
        'copyR': model.copyR,
        'stock': model.stock,
        'ubication': model.ubication,
        'donation': model.donation,
        'level': model.level,
        'imageUser': model.imageUser,
        'nameUser': model.nameUser,
        'hashtags': model.hashtags,
        'userCreate': model.userCreate,
        'resource': model.resource,
        'resources': model.resources,
        'resources_optionals': model.resources_optionals,
        'like': model.like,
        'views': model.views,
        'impresion': model.impresion,
        'shared': model.shared,
        'numberSave': model.numberSave,
        'valoracion': model.valoracion,
        'numberDowland': model.numberDowland,
        'numberOpinion': model.numberOpinion,
      });

  static Map<String, dynamic> fromStrings(String source) => jsonDecode(source);

  //----- URL
  // data fake publications
  static Future<List<PublicationModel>> getPublications(
      {int page = 0, String idCategories = ''}) async {
    int i = -1;
    Map<String, dynamic>? it;
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);
      final aux = idCategories.isEmpty ? '' : '/$idCategories';

      var _url = Uri.parse(Constants.url_publications + aux + "?skip=$page");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      i = -1;
      for (var item in body) {
        i++;
        it = item;
        var model = PublicationModel.fromJson(item);
        list.add(model);
        //print(item);
      }
      //print(body);
      return list;
    } catch (_) {
      print('se crasheo en $i => $it');
      return [];
    }
  }

  // data fake publications
  static Future<PublicationModel?> getPublicationsForID(
      {String id = ""}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publications + "/$id");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);

      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        list.add(model);
      }
      //print(body);
      return list[0];
    } catch (_) {
      return null;
    }
  }

  // data real publications for categories
  static Future<List<PublicationModel>> getPublicationForCategories(
      {String idCategory = '',
      String typeLupa = '',
      String value = '',
      int page = 0}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      // al enpoint general de "publications"
      final category = idCategory.isNotEmpty ? '/$idCategory' : '';
      final aux1 = 'type=$typeLupa';
      final aux2 = 'value=$value';
      final aux = '?$aux1&$aux2&skip=$page';

      var _url =
          Uri.parse(Constants.url_publicationsForCategories + category + aux);

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        list.add(model);
      }

      return list;
    } catch (_) {
      return [];
    }
  }

  // data real publications for categories and id User
  static Future<List<PublicationModel>> getPublicationForUserID(
      {String idCategory = "", String idUser = ""}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publicationsUser + "/$idUser");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }

  // data real publications for categories and id User
  static Future<List<PublicationModel>> fromCategoriesAndUserID(
      {String idCategory = "", String idUser = "", int page = 0}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);
      final skip = idUser.isEmpty ? '?skip=$page' : '&skip=$page';
      final aux = "$idCategory$idUser$skip";

      var _url = Uri.parse(Constants.url_profilePublications + aux);

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        //for (var i = 0; i < 10; i++) // para testear
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }

  // data publication for text search
  static Future<List<PublicationModel>> getListPublicationForText(
      {String query = ""}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url =
          Uri.parse(Constants.url_publicationsSearch + "?termino=$query");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }

  static Future<Response?> postPublications(var body) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publications);

      final response =
          await ApiServices.POST(url: _url, header: headers, bodyy: body);
      //final resp = jsonEncode(response);

      return response;
    } catch (_) {
      return null;
    }
  }

  // get publication LIKE, FLOW, shared
  static Future<Response?> getInfoPublications(String id,
      {bool debugResp = false}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_info + '/$id');

      final response = await ApiServices.GET(url: _url, header: headers);
      //final resp = jsonEncode(response);
      if (debugResp) debugPrint(response?.body ?? 'okokokokok');

      return response;
    } catch (_) {
      return null;
    }
  }

  // get publication LIKE, FLOW, shared
  static Future<Response?> getInfoFilterPublications(String id,
      {required String filter, int page = 0, bool debugResp = false}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      /*  final query = {
        "filter": filter,
        "skip": page,
      }; */

      //var _url = Uri.http(Constants.urlBase, '/infoFilter/$id', query);
      final _url = Uri.parse(
          Constants.url_infoFilter + '/$id?filter=$filter&skip=$page');

      final response = await ApiServices.GET(url: _url, header: headers);
      //final resp = jsonEncode(response);
      if (debugResp) debugPrint(response?.body ?? 'okokokokok');

      return response;
    } catch (_) {
      return null;
    }
  }

  // post publication LIKE, FLOW, shared
  static Future<Response?> infoPublications(var body, String id,
      {bool debugResp = false}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_info + '/$id');

      final response =
          await ApiServices.POST(url: _url, header: headers, bodyy: body);
      //final resp = jsonEncode(response);
      if (debugResp) print(response?.body ?? 'okokokokok');

      return response;
    } catch (_) {
      return null;
    }
  }

  // update publication to UP
  static Future<Response?> updatePublications(var body, String id) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publications + '/$id');

      final response =
          await ApiServices.PUT(url: _url, header: headers, bodyy: body);
      //final resp = jsonEncode(response);

      return response;
    } catch (_) {
      return null;
    }
  }

  // data UP
  static Future<List<PublicationModel>> getUP({int page = 0}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_up + "?skip=$page");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<PublicationModel> list = [];
      for (var item in body) {
        var model = PublicationModel.fromJson(item);
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      return [];
    }
  }

  // DELETE publications
  static Future<bool> deletePublication(String id) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publications + "/$id");

      final response = await ApiServices.DELETE(url: _url, header: headers);
      final code = response?.statusCode ?? 404;
      final isDelete = code == 200 || code == 201;
      //final body = ApiServices.getBody(response!);
      return isDelete;
    } catch (_) {
      return false;
    }
  }

  // DELETE publications
  static Future<bool> enabledDataPublication(
      String id, Map<String, dynamic> body) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publications + "/$id");

      final response =
          await ApiServices.PUT(url: _url, header: headers, bodyy: body);
      final code = response?.statusCode ?? 404;
      final isDelete = code == 200 || code == 201;
      //final body = ApiServices.getBody(response!);
      //debugPrint("XXXXX :$id: $body");
      //debugPrint("XXXXX :$id: ${response?.body ?? 'null'}");
      return isDelete;
    } catch (_) {
      return false;
    }
  }

  // DELETE publications
  static Future<bool> resourceEditPublication(
      String id, Map<String, dynamic> body) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      var _url = Uri.parse(Constants.url_publication_resource + "/$id");

      final response =
          await ApiServices.PUT(url: _url, header: headers, bodyy: body);
      final code = response?.statusCode ?? 404;
      final isDelete = code == 200 || code == 201;
      //final body = ApiServices.getBody(response!);
      return isDelete;
    } catch (_) {
      return false;
    }
  }

//------

}
