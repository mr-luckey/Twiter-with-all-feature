import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/Home/home_page.dart';

Widget editText({
  TextEditingController? controller,
  String hint = '',
  String assets = 'assets/icons/ic_circle_create_account.png',
  List<TextInputFormatter>? inputFormatters,
  TextInputType textInputType = TextInputType.text,
  TextInputAction? textInputAction = TextInputAction.done,
  void Function()? onObscureText,
  bool? obscureText,
  bool? enabled,
}) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 3),
    child: TextField(
      controller: controller,
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      obscureText: obscureText ?? false,
      minLines: 1,
      style: style.copyWith(height: 1.5),
      decoration: getDeco.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Image.asset(assets, width: 10, height: 10),
        ),
        hintText: hint,
        suffixIcon: obscureText != null
            ? GestureDetector(
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onTap: onObscureText,
              )
            : null,
      ),
    ),
  );
}

Widget editTextFormNumber({
  double height = 62.5,
  double width = 50.0,
  String hint = '',
  void Function(String)? onChanged,
  void Function(String?)? onSaved,
  TextEditingController? controller,
  InputDecoration? decoration,
  bool autofocus = false,
}) =>
    Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        onSaved: onSaved,
        autofocus: autofocus,
        decoration: decoration ?? getDeco2(radius: 8, hint: hint),
        style: style18,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );

Widget EditTextAuth({
  TextEditingController? controller,
  double width = 270,
  double height = 60,
  bool obscureText = false,
  Widget? prefixIcon,
  bool alignLabelWithHint = true,
  BoxDecoration? decoration,
  String hintText = "",
  TextStyle? style,
  TextStyle? hintStyle,
  TextInputType inputType = TextInputType.name,
  EdgeInsets? contentPadding,
}) {
  return Container(
    width: width,
    height: height,
    alignment: Alignment.center,
    padding: EdgeInsets.only(left: 5, right: 5),
    decoration: decoration ??
        BoxDecoration(
          color: Colorskronoss.white_blur,
          borderRadius: BorderRadius.circular(5),
        ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: style ??
          TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: 'Avenir'),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding:
            contentPadding ?? EdgeInsets.only(left: 15, top: 15, right: 15),
        prefixIcon: prefixIcon,
        alignLabelWithHint: true,
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: 'Avenir'),
      ),
    ),
  );
}

Widget logokronoss({double width = 200}) {
  return Container(
      child: Image.asset("assets/icons/kronos_original.png", width: width));
}

Widget textAcceptLegal(
    {required bool acceptPrivacy,
    required void Function(bool?)? onChanged,
    EdgeInsets? padding}) {
  return Container(
    padding: padding,
    child: Row(
      children: [
        Flexible(
          child: Checkbox(
              value: acceptPrivacy,
              activeColor: Colors.green,
              onChanged: onChanged),
        ),
        Flexible(
          flex: 4,
          child: Wrap(
            children: [
              widgetTextAceptPrivacy,
            ],
          ),
        ),
      ],
    ),
  );
}

Widget textInfoLegal({
  Function()? onPressedTerm,
  Function()? onPressedPrivacy,
  double runSpacing = 4,
  double spacing = 0,
  double textSize = 10,
  double textSizeButton = 11,
  Color? colorText,
}) {
  //var color = colorText ?? Colors.white;

  return Container(
    margin: EdgeInsets.only(
      left: 20,
      right: 20,
    ),
    child: Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Si accedes, aceptas nuestras ',
                style: style,
              ),
              TextSpan(
                text: 'condiciones',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedTerm,
              ),
              TextSpan(
                text: ' de ',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedTerm,
              ),
              TextSpan(
                text: 'uso ',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedTerm,
              ),
              TextSpan(
                text: 'y ',
                style: style,
              ),
              TextSpan(
                text: 'políticas',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedPrivacy,
              ),
              TextSpan(
                text: ' de ',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedPrivacy,
              ),
              TextSpan(
                text: 'privacidad',
                style: style.copyWith(color: Color(0xff6FD373)),
                recognizer: TapGestureRecognizer()..onTap = onPressedPrivacy,
              ),
              TextSpan(
                text: ' aplicadas.',
                style: style,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buttonText({Function()? onPressed, EdgeInsets? padding}) {
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: padding ?? EdgeInsets.only(top: 14, bottom: 14),
      child: Text(
        "¿Olvidaste la contraseña?",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),
  );
}

Widget buttonGoogle({required Function()? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: EdgeInsets.all(8),
      width: 270,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/logo_google.png",
              width: 40,
            ),
            Spacer(),
            Text(
              "Iniciar sesión con Google",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
        onPressed: () {},
      ),
    ),
  );
}

