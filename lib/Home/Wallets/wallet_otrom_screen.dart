import 'package:kronosss/Home/Profile/profile_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:flutter/material.dart';

class WalletOtrom extends StatefulWidget {
  final ProfileModel? model;
  final String type;
  final double balance;
  WalletOtrom(
      {this.model,
      this.type = 'Retirar | Enviar | Donar | Comprar',
      this.balance = 0.0});

  @override
  _WalletOtromState createState() => _WalletOtromState();
}

class _WalletOtromState extends State<WalletOtrom> {
  final _controller = TextEditingController();
  String _balance = '0.0';

  @override
  void initState() {
    super.initState();
    _balance = '${widget.balance}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colorskronoss.background_application_dark,
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    cacheImageNetwork(
                      widget.model?.image ?? '',
                      size: 90,
                      assetError: NOT_IMAGE_PROFILE,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(widget.model?.name ?? '',
                    style: style.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _balance.split(".")[0],
                  style:
                      style.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  ",",
                  style:
                      style.copyWith(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    _balance.split(".")[1],
                    style: style.copyWith(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  " USD\$",
                  style:
                      style.copyWith(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(widget.type,
                    style: style.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: size.width * 0.4,
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    style: style.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      alignLabelWithHint: true,
                      hintText: '000.0000',
                      hintStyle: style.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    double v = _controller.text.isNotEmpty
                        ? double.parse(_controller.text)
                        : 0.0;
                    if (v > 0.0) {
                      Navigator.of(context).pop(v);
                    } else {
                      /* Utils.toast(
                                context,
                                'El monto no es válido',
                                backgroundColor: Colorskronoss.red_snackbar_error,
                                duration: 4000,
                                position: Utils.positionedCenter,
                              ); */
                    }
                  },
                  child: Image.asset(
                    "assets/icons/ic_accept_boton.png",
                    width: 340,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
