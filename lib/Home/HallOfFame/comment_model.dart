import 'package:http/http.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class CommentModel /* extends Equatable */ {
  final String id;
  final int index;
  final String message;
  final String userEmail;
  final String userName;
  final String file;
  final String imageUser;
  final int epoch;
  final CommentModel? thread;

  CommentModel(
      {this.id = "",
      this.index = -1,
      this.message = "",
      this.userEmail = "",
      this.userName = "",
      this.imageUser = "",
      this.file = '',
      this.epoch = 0,
      this.thread});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    print(json);

    var datauser = json['dataUser'];

    return CommentModel(
      id: json['idAsociado'] ?? '',
      message: json['opinion'] ?? '',
      userEmail: json['idUser'] ?? '',
      userName: datauser['name'] ?? '' + " " + datauser['lastname'] ?? '',
      imageUser: datauser['resource']?['url'] ?? '',
      epoch: json['createdDate'] ?? '',
    );
  }

  static Future<List<CommentModel>> getComment(String idPublication,
      {String? query}) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      final aux = query ?? '';

      var _url = Uri.parse(Constants.url_comment + "/$idPublication$aux");

      final response = await ApiServices.GET(url: _url, header: headers);
      final body = ApiServices.getBody(response!);
      List<CommentModel> list = [];
      for (var item in body) {
        var model = CommentModel.fromJson(item);
        list.add(model);
      }
      //print(body);
      return list;
    } catch (_) {
      print('se crasheo');
      return [];
    }
  }

  // post create comments
  static Future<Response?> sendComment(CommentModel model) async {
    try {
      final token = await SharedPrefs.getString(shared_token) ?? "";
      final headers = await ApiServices.HEADERS_AUTH(token);

      final body = {"idAsociado": model.id, "opinion": model.message};
      //print(headers);

      var _url = Uri.parse(Constants.url_comment);

      final response =
          await ApiServices.POST(url: _url, bodyy: body, header: headers);
      print(_url.path);
      return response;
    } catch (_) {
      return null;
    }
  }

//data fake
  static List<CommentModel> getListFake() {
    List<CommentModel> list = [];
    // ignore: unused_local_variable
    var date = DateTime.fromMillisecondsSinceEpoch(6000 * 1000);

    list.add(CommentModel(
        id: "1234zxcasd456",
        index: 0,
        message: "Me encanta esta imagen.",
        userEmail: "juango@gmail.com",
        imageUser: "https://source.unsplash.com/random?sig=1",
        file: 'https://source.unsplash.com/random?sig=50',
        epoch: 132456));
    list.add(CommentModel(
        id: "1234zxcasd456",
        index: 1,
        message: "Igual a mi.",
        userEmail: "jesus12@gmail.com",
        imageUser: "https://source.unsplash.com/random?sig=2",
        epoch: 132456));
    list.add(CommentModel(
        id: "1234zxcasd456",
        index: 2,
        message: "verdad?.",
        userEmail: "juango@gmail.com",
        imageUser: "https://source.unsplash.com/random?sig=1",
        epoch: 132456));

    return list;
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object?> get props => throw UnimplementedError();
}
