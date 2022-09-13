import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:kronosss/Auth/login/code_login_page.dart';
import 'package:kronosss/Common/webview_page.dart';
import 'package:kronosss/DialogSheet/Responsivewidget.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';
import 'package:kronosss/Auth/into_login_page.dart';
import 'package:kronosss/Auth/user_model.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _ctr_email = TextEditingController();
  final _ctr_pass = TextEditingController();

  bool _obscureTextPass = true;

  final streamLoading = StreamController<int>();

  @override
  void initState() {
    super.initState();
    _ctr_email.text = "";
    _ctr_pass.text = "";
  }

  @override
  void dispose() {
    _ctr_pass.dispose();
    _ctr_email.dispose();
    streamLoading.close();
    super.dispose();
  }

  funSendData() {
    if (_ctr_email.text.isNotEmpty && _ctr_pass.text.isNotEmpty) {
      validate(context);
    } else {
      DialogsUtils(
        context,
        title: 'Faltan Datos de inicio de sesión.',
        textContent: 'El correo y la contraseña son obligatorios',
      ).showMessageError();
      print("es obligatorio");
    }
  }

  funOpenHome(Map<String, dynamic> resp) async {
    var user = UserModel.fromJson(resp);
    var strUser = UserModel.toStrings(user);

    SharedPrefs.setBool(shared_isLogIn, true);
    SharedPrefs.setString(shared_user, strUser);
    SharedPrefs.setString(shared_token, user.token);
    SharedPrefs.setString(shared_email, user.email);
    SharedPrefs.setString(shared_image, /* userAuth?.photoURL ?? */ user.image);

    //Navigator.of(context).pop();
    await Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (context) => HomePage()));
  }

  funTerm() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WebViewPage(url: URL_TERM_USE)));
  }

  funPrivacy() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WebViewPage(url: URL_PRIVACY)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ResponsiveWidget(
      desktopScreen: WillPopScope(
        onWillPop: () async {
          print("atrás en login");
          await Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => IntoLoginPage()));
          return false;
        },
        child: Scaffold(
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                height: size.height - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logokronoss(),
                    SizedBox(height: 30),
                    Container(
                      height: 70,
                      child: Text(
                        'Introduce \ne-mail o usuario y contraseña',
                        style: style.copyWith(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    editText(
                      controller: _ctr_email,
                      hint: 'E-mail o nombre de usuario',
                      assets: 'assets/icons/resource_email.png',
                    ),
                    editText(
                      controller: _ctr_pass,
                      hint: 'Contraseña',
                      assets: 'assets/icons/key.png',
                      onObscureText: () =>
                          setState(() => _obscureTextPass = !_obscureTextPass),
                      obscureText: _obscureTextPass,
                    ),
                    // SizedBox(height: 80),
                    Container(
                      height: 30,
                      child: Text(
                        'Accede',
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder<int>(
                        stream: streamLoading.stream,
                        initialData: 0,
                        builder: (context, snap) {
                          Widget? value = snap.data == -1
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator.adaptive())
                              : null;

                          return buttonGeneric(
                            'Enviar',
                            width: double.maxFinite,
                            child: value,
                            onPressed: funSendData,
                          );
                        }),
                    SizedBox(),
                    Spacer(),
                    // term of use
                    textInfoLegal(
                        onPressedPrivacy: funPrivacy, onPressedTerm: funTerm),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      mobileScreen: WillPopScope(
        onWillPop: () async {
          print("atrás en login");
          await Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => IntoLoginPage()));
          return false;
        },
        child: Scaffold(
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                height: size.height - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logokronoss(),
                    SizedBox(height: 30),
                    Container(
                      height: 70,
                      child: Text(
                        'Introduce \ne-mail o usuario y contraseña',
                        style: style.copyWith(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    editText(
                      controller: _ctr_email,
                      hint: 'E-mail o nombre de usuario',
                      assets: 'assets/icons/resource_email.png',
                    ),
                    editText(
                      controller: _ctr_pass,
                      hint: 'Contraseña',
                      assets: 'assets/icons/key.png',
                      onObscureText: () =>
                          setState(() => _obscureTextPass = !_obscureTextPass),
                      obscureText: _obscureTextPass,
                    ),
                    // SizedBox(height: 80),
                    Container(
                      height: 30,
                      child: Text(
                        'Accede',
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder<int>(
                        stream: streamLoading.stream,
                        initialData: 0,
                        builder: (context, snap) {
                          Widget? value = snap.data == -1
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator.adaptive())
                              : null;

                          return buttonGeneric(
                            'Enviar',
                            width: double.maxFinite,
                            child: value,
                            onPressed: funSendData,
                          );
                        }),
                    SizedBox(),
                    Spacer(),
                    // term of use
                    Expanded(
                      child: textInfoLegal(
                          onPressedPrivacy: funPrivacy, onPressedTerm: funTerm),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validate(BuildContext context) async {
    streamLoading.sink.add(-1);
    final tokenDevice = await SharedPrefs.getString(shared_myDevice) ??
        "token${getRandString(29)}";
    var body = {
      "email": _ctr_email.text.trim(),
      "password": _ctr_pass.text,
      "token": tokenDevice,
    };

    var _url = Uri.parse(Constants.url_login);

    ApiServices.POST(
      url: _url,
      bodyy: body,
    ).then(
      (response) async {
        streamLoading.sink.add(0);
        // ignore: unnecessary_null_comparison
        if (response != null) {
          var resp = ApiServices.getBody(response);
          var state = resp["ok"] ?? false;
          var msg = resp["message"];

          print('$state');
          if (state) {
            //ok
            streamLoading.sink.add(1);
            //print(msg);

            if (resp['data'].toString().contains("{")) {
              funOpenHome(resp);
            } else {
              final newToken = resp['token'] ?? '';
              final email = _ctr_email.text.trim();
              Navigator.of(context)
                  .push(CupertinoPageRoute(
                      builder: (context) => CodeLoginPage(
                            email: email,
                            newToken: newToken,
                            idDevice: tokenDevice,
                          )))
                  .then((value) {
                if (value != null) {
                  funOpenHome(value);
                }
              });
            }
          } else {
            //error hhtp
            print(msg);
            DialogsUtils(
              context,
              title: 'Error de Autentificación.',
              textContent: msg,
            ).showMessageError();
          }
        } else {
          // response null
          print("FALLOOOO");
          DialogsUtils(
            context,
            title: 'Sin Respuesta.',
            textContent:
                'El servidor no responde, verifica tu conexión a internet e inténtalo de nuevo.',
          ).showMessageError();
        }
      },
    ).timeout(Duration(seconds: 60), onTimeout: () {
      DialogsUtils(
        context,
        title: 'Sin Respuesta!',
        textContent:
            'El servidor no responde, verifica tu conexión a internet e inténtalo de nuevo.',
      ).showMessageError();
    });
  }
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
