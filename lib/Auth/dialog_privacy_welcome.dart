import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DialogPrivacyWelcome {
  DialogPrivacyWelcome(this.context);

  final BuildContext context;

  final String title = 'Política de privacidad ';
  final String content =
      'Además de los datos personales que kronoss recopila y procesa sobre ti, tal y como describe nuestra Política de privacidad, nuestros colaboradores publicitarios también almacenan o acceden a información que se encuentra en tu dispositivo, además de tratar algunos datos personales, como tus identificadores únicos, tu actividad de navegación y otra información habitual enviada por el dispositivo, entre la que se incluye tu dirección IP. Estos datos se recopilan con el transcurso del tiempo y se utilizan para ofrecerte anuncios personalizados, medir su rendimiento, obtener información sobre el público al que se muestran y desarrollar productos específicos de nuestro programa publicitario. Si estás de acuerdo con todo lo indicado anteriormente, elige la opción «Acepto» a continuación. Por otro lado, puedes obtener más información, personalizar tus preferencias de consentimiento o denegarlo haciendo clic en «Más opciones». Ten en cuenta que tus preferencias solo se aplicarán en kronoss. Si cambias de opinión más adelante, podrás modificarlas en cualquier momento desde tus opciones de privacidad. Por último, debes tener en cuenta que, aunque no des tu consentimiento, nuestros colaboradores seguirán pudiendo procesar algunos de tus datos cuando se destinen a intereses legítimos. Sin embargo, puedes desactivar la opción de ceder datos para usos legítimos utilizando el botón «Más información»; después, solo tendrás que buscar la opción correspondiente en las secciones «Fines» o «Colaboradores».';
  final String textButton = 'ACEPTAR';

  show({void Function()? onAccept, void Function()? onTap}) {
    DialogsUtils(context).showDialogChildWidget(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Text(title, style: styleTitles),
            SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: content,
                    style: style,
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onAccept,
              child: Container(
                width: double.maxFinite,
                height: 50,
                decoration: deco14,
                child: Center(
                  child: Text(
                    textButton,
                    style: styleTitles,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    /* showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title, style: styleTitles),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: content,
                style: styleTitles,
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(textButton, style: styleTitles),
            onPressed: onAccept,
          )
        ],
      ),
    ); */
  }
}
