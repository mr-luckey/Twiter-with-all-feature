import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kronosss/Home/HallOfFame/Pages/glossas_screen.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

final iconsMenu = [
  "assets/icons/ic_menu_1.png",

  //"assets/icons/ic_menu_2.png",
  "assets/icons/ic_glossas.png",
  //"assets/icons/ic_menu_4.png",
  "assets/icons/ic_wallet.png",
  "assets/icons/resource_email.png",
  "assets/icons/ic_menu_5.png",
];

final StreamController<int> controllerPosition =
    StreamController<int>.broadcast();

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  final double _bottomNavBarHeight = 56; //81
  //late final ScrollListener _model;
  String _imageUser = "";

  //select button tab menu navigation
  int _selectedIndex = 0;
  List<int> listviewIndex = [0];

  // ignore: unused_field
  final _listHelpFromSpaceBottom = [SizedBox(height: 10)];

  var widgetOptions = [];

  @override
  void initState() {
    controllerPosition.stream.listen((pos) {
      _onItemTapped(pos);
    });

    _selectedIndex = 0;
    listviewIndex = [0];
    //_model = ScrollListener.initialise(_controller, _bottomNavBarHeight);
    widgetOptions = <Widget>[
      GlossasScreen(controller: _controller),
      SizedBox(),
      SizedBox(),
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ];
    super.initState();
  }

  Future<String> getImageUser() async {
    _imageUser = await SharedPrefs.getString(shared_image) ?? "";

    return _imageUser;
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      listviewIndex.add(index);
      print('POSICION HOME: $listviewIndex');
    });
    if (index == 5) {
      listviewIndex.add(index);
      await Future.delayed(Duration(milliseconds: 100));
      listviewIndex.removeLast();

      _onItemTapped(0);
    }
  }

  Future<bool> onWillPop() async {
    if (listviewIndex.length > 1) {
      listviewIndex.removeLast();
      setState(() => _selectedIndex = listviewIndex.last);
      return Future.value(false);
    } else {
      return onWillPopExit();
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPopExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      /* Utils.toast(
        context,
        'Doble TAP para salir',
        position: Utils.positionedCenter,
        duration: 3000,
      ); */
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (controllerPosition != null) controllerPosition.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            widgetOptions[_selectedIndex],
            /* ListView(
                    controller: _controller,
                    children: [
                      ...getListDataFake,
                      ..._listHelpFromSpaceBottom,
                    ],
                  ), */
            positionBottomNavBar,
          ],
        ),
      ),
    );
  }

  Widget get positionBottomNavBar => Positioned(
        left: 0,
        right: 0,
        bottom: 0, //_model.bottom,
        child: _bottomNavBar,
      );

  Widget get _bottomNavBar {
    final color = /* Color.fromARGB(120, 0, 0, 0) */ Color(0xE5000000);

    return Container(
      height: _bottomNavBarHeight - 5,
      decoration: BoxDecoration(
        color: color,
        gradient: gradientHome(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              bottonItemNav(
                text: 'Fama',
                assetImage: iconsMenu[0],
                colorIcon: _selectedIndex == 0 ? Colors.green : Colors.white,
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              bottonItemNav(
                text: 'Glossas',
                assetImage: iconsMenu[1],
                colorIcon: _selectedIndex == 1 ? Colors.green : Colors.white,
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              bottonItemNav(
                text: 'Control',
                assetImage: iconsMenu[2],
                colorIcon: _selectedIndex == 2 ? Colors.green : Colors.white,
                onPressed: () {
                  /*  Navigator.of(context)
                      .push(
                    CupertinoPageRoute(
                      builder: (context) => widgetOptions[2],
                    ),
                  )
                      .then((value) async {
                    //print("###### return to creation: $value");
                    if (value != null) {
                      _onItemTapped(5);
                      ctr_fama_list.add(1);
                    }
                  }); */
                  _onItemTapped(2);
                },
              ),
              bottonItemNav(
                text: 'Chat',
                assetImage: iconsMenu[3],
                colorIcon: _selectedIndex == 3 ? Colors.green : Colors.white,
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
              bottonItemNav(
                text: 'Perfil',
                colorIcon: _selectedIndex == 4 ? Colors.green : Colors.white,
                icon: FutureBuilder<String>(
                    future: getImageUser(),
                    initialData: "",
                    builder: (context, snapshot) {
                      return cacheImageNetwork(
                        snapshot.data,
                        size: 22.5,
                        colorBG:
                            _selectedIndex == 4 ? Colors.green : Colors.white,
                        assetError: NOT_IMAGE_PROFILE,
                      );
                    }),
                onPressed: () {
                  getImageUser();
                  _onItemTapped(4);
                },
              ),
            ],
          ),
          SizedBox(height: _bottomNavBarHeight - 56),
        ],
      ),
    );
  }

  // borrar despues del test
  List<Widget> get getListDataFake {
    List<Widget> list = [];
    for (var i = 0; i < 20; i++) {
      list.add(ListTile(title: Text('Item $i')));
    }
    return list;
  }
}

