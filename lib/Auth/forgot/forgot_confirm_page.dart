import 'dart:async';

import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/Home/home_page.dart';

final Widget loading = CircularProgressIndicator();
final Widget okok = Image.asset("assets/icons/checked.png", width: 30);
final Widget normal = Image.asset("assets/icons/ok.png");

class ForgotConfirmPage extends StatefulWidget {
  final Function() onPressed;
  final String email;
  final bool hasEditProfile;

  const ForgotConfirmPage(
      {required this.onPressed,
      this.email = "",
      this.hasEditProfile = false,
      Key? key})
      : super(key: key);

  @override
  State<ForgotConfirmPage> createState() => _ForgotConfirmPageState();
}

class _ForgotConfirmPageState extends State<ForgotConfirmPage> {
  final _ctr_code = TextEditingController();
  final _ctr_email = TextEditingController();
  final _ctr_pass = TextEditingController();

  bool _obscureTextPass = true;

  final streamLoading = StreamController<int>();
  bool autofocus = true, block = true;
  List<String> pins = ['', '', '', '', '', ''];

  @override
  void initState() {
    if (widget.hasEditProfile) _validateEditPassword();
    super.initState();
    _ctr_code.text = "";
    _ctr_email.text = widget.email;
    _ctr_pass.text = "";
  }

  @override
  void dispose() {
    _ctr_code.dispose();
    _ctr_pass.dispose();
    _ctr_email.dispose();
    streamLoading.close();
    super.dispose();
  }

  funSendData() {
    if (_ctr_email.text.isNotEmpty && _ctr_pass.text.isNotEmpty) {
      //widget.onPressed();
      _validate(context);
    } else {
      DialogsUtils(
        context,
        title: 'Faltan Datos de la cuenta.',
        textContent: 'El Código, correo y la contraseña son obligatorios',
      ).showMessageError();

      print("es obligatorio");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _ctr_code.text = pins.join('');
    block = pins.join('').length != 6;
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          height: size.height,
          child: Column(
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
              // pins
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // pin1
                    editTextFormNumber(
                      autofocus: autofocus,
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() => pins[0] = value);
                          FocusScope.of(context).nextFocus();
                        } else {
                          setState(() => pins[0] = '');
                        }
                      },
                      onSaved: (pin) {},
                    ),
                    // pin2
                    editTextFormNumber(
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() => pins[1] = value);
                          FocusScope.of(context).nextFocus();
                        } else {
                          setState(() => pins[1] = '');
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onSaved: (pin) {},
                    ),
                    // pin3
                    editTextFormNumber(
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() => pins[2] = value);
                          FocusScope.of(context).nextFocus();
                        } else {
                          setState(() => pins[2] = '');
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onSaved: (pin) {},
                    ),
                    // pin4
                    editTextFormNumber(
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() => pins[3] = value);
                          FocusScope.of(context).nextFocus();
                        } else {
                          setState(() => pins[3] = '');
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onSaved: (pin) {},
                    ),
                    // pin5
                    editTextFormNumber(
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() => pins[4] = value);
                          FocusScope.of(context).nextFocus();
                        } else {
                          setState(() => pins[4] = '');
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onSaved: (pin) {},
                    ),
                    // pin6
                    editTextFormNumber(
                      autofocus: autofocus,
                      onChanged: (value) {
                        if (value.length == 1) {
                          setState(() {
                            pins[5] = value;
                            autofocus = !autofocus;
                          });
                        } else {
                          setState(() => pins[5] = '');
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onSaved: (pin) {},
                    ),
                  ],
                ),
              ),
              // ------
              if (block) SizedBox(height: 175),
              if (!block)
                editText(
                  controller: _ctr_pass,
                  hint: 'Contraseña',
                  assets: 'assets/icons/key.png',
                  onObscureText: () =>
                      setState(() => _obscureTextPass = !_obscureTextPass),
                  obscureText: _obscureTextPass,
                ),
              if (!block) SizedBox(height: 115),
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
                      onPressed: _ctr_pass.text.length >= 6
                          ? funSendData
                          : () {}, //funSendData,
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  //_____ POST
  _validate(BuildContext context) {
    streamLoading.sink.add(-1);
    var body = <String, dynamic>{
      "email": _ctr_email.text,
      "code": _ctr_code.text,
      "password": _ctr_pass.text,
    };

    var _url = Uri.parse(Constants.url_forgot_send_code);

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

          print(state);
          if (state) {
            //ok
            streamLoading.sink.add(1);
            print(msg);
            widget.onPressed();
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

//----------------------
  // forgot password
  _validateEditPassword() {
    var body = <String, dynamic>{
      "email": widget.email,
    };

    var _url = Uri.parse(Constants.url_forgot);

    ApiServices.POST(
      url: _url,
      bodyy: body,
    ).then(
      (response) async {
        // ignore: unnecessary_null_comparison
        if (response != null) {
          var resp = ApiServices.getBody(response);
          var state = resp["ok"];
          var msg = resp["message"];

          //print(state);
          if (state) {
            //ok

          } else {
            //error hhtp
            //print(msg);
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
  //------------
}
