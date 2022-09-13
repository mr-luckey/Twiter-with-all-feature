class FilePublicationModel {
  final String title;
  final String description;
  final String url;
  final String ext;
  final String? dimention;
  final String? dimentionOrigin;
  final int width;
  final int height;

  FilePublicationModel(
      {this.title = "",
      this.description = "",
      required this.url,
      required this.ext,
      this.width = 0,
      this.height = 0,
      this.dimention,
      this.dimentionOrigin});

  factory FilePublicationModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    return FilePublicationModel(
      url: json['url'] ?? '',
      ext: json['ext'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dimentionOrigin: '${json['resolution']}',
      dimention: '${json['resolutionConver']}',
      width: json['resolutionConver']?['width'] ?? 0,
      height: json['resolutionConver']?['height'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(FilePublicationModel model) {
    return <String, dynamic>{
      'url': model.url,
      'ext': model.ext,
      'title': model.title,
      'description': model.description,
      'dimention': model.dimention,
      'dimentionOrigin': model.dimentionOrigin,
    };
  }
}
