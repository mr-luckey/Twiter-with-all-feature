import 'dart:async';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/into_login_page.dart';
import 'package:kronosss/Home/HallOfFame/Pages/glossas_screen.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
import 'package:kronosss/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  var controller;
  get onContactEmail => null;

  //late StreamSubscription _intentDataStreamSubscription;
  //List<SharedMediaFile> _sharedFiles = [];
  // ignore: unused_field
  //String _sharedText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: themedata2,
      //theme: themedata1, /* Dark mode */
      //home: SplashMain(),
      home: GlossasScreen(
        controller: ScrollController(),
      ),
      /* routes: <String, WidgetBuilder>{
        'home': (_) => HomePage(),
        'auth': (_) => IntoLoginPage(),
      }, */
    );
  }
}

class SplashMain extends StatefulWidget {
  @override
  State<SplashMain> createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> {
  final _stream = StreamController<int>();

  _getLogged() async {
    _stream.sink.add(-1);
    var login = await SharedPrefs.getBool(shared_isLogIn) ?? false;
    debugPrint('login: $login');
    _stream.sink.add(login ? 1 : 0);
  }

  @override
  void initState() {
    super.initState();
    _getLogged();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _stream.stream,
        initialData: -1,
        builder: (c, snap) {
          if (snap.data == -1) {
            return Container(
              color: Colors.black,
              child: const SplashBackground(),
            );
          }
          if (snap.data == 0) {
            //logOut();
            return IntoLoginPage();
          } else {
            return HomePage();
          }
        });
  }
}

void logOut() async {
  await SharedPrefs.clear();
}

ThemeData get themedata2 => ThemeData(
    scaffoldBackgroundColor: Colorskronoss.background_application_dark,
    primarySwatch: Colors.green,
    brightness: Brightness.dark,
    primaryColor: Colorskronoss.primary,
    appBarTheme: AppBarTheme(
      color: Colorskronoss.primary_color_frooget.withOpacity(0.4),
    ),
    // ignore: deprecated_member_use
    accentColor: Colorskronoss.primary_color_frooget,
    iconTheme: IconThemeData(color: Colorskronoss.primary_color_frooget),
    primaryIconTheme: IconThemeData(color: Colorskronoss.primary_color_frooget),
    textTheme: TextTheme(
      headline1: style,
    ));

ThemeData get themedata1 => ThemeData(
    // Define el Brightness y Colores por defecto
    brightness: Brightness.dark,
    primaryColor: Colorskronoss.primary,
    // ignore: deprecated_member_use
    accentColor: Colorskronoss.primary_color_frooget,
    // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
    // para cabeceras, títulos, cuerpos de texto, y más.
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Avenir'),
    ));
