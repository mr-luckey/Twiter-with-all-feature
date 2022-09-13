import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronosss/Home/HallOfFame/reel_screen.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';

class HofReelScreen extends StatefulWidget {
  HofReelScreen(
      {required this.listPublications, this.index = 0, this.page = 0});

  final List<PublicationModel> listPublications;
  final int index;
  final int page;

  @override
  _HofReelScreenState createState() => _HofReelScreenState();
}

class _HofReelScreenState extends State<HofReelScreen> {
  PageController controller = PageController(initialPage: 0);
  // ignore: unused_field
  int _indexCategory = 0;
  int PAGE = 0;
  List<PublicationModel> listPublications = [];
  List<Widget> _listItem = [];

  @override
  void initState() {
    controller = PageController(initialPage: widget.index);
    setState(() => _indexCategory = widget.index);
    super.initState();
    _initialListData();
  }

  void _initialListData() {
    listPublications = widget.listPublications;
    PAGE = widget.page;

    if (listPublications.length > 0) {
      for (int i = 0; i < listPublications.length; i++) {
        var item = Reel2Screen(listPublications[i]);
        _listItem.add(item);
      }
    } else {
      _getListPublications(PAGE);
    }
  }

  Future<void> _getListPublications(int page) async {
    List<PublicationModel> list = [];
    list = await PublicationModel.getPublications(page: page);
    listPublications.addAll(list);
    setState(() {});
    if (list.length > 0) {
      debugPrint('--------- LOADING PAGE: $PAGE ----------');
      PAGE++;
      await Future.delayed(Duration(milliseconds: 1500));
      _getListPublications(PAGE);
    } else {
      debugPrint('--------- END PAGE: $PAGE ----------/');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //final size = MediaQuery.of(context).size;
    //final aspect = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Container(
        child: PageView(
          scrollDirection: Axis.vertical,
          children: _listItem,
          controller: controller,
        ),
      ),
    );
  }
}
