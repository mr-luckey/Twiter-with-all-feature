import 'dart:async';

import 'package:kronosss/Common/webview_page.dart';
import 'package:kronosss/DialogSheet/Responsivewidget.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';
import 'package:kronosss/Auth/register/registred_completed_page.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';

final Widget loading = CircularProgressIndicator();
final Widget okok = Image.asset("assets/icons/checked.png", width: 30);
final Widget normal = Image.asset("assets/icons/ok.png");

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _ctr_nick = TextEditingController();
  final _ctr_email = TextEditingController();
  final _ctr_pass = TextEditingController();

  bool _obscureTextPass = true, _completed = false;
  bool acceptPrivacy = false;
  // ignore: unused_field
  bool _checkedNick = false;

  final streamLoading = StreamController<int>();

  @override
  void initState() {
    super.initState();
    _ctr_nick.text = "";
    _ctr_email.text = "";
    _ctr_pass.text = "";
  }

  @override
  void dispose() {
    _ctr_nick.dispose();
    _ctr_pass.dispose();
    _ctr_email.dispose();
    streamLoading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: _completed
                    ? RegistredCompletedPage(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
                    : Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      logokronoss(),
                      SizedBox(height: 30),
                      Container(
                        height: 70,
                        child: Text(
                          'Introduce \ne-mail, usuario y contraseña',
                          style: style.copyWith(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      editText(
                        controller: _ctr_email,
                        hint: 'Nombre de usuario',
                        assets: 'assets/icons/resource_email.png',
                      ),
                      editText(
                        controller: _ctr_nick,
                        hint: 'E-mail',
                        assets: 'assets/icons/nick.png',
                      ),

                      editText(
                        controller: _ctr_pass,
                        hint: 'Contraseña',
                        assets: 'assets/icons/key.png',
                        onObscureText: () => setState(
                                () => _obscureTextPass = !_obscureTextPass),
                        obscureText: _obscureTextPass,
                      ),
                      // SizedBox(height: 18),
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
                                child: CircularProgressIndicator
                                    .adaptive())
                                : null;

                            return buttonGeneric(
                              'Enviar',
                              width: double.maxFinite,
                              child: value,
                              color_text_deco: acceptPrivacy
                                  ? Colors.white
                                  : Colors.grey,
                              onPressed: acceptPrivacy
                                  ? funSendData
                                  : funValidatePrivacy,
                            );
                          }),
                      //SizedBox(height: 20),
                      Spacer(),
                      Expanded(
                        child: textAcceptLegal(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            acceptPrivacy: acceptPrivacy,
                            onChanged: (v) {
                              setState(() {
                                if (v != null) acceptPrivacy = v;
                              });
                            }),
                      ),
                      // term of use
                      Expanded(
                        child: textInfoLegal(
                            onPressedPrivacy: funPrivacy,
                            onPressedTerm: funTerm),
                      ),
                      // SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      mobileScreen: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: _completed
                    ? RegistredCompletedPage(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
                    : Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      logokronoss(),
                      SizedBox(height: 30),
                      Container(
                        height: 70,
                        child: Text(
                          'Introduce \ne-mail, usuario y contraseña',
                          style: style.copyWith(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      editText(
                        controller: _ctr_email,
                        hint: 'Nombre de usuario',
                        assets: 'assets/icons/resource_email.png',
                      ),
                      editText(
                        controller: _ctr_nick,
                        hint: 'E-mail',
                        assets: 'assets/icons/nick.png',
                      ),

                      editText(
                        controller: _ctr_pass,
                        hint: 'Contraseña',
                        assets: 'assets/icons/key.png',
                        onObscureText: () => setState(
                                () => _obscureTextPass = !_obscureTextPass),
                        obscureText: _obscureTextPass,
                      ),
                      // SizedBox(height: 18),
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
                                child: CircularProgressIndicator
                                    .adaptive())
                                : null;

                            return buttonGeneric(
                              'Enviar',
                              width: double.maxFinite,
                              child: value,
                              color_text_deco: acceptPrivacy
                                  ? Colors.white
                                  : Colors.grey,
                              onPressed: acceptPrivacy
                                  ? funSendData
                                  : funValidatePrivacy,
                            );
                          }),
                      //SizedBox(height: 20),
                      Spacer(),
                      Expanded(
                        child: textAcceptLegal(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            acceptPrivacy: acceptPrivacy,
                            onChanged: (v) {
                              setState(() {
                                if (v != null) acceptPrivacy = v;
                              });
                            }),
                      ),
                      // term of use
                      Expanded(
                        child: textInfoLegal(
                            onPressedPrivacy: funPrivacy,
                            onPressedTerm: funTerm),
                      ),
                      // SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  funValidatePrivacy() {
    DialogsUtils(
      context,
      title: 'Políticas de privacidad y condiciones de uso',
      textContent:
          'Por favor lee y marca la casilla de consentimiento, solo si estás de acuerdo.',
    ).showMessageError();
  }

  funSendData() {
    if (_ctr_email.text.isNotEmpty && _ctr_pass.text.isNotEmpty) {
      validate(context);
    } else {
      DialogsUtils(
        context,
        title: 'Faltan Datos de inicio de sesión.',
        textContent:
            'El correo, la contraseña y el nombre de usuario son obligatorios',
      ).showMessageError();
      print("es obligatorio");
    }
  }

  funTerm() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WebViewPage(
              url: URL_TERM_USE,
            )));
  }

  funPrivacy() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WebViewPage(
              url: URL_PRIVACY,
            )));
  }

  //---- GET
  validateNick(BuildContext context) async {
    streamLoading.sink.add(-1);
    var _url = Uri.parse(Constants.url_authNick + "?nick=${_ctr_nick.text}");

    final response = await ApiServices.GET(url: _url);
    if (response != null) {
      streamLoading.sink.add(0);
      var body = ApiServices.getBody(response);
      bool check = body['ok'];
      if (check) {
        streamLoading.sink.add(1);
        setState(() {
          _checkedNick = true;
        });
      } else {
        setState(() {
          _checkedNick = false;
        });
      }
    } else {
      setState(() {
        _checkedNick = false;
      });
    }
  }

  //_____ POST
  validate(BuildContext context) {
    streamLoading.sink.add(-1);
    var body = <String, dynamic>{
      "name": _ctr_nick.text,
      "lastname": " ",
      "email": _ctr_email.text,
      "password": _ctr_pass.text,
      "nickname": _ctr_nick.text,
      //"phone": 100050009000300070,
      "idDevice": "id_devices_no_found_123456789",
      "rol": "USER_ROLE",
      "birthday": "12-31-2022",
      "publicKey": "public_key_no_found",
      "secret": "secret_no_found",
      "token": "token_no_found",
    };

    var _url = Uri.parse(Constants.url_regirer);

    ApiServices.POST(
      url: _url,
      bodyy: body,
    ).then(
      (response) async {
        streamLoading.sink.add(0);
        // ignore: unnecessary_null_comparison
        if (response != null) {
          var resp = ApiServices.getBody(response);
          var state = resp["ok"];
          var msg = resp["message"];

          print("$state \n$resp");
          if (state) {
            //ok
            streamLoading.sink.add(1);
            print(msg);

            setState(() {
              _completed = true;
            });
            //Navigator.of(context).pop();
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
                'El servidor no responde, verifica tu conexión a internet e intentalo de nuevo.',
          ).showMessageError();
        }
      },
    ).timeout(Duration(seconds: 60), onTimeout: () {
      DialogsUtils(
        context,
        title: 'Sin Respuesta!',
        textContent:
            'El servidor no responde, verifica tu conexión a internet e intentalo de nuevo.',
      ).showMessageError();
    });
  }
}