Widget buttonOK(Function() onpressed,
    {String text = " Enviar", Widget? icon, TextStyle? style}) {
  return Container(
    margin: EdgeInsets.all(8),
    width: 270,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(5),
    ),
    child: MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ??
              Image.asset(
                "assets/icons/enviar.png",
                width: 35,
              ),
          //Spacer(),
          SizedBox(width: 5),
          Text(
            text,
            style: style ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),
          ),
          Spacer(),
        ],
      ),
      onPressed: onpressed,
    ),
  );
}

Widget buttonTextGeneric(String? text,
    {required Function() onPressed,
    TextStyle? style,
    EdgeInsets? padding,
    EdgeInsets? margin}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.only(top: 14, bottom: 4),
      child: Text(
        text ?? "",
        style: style ??
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    ),
  );
}

Widget buttonGeneric(
  String? text, {
  required Function() onPressed,
  TextStyle? styles,
  EdgeInsets? padding,
  EdgeInsets? margin,
  double width = 220,
  double? height,
  Color? colorBG,
  Color color_text_deco = Colors.white,
  Widget? child,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: decoCircle.copyWith(
          color: colorBG, border: Border.all(width: 1, color: color_text_deco)),
      width: width,
      height: height,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 4, bottom: 9),
      padding: EdgeInsets.all(14.5),
      child: child ??
          Text(
            text ?? '',
            style: styles ?? style.copyWith(color: color_text_deco),
          ),
    ),
  );
}

/* //----- modals
void dialogBottomMessage({
  required BuildContext context,
  bool isBtnShow = true,
  bool isNotImage = false,
  String message = '',
  String? title,
  Widget? iconTitle,
  Widget? contentChild,
  String? replaceImageAssets,
  double sizeIconDefault = 50,
  Color colorTitle = Colors.white,
  Color colorTextContent = Colors.white,
  Color? colorBG,
  Color barrierColor = Colors.transparent,
  Function()? onpressed,
  bool dissmiss = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  bool paddingButtonAdd = true,
}) {
  iconTitle = isNotImage ? SizedBox() : null;
  showModalBottomSheet(
      context: context,
      isDismissible: dissmiss,
      useRootNavigator: useRootNavigator,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: (dissmiss && (barrierColor == Colors.transparent))
          ? barrierColor
          : Colors.black12,
      elevation: 3,
      builder: (ctx) => Container(
            decoration: BoxDecoration(
              color: colorBG ?? Colorskronoss.background_application_dark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colorskronoss.gray_button,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    )
                  ],
                ),
                SizedBox(height: 10),
                //image
                iconTitle ??
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: sizeIconDefault,
                        height: sizeIconDefault,
                        child: Image.asset(
                          replaceImageAssets ?? IMAGE_LOGO,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                // titulo
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title?.toUpperCase() ?? APP_NAME,
                    style: TextStyle(
                        color: colorTitle,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                //contenido
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: contentChild ??
                      Text(
                        message,
                        style: TextStyle(
                          color: colorTextContent,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                ),
                SizedBox(height: 10),
                //boton
                isBtnShow
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 5,
                            bottom: paddingButtonAdd ? 55 : 25),
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: Material(
                          elevation: 3,
                          color: Colorskronoss.green_button,
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            child: const Text(
                              "CONTINUAR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            elevation: 4.0,
                            onPressed:
                                onpressed ?? () => Navigator.of(context).pop(),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ));
} */

//----