import 'package:flutter/material.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ComplaintReelScreen extends StatefulWidget {
  final PublicationModel publication;
  ComplaintReelScreen({required this.publication});

  @override
  _ComplaintReelScreenState createState() => _ComplaintReelScreenState();
}

class _ComplaintReelScreenState extends State<ComplaintReelScreen> {
  late PublicationModel publication;

  @override
  void initState() {
    publication = widget.publication;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colorskronoss.background_application_dark,
        appBar: appbar(
          'Denuncia',
          leading: () => Navigator.of(context).pop(),
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          "assets/icons/resource_email.png",
                          width: 25,
                          color: Colors.white,
                        ),
                        Text(
                          '   Envíanos un e-mail',
                          style: styleTitles,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('¿En qué podemos ayudarte?', style: style),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Envíanos en e-mail pulsando en el enlace',
                            style: style),
                      ],
                    ),
                    SizedBox(height: 20),
                    buttonOutline(
                      text: 'Contacte con nosotros',
                      mainAxisAlignment: MainAxisAlignment.center,
                      onTap: () => onPressed(context),
                    ),
                  ],
                ))));
  }

  void onPressed(BuildContext context) async {
    Navigator.of(context).pop();
    var mailContent = EmailContent(
      to: ['help@kronos.com'],
      //cc: ['cc'],
      //bcc: ['bcc'],
      subject: '¿En qué podemos ayudarte?',
      body:
          'Deseo poner una denuncia al creador de la publicación (${publication.id}), porque ',
    );
    // Android: Will open mail app or show native picker.
    // iOS: Will open mail app if single mail app found.
    var result =
        await OpenMailApp.composeNewEmailInMailApp(emailContent: mailContent);

    debugPrint('didOpen: ${result.didOpen} && canOpen: ${result.canOpen}');

    // If no mail apps found, show error
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);

      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
              mailApps: result.options, emailContent: mailContent);
        },
      );
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Open Mail App",
            style: style.copyWith(color: Colors.black),
          ),
          content: Text(
            "No mail apps installed",
            style: style.copyWith(color: Colors.black),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "OK",
                style: style.copyWith(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
