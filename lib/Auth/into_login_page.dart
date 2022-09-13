import 'dart:async';

import 'package:kronosss/Auth/dialog_privacy_welcome.dart';
import 'package:kronosss/Common/webview_page.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_service.dart';
import 'package:kronosss/Auth/auth_widget.dart';
import 'package:kronosss/Auth/forgot/forgot_page.dart';
import 'package:kronosss/Auth/register/register_page.dart';
import 'package:kronosss/Auth/user_model.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
//import 'package:kronosss/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../DialogSheet/Responsivewidget.dart';
import 'login/login_page.dart';

class IntoLoginPage extends StatefulWidget {
  @override
  State<IntoLoginPage> createState() => _IntoLoginPageState();
}

class _IntoLoginPageState extends State<IntoLoginPage> {
  final _stream_login = StreamController<int>();

  @override
  void initState() {
    super.initState();
    //dialogPrivacy(context);
  }

  @override
  void dispose() {
    _stream_login.close();
    super.dispose();
  }


  funSignUp() {
    Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (context) => LoginPage()));
  }

  funSignUpWithGoogle() async {
    _stream_login.sink.add(-1);
    try {
      await authService.signOutGoogle();
      final resp = await Authentication.signInWithGoogle();
      //print('signInWithGoogle: $resp');

      await authService
          .signInWithGoogle(context: context, userAuth: resp)
          .then((value) {
        _validate(value, resp);
      });
    } catch (e) {
      //Utils.toast(context, e.toString());
    }

    _stream_login.sink.add(0);
  }

  funSignIn() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => RegisterPage()));
  }

  funForgot() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForgotPage()));
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
  @override
  Widget build(BuildContext context) {

    return ResponsiveWidget(
      desktopScreen:Scaffold(
        backgroundColor: Colors.black,
        // this avoids the overflow error,
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size
      .height - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //SizedBox(height: 20),
                  logokronoss(),
                  SizedBox(height: 30),
                  Container(
                    height: 70,
                    child: Text(
                      'El mayor marketplace \ndel mundo',
                      style: style.copyWith(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  buttonGeneric(
                    'Iniciar Sesión',
                    width: double.maxFinite,
                    onPressed: funSignUp,
                  ),
                  buttonGeneric(
                    'Créate una cuenta',
                    width: double.maxFinite,
                    onPressed: funSignIn,
                  ),
                  Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        SizedBox(width: 35),
                        Text('¿Problemas para entrar?'),
                        MaterialButton(
                          padding:
                          EdgeInsets.only(bottom: 5, top: 5, right: 25),
                          child: Text(
                            'Accede',
                            style: style.copyWith(color: Colors.green),
                          ),
                          onPressed: funForgot,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Inicia sesión con'),
                      ],
                    ),
                  ),
                  // - login with google
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[900]),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          alignment: Alignment.center,
                          child: MaterialButton(
                            child: Image.asset(
                              IMAGE_GOOGLE,
                              width: 25,
                              height: 25,

                            ),
                            onPressed: funSignUpWithGoogle,
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[900]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
      mobileScreen:
       Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false, // this avoids the overflow error,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: 20),
                logokronoss(),
                SizedBox(height: 30),
                Container(
                  height: 70,
                  child: Text(
                    'El mayor marketplace \ndel mundo',
                    style: style.copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                buttonGeneric(
                  'Iniciar Sesión',
                  width: double.maxFinite,
                  onPressed: funSignUp,
                ),
                buttonGeneric(
                  'Créate una cuenta',
                  width: double.maxFinite,
                  onPressed: funSignIn,
                ),
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      SizedBox(width: 35),
                      Text('¿Problemas para entrar?'),
                      MaterialButton(
                        padding:
                        EdgeInsets.only(bottom: 5, top: 5, right: 25),
                        child: Text(
                          'Accede',
                          style: style.copyWith(color: Colors.green),
                        ),
                        onPressed: funForgot,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Inicia sesión con'),
                    ],
                  ),
                ),
                // - login with google
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.grey[900]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        alignment: Alignment.center,
                        child: MaterialButton(
                          child: Image.asset(
                            IMAGE_GOOGLE,
                            width: 25,
                            height: 25,
                          ),
                          onPressed: funSignUpWithGoogle,
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: Colors.grey[900]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // term of use
                textInfoLegal(
                    onPressedPrivacy: funPrivacy, onPressedTerm: funTerm),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    )

    );
  }

  void _validate(GoogleSignInAuthentication? googleKey, User? userAuth) async {
    var bodyReg = {
      "name": userAuth?.displayName ?? "",
      "lastname": "",
      "email": userAuth?.email ?? "",
      "password": "12345667",
      "phone": 100050008000200,
      "idDevice": "213123klaskdaklasdasdasd",
      "rol": "USER_ROLE",
      "birthday": "12-29-1993",
      "publicKey": "public_key_not_found",
      "secret": "secret_not_found",
      "google_id": "${userAuth?.providerData[0].uid}",
      "token": "${googleKey!.accessToken}",
    };

    print('............');
    print(bodyReg);
    print('............');
    //Consult API
    // create
    var _url = Uri.parse(Constants.url_regirer_google);
    final respCreate = await ApiServices.POST(url: _url, bodyy: bodyReg);
    if (respCreate != null) {
      var resp = ApiServices.getBody(respCreate);
      var state = resp.toString().contains("ok") ? resp["ok"] : false;
      var msg = resp.toString().contains("message") ? resp["message"] : "null";

      print("$state \n$resp");
      if (state) {
        //ok
        print(msg);
        //Utils.toast(context, 'Usuario creado...');
      } else {
        //error hhtp
        print(msg);
        //Utils.toast(context, msg);
      }
    } else {
      // response null
      /*  Utils.toast(context,
          'El servidor no responde, verifica tu conexión a internet e intentalo de nuevo.'); */
      print("FALLOOOO");
    }

    var bodyLogin = {
      "token": "${googleKey.accessToken}",
      "google_id": "${userAuth?.providerData[0].uid}",
    };
    //Consult API
    // login
    _url = Uri.parse(Constants.url_login_google);
    final respLogin = await ApiServices.POST(url: _url, bodyy: bodyLogin);
    if (respLogin != null) {
      var resp = ApiServices.getBody(respLogin);
      var state = resp["ok"] ?? false;
      var msg = resp["message"] ?? "No Responde...";

      debugPrint('loggon: $resp');
      if (state) {
        //ok
        print(msg);

        var user = UserModel.fromJson(resp);
        var strUser = UserModel.toStrings(user);

        SharedPrefs.setBool(shared_isLogIn, true);
        SharedPrefs.setString(shared_user, strUser);
        SharedPrefs.setString(shared_token, user.token);
        SharedPrefs.setString(shared_email, user.email);
        SharedPrefs.setString(
            shared_image, /* userAuth?.photoURL ?? */ user.image);

        //Navigator.of(context).pop();
        await Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => HomePage()));
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
  }

  Widget fixedIconGoogle() => StreamBuilder<int>(
      stream: _stream_login.stream,
      initialData: 0,
      builder: (context, snap) {
        var ic = snap.data != 0;
        return ic
            ? CircularProgressIndicator()
            : Image.asset(
                "assets/icons/logo_google.png",
                width: 40,
              );
      });

  dialogPrivacy(BuildContext context) async {
    final bool privacy = await SharedPrefs.getBool("main_privacy") ?? false;
    print(privacy);
    if (!privacy)
      DialogPrivacyWelcome(context).show(
        onAccept: () async {
          await SharedPrefs.setBool("main_privacy", true);
          final bool privacy =
              await SharedPrefs.getBool("main_privacy") ?? false;
          print(privacy);
          Navigator.of(context).pop();
        },
      );
  }
}
