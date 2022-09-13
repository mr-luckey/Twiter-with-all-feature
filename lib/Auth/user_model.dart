import 'dart:convert';

import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class UserModel {
  final int? id;
  final String email;
  final String name;
  String image;
  String imageBanner;
  final String token;

  final String rol;
  final String? phone;
  final bool verificated;
  final String nickname;

  UserModel({
    this.id,
    required this.email,
    this.name = "",
    this.image = "",
    this.imageBanner = "",
    this.token = "",
    this.rol = "",
    this.phone,
    this.verificated = false,
    this.nickname = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['data']['email'],
      name: json['data']['name'] + " " + json['data']['lastname'],
      image: json['data']?['resource']?['url'] ?? '',
      token: json['token'],
      phone: json['data']['phone'],
      rol: json['data']['rol'],
      verificated: json['data']['verificated'],
    );
  }

  factory UserModel.fromModelString(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      image: json['image'],
      token: json['token'],
      phone: json['phone'],
      rol: json['rol'],
      verificated: json['verificated'],
    );
  }

  Map<String, dynamic>? toJson(UserModel? model) {
    if (model != null) {
      return <String, dynamic>{
        'id': model.id,
        'name': model.name,
        'email': model.email,
        'image': model.image,
        'token': model.token,
        'phone': model.phone,
        'rol': model.rol,
        'verificated': model.verificated,
      };
    } else {
      return null;
    }
  }

  static String toStrings(UserModel model) => jsonEncode({
        'id': model.id,
        'name': model.name,
        'email': model.email,
        'image': model.image,
        'token': model.token,
        'phone': model.phone,
        'rol': model.rol,
        'verificated': model.verificated,
      });

  static Map<String, dynamic> fromStrings(String source) => jsonDecode(source);

  static Future<UserModel?> getUserFromEmail(String email) async {
    try {
      final _user = await SharedPrefs.getString(shared_user) ?? '';
      final _model = UserModel.fromStrings(_user);
      final _token = _model['token'];

      final headers = await ApiServices.HEADERS_AUTH(_token);

      var _url = Uri.parse(Constants.url_user_profile_sharedUser + "/$email");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      final json = body[0];
      //print(json);
      final model = UserModel(
        email: json['email'],
        name: json['name'] + json['lastname'],
        image: json['resource']['url'],
        rol: json['rol'],
      );

      return model;
    } catch (_) {
      return null;
    }
  }
}