LinearGradient gradientHome([Color? color]) => LinearGradient(
      colors: [
        Colors.black87,
        Color(0xEF000000),
        color ?? /* Color.fromARGB(90, 0, 0, 0) */ Color(0xE5000000)
      ],
      stops: [1.0, 0.5, 0.25],
      begin: FractionalOffset.bottomCenter,
      end: FractionalOffset.topCenter,
    );

const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    fontFamily: 'Sans');

const styleTitles = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Sans-bold');

const styleAppBarTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 23,
    fontFamily: 'Sans-bold');

const styleMin = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 11,
    fontFamily: 'Sans');

const styleMinH = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 11,
    fontFamily: 'Sans-bold');

const style12 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    fontFamily: 'Sans');
const style13 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 13,
    fontFamily: 'Sans');
const style14 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    fontFamily: 'Sans');
const style15 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 15,
    fontFamily: 'Sans');
const style16 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    fontFamily: 'Sans');
const style17 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 17,
    fontFamily: 'Sans');
const style18 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    fontFamily: 'Sans');
const style20 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 20,
    fontFamily: 'Sans');
//  Heavy
const style13H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 13,
    fontFamily: 'Sans-bold');
const style14H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    fontFamily: 'Sans-bold');
const style15H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 15,
    fontFamily: 'Sans-bold');
const style16H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    fontFamily: 'Sans-bold');
const style17H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 17,
    fontFamily: 'Sans-bold');
const style18H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    fontFamily: 'Sans-bold');
const style20H = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: 'Sans-bold');

BoxDecoration get deco8 => BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(width: 1, color: Colors.white),
    );
BoxDecoration get deco14 => BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(14.0),
      border: Border.all(width: 1, color: Colors.white),
    );
BoxDecoration get deco20 => BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(width: 1, color: Colors.white),
    );
BoxDecoration get decoCircle => BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(9999),
      border: Border.all(width: 1, color: Colors.white),
    );

BoxDecoration get decoOutline => BoxDecoration(
      borderRadius: BorderRadius.circular(9999),
      color: Colors.black12,
      border: Border.all(width: 1, color: Colors.white),
    );

BoxDecoration decoOutlines(
        {Color? color,
        double width = 1.0,
        Color? colorBorder,
        double radius = 9999}) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color ?? Colors.black12,
      border: Border.all(width: width, color: colorBorder ?? Colors.white),
    );

BoxDecoration decoCustom({
  Color? color,
  double radius = 9999,
  BorderRadius? borderRadius,
  double borderWidth = 1.0,
  Color borderColor = Colors.white,
  List<BoxShadow>? boxShadow,
}) =>
    BoxDecoration(
        color: color ?? Colors.black,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        border: Border.all(width: borderWidth, color: borderColor));
