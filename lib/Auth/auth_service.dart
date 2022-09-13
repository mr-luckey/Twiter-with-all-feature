import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      //'https://www.googleApis.com/auth/contacts.readonly',
    ],
  );

  get onGoogleCurrentUserChanged => _googleSignIn.onCurrentUserChanged;

  Future<GoogleSignInAuthentication?> signInWithGoogle(
      {required BuildContext context, User? userAuth}) async {
    final goSignIn = await _googleSignIn.signIn();
    final resc = await goSignIn?.authentication;
    return resc;

    /* await _googleSignIn.signIn().then((result) {
      result?.authentication.then((googleKey) async {
        //print('accessToken: ${googleKey.accessToken}');
        //print('idToken: ${googleKey.idToken}');
        //print('Name: ${_googleSignIn.currentUser.displayName}');
        //final fire = await FirebaseAuth.instance.currentUser;
        //final uid = fire?.uid;
        //print('uid: $result $googleKey');
        /* print('---');
        print('name: ${userAuth?.displayName}');
        print('email: ${userAuth?.email}');
        print('id: ${userAuth?.providerData[0].uid}');
        print('phone: ${userAuth?.phoneNumber}');
        print('token: ${userAuth?.refreshToken}');
        print('uid: ${userAuth?.uid}');
        print('provider: ${userAuth?.providerData}');
        print('image: ${userAuth?.photoURL}');
        print('---'); 
        Map<String, dynamic> body = <String, dynamic>{
          //'uid': '${result.id}',
          'uid': '$uid',
          'accessToken': googleKey.accessToken,
          'idToken': '${googleKey.idToken}',
        }; */
        //var tokk = googleKey.idToken;
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
          "token": "${googleKey.accessToken}",
        };
        
        print('............');
        print(bodyReg);
        print('............');
        //Consult API
        // create
        var _url = Uri.parse(Constants.url_regirer);
        final respCreate = await ApiServices.POST(url: _url, bodyy: bodyReg);
        if (respCreate != null) {
          var resp = ApiServices.getBody(respCreate);
          var state = resp.toString().contains("ok") ? resp["ok"] : false;
          var msg =
              resp.toString().contains("message") ? resp["message"] : "null";

          print("$state \n$resp");
          if (state) {
            //ok
            print(msg);
            Utils.toast(context, 'Usuario creado...');
          } else {
            //error hhtp
            print(msg);
            Utils.toast(context, msg);
          }
        } else {
          // response null
          Utils.toast(context,
              'El servidor no responde, verifica tu conexión a internet e intentalo de nuevo.');
          print("FALLOOOO");
        }
        var bodyLogin = {
          "token": "${googleKey.accessToken}",
          "google_id": "${userAuth?.providerData[0].uid}",
        };
        _url = Uri.parse(Constants.url_login_google);
        final respLogin = await ApiServices.POST(url: _url, bodyy: bodyLogin);
        if (respLogin != null) {
          var resp = ApiServices.getBody(respLogin);
          var state = resp["ok"];
          var msg = resp["message"];

          print(state);
          if (state) {
            //ok
            print(msg);

            var user = UserModel.fromJson(resp);
            var strUser = UserModel.toStrings(user);

            SharedPrefs.setBool(shared_isLogIn, true);
            SharedPrefs.setString(shared_user, strUser);
            SharedPrefs.setString(shared_token, user.token);
            SharedPrefs.setString(shared_email, user.email);
            SharedPrefs.setString(shared_imaage, user.image);

            Navigator.of(context).pop();
            await Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => HomePage()));
          } else {
            //error hhtp
            print(msg);
            dialogBottomMessage(
              context: context,
              title: 'Error de Autentificación.',
              //paddingButtonAdd: true,
              replaceImageAssets: "assets/icons/cancel.png",
              colorTitle: colorError2,
              message: msg,
            );
          }
        } else {
          // response null
          print("FALLOOOO");
          dialogBottomMessage(
            context: context,
            title: 'Sin Respuesta.',
            //paddingButtonAdd: true,
            replaceImageAssets: "assets/icons/cancel.png",
            colorTitle: colorError2,
            message:
                'El servidor no responde, verifica tu conexión a internet e intentalo de nuevo.',
          );
        }
      }).catchError((err) {
        print('inner error');
      });
    }).catchError((err) {
      print('error occured');
    }); */
  }

  Future<void> signInFirebase(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOutFirebase() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  //------

  //------
} //.....

final authService = AuthService();

class Authentication {
  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }
}
