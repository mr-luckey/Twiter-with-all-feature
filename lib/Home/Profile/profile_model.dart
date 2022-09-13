import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

enum privacy {
  public, // first
  justMe,
  private, // last
}

class ProfileModel {
  String name;
  int level;
  String biography;
  String slogan;
  final String email;
  final String phone;
  final String birthday;
  String image;
  final String imageBanner; // no implement
  final int code;
  String nickname;
  String web;
  String ubication;
  String tokenFirebase;
  List? categories;
  List? externals;
  double latitude;
  double longitude;
  int privacylvl;
  bool official;
  int follow;
  int followed;

  ProfileModel({
    this.name = '',
    this.level = 0,
    this.biography = '',
    this.slogan = '',
    this.email = '',
    this.phone = '',
    this.birthday = '',
    this.image = '',
    this.imageBanner = '',
    this.code = 0,
    this.nickname = '',
    this.web = '',
    this.categories,
    this.externals,
    this.tokenFirebase = '',
    this.ubication = '',
    this.latitude = 0,
    this.longitude = 0,
    this.privacylvl = 0,
    this.official = false,
    this.follow = 0,
    this.followed = 0,
  });

  static Map<String, dynamic> toJson(ProfileModel model) {
    return {
      'name': model.name,
      'level': model.level,
      'biography': model.biography,
      'slogan': model.slogan,
      'email': model.email,
      'phone': model.phone,
      'birthday': model.birthday,
      'image': model.image,
      'imageBanner': model.imageBanner,
      'code': model.code,
      'nickname': model.nickname,
      'web': model.web,
      'categories': model.categories,
      'externals': model.externals,
      'tokenFirebase': model.tokenFirebase,
      'ubication': model.ubication,
      'latitude': model.latitude,
      'longitude': model.longitude,
      'privacylvl': model.privacylvl,
      'official': model.official,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final List? conf = json['configurations'];
    String lat = '0.0', lon = '0.0', ubication = '';
    int privacylvl = 0;

    if (conf != null && conf.isNotEmpty) {
      lat = conf[0]?['latitude'].toString() ?? '0.0';
      lon = conf[0]?['longitude'].toString() ?? '0.0';
      ubication = conf[0]?['ubication'] ?? '';
      privacylvl = conf[0]?['privacylvl'] ?? 0;
    }
    if (conf != null && conf.length > 1) {
      privacylvl = conf[1]?['privacylvl'] ?? 0;
    }

    if (!json.containsKey('cover')) {
      return ProfileModel(
        name: json['name'] ?? '',
        level: json['level'] ?? 0,
        biography: json['biography'] ?? '',
        slogan: json['slogan'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        birthday: json['birthday'] ?? '',
        image: json['resource']?['url'] ?? '',
        code: json['code'] ?? 0,
        nickname: json['nickname'] ?? '',
        web: json['web'] ?? '',
        imageBanner: '',
        categories: json['categories'] ?? [],
        externals: json['externals'] ?? [],
        ubication: ubication,
        latitude: double.parse(lat),
        longitude: double.parse(lon),
        privacylvl: privacylvl,
        official: json['official'] ?? false,
      );
    }
    return ProfileModel(
      name: json['name'] ?? '',
      level: json['level'] ?? 0,
      biography: json['biography'] ?? '',
      slogan: json['slogan'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthday: json['birthday'] ?? '',
      image: json['resource']?['url'] ?? '',
      code: json['code'] ?? 0,
      nickname: json['nickname'] ?? '',
      web: json['web'] ?? '',
      imageBanner: json['cover']?['url'] ?? '',
      categories: json['categories'] ?? [],
      externals: json['externals'] ?? [],
      ubication: ubication,
      latitude: double.parse(lat),
      longitude: double.parse(lon),
      privacylvl: privacylvl,
      official: json['official'] ?? false,
    );
  }

  static Future<bool> getFollowToEmail(String email) async {
    bool respContinue = false;
    final _myEmail = await SharedPrefs.getString(shared_email) ?? '';
    /* List<ProfileModel> listFolloweds = [];
    listFolloweds = await getFolloweds(email);

    // ------
    for (var item in listFolloweds) {
      if (item.email == _myEmail) {
        respContinue = true;
        break;
      }
    } */
    List<String> listf = [];
    listf = await getinfoUserFlow(email);
    for (var item in listf) {
      if (item == _myEmail) {
        respContinue = true;
        break;
      }
    }
    return respContinue;
  }

  // send notification push (manual)
  static Future<void> sendNotification({
    required String tokenSend,
    required String title,
    required String content,
    Map<String, dynamic>? data,
  }) async {
    try {
      await ApiServices.sendMenssageFirebaseCloud(
        tokenSend: tokenSend,
        authorization: TOKEN_AUTH_CLOUD,
        title: title,
        content: content,
        data: data,
      );
    } on Exception catch (_) {
      debugPrint('se crasheo sendNotification profile');
    }
  }

  // perfiles de seguidos
  static Future<List<String>> getinfoUserFlow(
      [String idUser = '', int page = -1]) async {
    List<String> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';
      final String auxPAge = page < 0 ? '' : '?skip=$page';

      Uri url = Uri.parse(Constants.url_user_profile_info + id + auxPAge);
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          List _list = items['userFlow'] ?? [];
          list = _list.cast<String>();
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

  // perfiles de seguidos
  static Future<List<ProfileModel>> getFolloweds(
      [String idUser = '', int page = 0]) async {
    List<ProfileModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.url_follow + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var json in items) {
            var model = ProfileModel(
              name: (json['name'] + ' ' + json['lastName']).toString().trim(),
              image: json['resource']?['url'] ?? '',
              email: json['email'] ?? '',
              nickname: json['nickname'] ?? '',
            );
            list.add(model);
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

  // perfiles de seguidos
  static Future<List<ProfileModel>> getFollowers(
      [String idUser = '', int page = 0]) async {
    List<ProfileModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.url_followers + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var json in items) {
            var model = ProfileModel(
              name: (json['name'] + ' ' + json['lastName']).toString().trim(),
              image: json['resource']?['url'] ?? '',
              email: json['email'] ?? '',
              nickname: json['nickname'] ?? '',
            );
            list.add(model);
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

  // perfiles seguir - dejar de seguir
  static Future<void> putFollow(String idUser,
      [bool goFollow = true, String tokenSend = '']) async {
    final token = await SharedPrefs.getString(shared_token) ?? '';
    final header = ApiServices.HEADERS_AUTH(token);

    final body = {"flow": goFollow ? 1 : -1};

    Uri url = Uri.parse(Constants.url_user_profile_info + '/$idUser');
    final response =
        await ApiServices.POST(url: url, header: header, bodyy: body);
    if (response != null) {
      /* int code = response.statusCode;
      if (code == 200 || code == 201 && tokenSend.isNotEmpty) {
        await sendNotification(
            tokenSend: tokenSend,
            title: 'Nuevo seguidor',
            content: 'Tienes un nuevo seguidor');
      } */
      //debugPrint('resp: ${response.body}');
    } else {
      print('FALLO: null');
    }
  }

// publicaciones de me gusta
  static Future<List<PublicationModel>> getLikePublications(
      [String idUser = '', int page = 0]) async {
    List<PublicationModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.url_mylikes + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var item in items) {
            list.add(PublicationModel.fromJson(item));
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

  // publicaciones de productos
  static Future<List<PublicationModel>> getProductPublications(
      [String idUser = '', int page = 0]) async {
    List<PublicationModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.url_myProduct + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var item in items) {
            list.add(PublicationModel.fromJson(item));
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

  // publicaciones de donaciones
  static Future<List<PublicationModel>> getDonatePublications(
      [String idUser = '', int page = 0]) async {
    List<PublicationModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.url_myDonate + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var item in items) {
            list.add(PublicationModel.fromJson(item));
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

// publicaiones guardadas
  static Future<List<PublicationModel>> getSavePublications(
      [String idUser = '', int page = 0]) async {
    List<PublicationModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      final String id = idUser.isEmpty ? '' : '/$idUser';

      Uri url = Uri.parse(Constants.ur_save_publications + id + '?skip=$page');
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var items = ApiServices.getBody(response);
          for (var item in items) {
            list.add(PublicationModel.fromJson(item));
          }
          return list;
        } else {
          print('FALLO: code estatus $code');
          return list;
        }
      } else {
        print('FALLO: null');
        return list;
      }
    } on Exception catch (_) {
      print('se crasheo');
      return list;
    }
  }

// publicaciones del usuario
  static Future getPublicationsUser() async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);

      Uri url = Uri.parse(Constants.url_publicationsUser);
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          print('OK\n resp: ${response.body}');
        } else {
          print('FALLO: code estatus $code');
        }
      } else {
        print('FALLO: null');
      }
    } on Exception catch (_) {}
  }

  static Future<List<ProfileModel>> getUserAll(
      {int page = -1, int limit = 10, bool debugResp = false}) async {
    List<ProfileModel> list = [];
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);
      final aux = page >= 0 ? '?skip=$page' : '';
      final aux2 =
          limit >= 0 ? (aux.isEmpty ? '?limit=$limit' : '&limit=$limit') : '';

      var _url = Uri.parse(Constants.url_users + aux + aux2);

      final response = await ApiServices.GET(url: _url, header: headers);

      if (debugResp) print(response?.body ?? 'okokokokok');
      final items = ApiServices.getBody(response!);
      for (var json in items) {
        var model = ProfileModel(
          email: json['email'] ?? '',
          name: (json['name'] + " " + json['lastname']).toString().trim(),
          nickname: json['nickname'] ?? '',
          image: json?['resource']?['url'] ?? '',
        );
        list.add(model);
      }

      return list;
    } catch (_) {
      return list;
    }
  }

  // mi perfil - info
  static Future<ProfileModel?> getProfile({String email = ''}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);
      var aux = email.isNotEmpty ? '/$email' : '';

      Uri url = Uri.parse(Constants.url_user_profile_edits + aux);
      final response = await ApiServices.GET(url: url, header: header);

      if (response != null) {
        int code = response.statusCode;
        if (code == 200 || code == 201) {
          var json = ApiServices.getBody(response);
          return ProfileModel.fromJson(json);
        } else {
          print('FALLO, code: $code');
          return null;
        }
      } else {
        print('FALLO: null');
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }

  // mi perfil - info
  static Future<Response?> editProfile(Map<String, dynamic> body,
      {int timeOut = 80}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);

      Uri url = Uri.parse(Constants.url_user_profile_edits);
      final response = await ApiServices.PUT(
          url: url, header: header, bodyy: body, timeOut: timeOut);

      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  // mi perfil - info
  static Future<Response?> editProfile2(var body, {int timeOut = 80}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);

      Uri url = Uri.parse(Constants.url_user_profile_edits);
      final response = await ApiServices.PUT(
          url: url, header: header, bodyy: body, timeOut: timeOut);

      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  // mi perfil - info
  static Future<List<Object?>> getNotifications({int timeOut = 80}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? '';
      final header = ApiServices.HEADERS_AUTH(token);

      Uri url = Uri.parse(Constants.url_user_notifications);
      final response =
          await ApiServices.GET(url: url, header: header, timeout: timeOut);

      return ApiServices.getBody(response!);
    } on Exception catch (_) {
      return [];
    }
  }
}
