import 'dart:async';

import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';
import 'package:kronosss/Auth/forgot/forgot_confirm_page.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';

final Widget loading = CircularProgressIndicator();
final Widget okok = Image.asset("assets/icons/checked.png", width: 30);
final Widget normal = Image.asset("assets/icons/ic_circle_create_account.png");

class ForgotPage extends StatefulWidget {
  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  bool _isConfirmated = false;
  final _ctr_email = TextEditingController();

  final streamLoading = StreamController<int>();

  @override
  void initState() {
    super.initState();
    _isConfirmated = false;
    _ctr_email.text = "";
  }

  @override
  void dispose() {
    _ctr_email.dispose();
    streamLoading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('is confirmated: $_isConfirmated');

    return Builder(builder: (context) {
      return Scaffold(
        body: ListView(
          children: [
            Container(
              child: _isConfirmated
                  ? ForgotConfirmPage(
                      email: _ctr_email.text,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                hint: 'E-mail',
                                assets: 'assets/icons/resource_email.png',
                              ),
                              SizedBox(height: 142),
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
                                      onPressed: funSendData,
                                    );
                                  }),
                              Spacer(),
                              // term of use
                              //textInfoLegal(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }

  funSendData() {
    if (_ctr_email.text.isNotEmpty) {
      _validate(context);
    } else {
      DialogsUtils(
        context,
        title: 'Faltan Datos de la Cuenta.',
        textContent: 'El correo y la contraseña son obligatorios',
      ).showMessageError();
      print("es obligatorio");
    }
  }

  //_____ POST
  _validate(BuildContext context) {
    streamLoading.sink.add(-1);
    var body = <String, dynamic>{
      "email": _ctr_email.text,
    };

    var _url = Uri.parse(Constants.url_forgot);

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

          //print(state);
          if (state) {
            //ok
            streamLoading.sink.add(1);
            //print(msg);
            setState(() {
              _isConfirmated = true;
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
