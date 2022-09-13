import 'dart:convert';

class HallOfFameModel {
  final int id;
  final String? name;
  final List<String?>? resource;

  HallOfFameModel({required this.id, this.name, this.resource});

  factory HallOfFameModel.fromJson(Map<String, dynamic> json) {
    return HallOfFameModel(
      id: json['id'],
      name: json['title'],
      resource: json['data'],
    );
  }

  Map<String, dynamic>? toJson(HallOfFameModel? model) {
    if (model != null) {
      return <String, dynamic>{
        'id': model.id,
        'name': model.name,
        'resource': model.resource,
      };
    } else {
      return null;
    }
  }

  static String toStrings(HallOfFameModel model) => jsonEncode({
        'id': model.id,
        'name': model.name,
        'resource': model.resource,
      });

  static Map<String, dynamic> fromStrings(String source) => jsonDecode(source);

  //----- URL
  //

  //------
}
