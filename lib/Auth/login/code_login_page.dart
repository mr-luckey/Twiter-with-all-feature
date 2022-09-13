import 'dart:async';
import 'dart:io';

import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/utils.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';

import '../../Home/home_page.dart';

final Widget loading = CircularProgressIndicator();
final Widget okok = Image.asset("assets/icons/checked.png", width: 30);
final Widget normal = Image.asset("assets/icons/ok.png");

class CodeLoginPage extends StatefulWidget {
  final String email;
  final String newToken;
  final String idDevice;

  const CodeLoginPage(
      {required this.email,
      required this.newToken,
      required this.idDevice,
      Key? key})
      : super(key: key);

  @override
  State<CodeLoginPage> createState() => _CodeLoginPageState();
}

class _CodeLoginPageState extends State<CodeLoginPage> {
  final _ctr_code = TextEditingController();
  final _ctr_email = TextEditingController();

  final streamLoading = StreamController<int>();
  final streamTimer = StreamController<int>.broadcast();
  late DateTime end, current;
  late Timer timer;
  bool autofocus = true, block = true, hasTimer = true;
  List<String> pins = ['', '', '', '', '', ''];

  int pos = 120;

  @override
  void initState() {
    end = DateTime.now().add(Duration(seconds: pos));
    current = DateTime.now();
    super.initState();
    _ctr_code.text = "";
    _ctr_email.text = widget.email;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      pos--;
      current = DateTime.now();
      hasTimer = end.difference(current).isNegative;
      streamTimer.add(end.difference(current).inSeconds);
      if (hasTimer) {
        timer.cancel();
        /* Future.delayed(
          Duration(milliseconds: 1500),
          () => Navigator.of(context).pop(),
        ); */
      }
    });
  }

  @override
  void dispose() {
    _ctr_code.dispose();
    _ctr_email.dispose();
    streamLoading.close();
    streamTimer.close();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _ctr_code.text = pins.join('');
    block = pins.join('').length != 6;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            height: size.height,
            child: Column(
              children: [
                logokronoss(),
                SizedBox(height: 30),
                Container(
                  height: 70,
                  child: Text(
                    'Introduce \nel código enviado al correo',
                    style: style.copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                // pins
                Form(
                  child: SizedBox(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // pin1
                        editTextFormNumber(
                          autofocus: autofocus,
                          width: 42,
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
                          width: 42,
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
                          width: 42,
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
                          width: 42,
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
                          width: 42,
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
                          width: 42,
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
                ),
                // ------
                SizedBox(height: 20),

                Row(
                  children: [
                    StreamBuilder<int>(
                        stream: streamTimer.stream,
                        initialData: pos - 1,
                        builder: (context, snap) {
                          final date = Duration(seconds: snap.data!);
                          String time = Utils.formatTime(date);
                          if (date.isNegative)
                            return MaterialButton(
                              child: Text('redireccionando...'),
                              onPressed: () {},
                            );
                          return Text('Tiempo restante: $time');
                        }),
                  ],
                ),
                if (!block) SizedBox(height: 135),
                if (!block && !hasTimer)
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
                          onPressed: funSend,
                        );
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // send data
  funSend() async {
    streamLoading.add(-1);
    final platform = Platform.isAndroid || Platform.isIOS ? "mo" : "xxx";
    var body = {
      "email": _ctr_email.text,
      "code": int.parse(_ctr_code.text),
      "idDevice": widget.idDevice,
      "local": platform,
    };
    final header = ApiServices.HEADERS_AUTH(widget.newToken);
    final url = Uri.parse(Constants.url_changeDevice);

    /* var response;
    await Future.delayed(Duration(seconds: 2)); */

    final response = await ApiServices.POST(
      url: url,
      header: header,
      bodyy: body,
      feel: false,
    );

    streamLoading.add(0);
    if (response != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // si
        final body = ApiServices.getBody(response);
        Navigator.of(context).pop(body);
      } else {
        // no
        final json = ApiServices.getBody(response);
        DialogsUtils(
          context,
          title: 'Error de autentificación',
          textContent: json['message'],
        ).showMessageError();
      }
    } else {
      // null
      DialogsUtils(
        context,
        title: 'Sin Respuesta',
        textContent: 'No hubo respuesta del server.',
      ).showMessageError();
    }
  }
}
