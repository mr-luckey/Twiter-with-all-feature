class CompareExtentionsFiles {
  static final List<String> extImage = ['png', 'jpg', 'jpeg', 'gif'];
  static final List<String> extAudio = ['mp3', 'aac'];
  static final List<String> extVideo = ['mp4', 'mkv', 'avi'];
  static final List<String> extCustom = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'mp3',
    'aac',
    'mp4',
    'mkv',
    'avi'
  ];

  static bool isImage(String src) {
    return _compareList(src, extImage);
  }

  static bool isAudio(String src) {
    return _compareList(src, extAudio);
  }

  static bool isVideo(String src) {
    return _compareList(src, extVideo);
  }

  static bool _compareList(String value, List<String> list) {
    bool resp = false;
    for (var item in list) {
      resp = value.endsWith(item);
      if (resp) break;
    }
    return resp;
  }
}
