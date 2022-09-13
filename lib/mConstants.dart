import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kronosss/utils.dart';
import 'package:kronosss/Home/home_page.dart';

// GLOBALS VARIABLES

final String APP_NAME = "kronoss";

final String DRAGGABLE_RIGHT_FUNCTION = "funcion deslizable hacia la DERECHA";
final String GESTURE_DETECTOR_SLOW_ERROR =
    "Gesto muy lento, por favor vuelva a intentarlo";

const String giphyDevelopers = "xxxxxxxxxxxxxx";

// MAPBOX
const String token_mapbox = 'xxxxxxxxxxxx';

const String stripePublishableKey = 'xxxxxxxxxxxxxxxx';

// PAYPAL
const String paypal_clientId = 'xxxxxxxxxxxxxxxx';
const String paypal_secret = 'xxxxxxxxxxxxxxxxxxx';

const String TOKEN_AUTH_CLOUD = 'xxxxxxxxxxxxxxxxxx';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

// Esta en desarrollo
DIALOG_NOT_FUNCTION(BuildContext context) => Utils.dialogBottomGeneral(
    context: context,
    isNotImage: true,
    paddingButtonAdd: true,
    title: 'Equipo de kronoss.',
    content: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Text(
            'Estimad@ Usuari@, \nDisculpe las molestias, \nEsta funcion estará disponible pronto.\n\nGracias.'),
      ),
    ));

// URL
final String WebOfficial = "https://www.kronoss.com/";
final String URL_TERM_USE = "https://www.kronoss.com/inicio/condicionesdeuso";
final String URL_PRIVACY = "https://www.kronoss.com/inicio/privacidad";

final String shared_isLogIn = "isLogInApp";
final String shared_user = "dataUser";
final String shared_myDevice = "myDevice";
final String shared_updateToken = "tokenUpdate";
final String shared_email = "email";
final String shared_token = "token";
final String shared_image = "image";
final String shared_image_banner = "imageBanner";
final String shared_name = "name";
final String shared_slogan = "slogan";
final String shared_nickname = "nickname";
final String shared_url_user = "urlUser";
final String shared_sponsor = "sponsor";
final String shared_method = "payment_method";
final String shared_method_id = "payment_method_id";
final String shared_method_icon = "payment_method_icon";
final String shared_idAsociate = 'idAsociatePay';

const Color colorError1 = Color(0xFF420000);
const Color colorError2 = Color(0xFFBD0909);
const String IMAGE_LOGO = "assets/icons/kronos_original.png";
const String IMAGE_LOGO2 = "assets/icons/kronos_original2.png";
const String IMAGE_LOGO3 = "assets/payments/ic_kronoss.png";
const String NOT_IMAGE = "assets/no_available.png";
const String NOT_IMAGE2 = "assets/no_available_banner.png";
const String NOT_IMAGE3 = "assets/icons/cancel.png";
const String LOADING_GIF = "assets/loading.gif";
const String LOADING_GIF2 = "assets/loading2.gif";
const String NOT_IMAGE_PROFILE = "assets/icons/profile.png";
const String IMAGE_GOOGLE = 'assets/icons/logo_google.png';

const String ICON_PAY_CC = 'assets/payments/ic_credit_card.png';
const String ICON_PAY_DRACMA = 'assets/payments/ic_dracma.png';
const String ICON_PAY_GPAY = 'assets/payments/ic_gpay.png';
const String ICON_PAY_PAYPAL = 'assets/payments/ic_paypal.png';
const String ICON_PAY_QR = 'assets/payments/ic_qr.png';
const String ICON_PAY_QR2 = 'assets/payments/ic_qr2.png';
const String ICON_SETTINGS = 'assets/icons/ic_settings.png';
const String IMAGE_kronoss = "assets/payments/ic_kronoss.png";
const String IMAGE_MAIL = "assets/payments/email.png";

final String auxB64 = "data:image/jpeg;base64,";

const MONTH = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

const List<String> payMethodsList = [
  'donate', //0
  'pay-bells', //1
  'pay-article', //2
  'upload-expirines', //3
  'upload-dragmas', //4
  'download-money', //5
  'pay-adsPatrocionio', //6
  'sendUser' //7
];

const List<String> payTypeList = [
  'Paypal', //0
  'Dracmas', //1
  'PayGoogle', //2
  'Stripe', //3
];

const List<String> payStatusList = [
  'completed', //0
  'cancel', //1
  'reclamate', //2
  'executable', //3
];

const List<String> rolesList = [
  //'ADMIN_ROLE',
  'USER_ROLE',
  'JOURNALIST_ROLE',
  'PROFESSIONAL_ROLE',
  'EMPRESA_ROLE',
  'ONG_ROLE',
  //'INFLUENCER_ROLE',
];

const List<String> rolesListText = [
  //'Administrador',
  'Usuario',
  'Periodista',
  'Profecional',
  'Empresa',
  'ONG',
  //'INFLUENCER_ROLE',
];

final List<String> external_link_icons = [
  "assets/payments/ic_bitcoin.png",
  "assets/payments/ic_ethereum.png",
  "assets/payments/ic_tether.png",
  "assets/payments/ic_bizum.png",
  "assets/payments/ic_cashapp.png",
  "assets/payments/ic_patreon.png",
  "assets/payments/ic_venmo.png",
];

final List<String> external_link_names = [
  'Dirección de Bitcoin',
  'Dirección de Ethereum',
  'Dirección de Tether',
  'Bizum',
  'Cash App',
  'Patreon ',
  'Venmo',
];

const String text_acceptPrivacy =
    'Marca esta casilla si estás de acuerdo con nuestras condiciones de uso y política de privacidad.';
final List<String> list_text_accept_privacy = text_acceptPrivacy.split(' ');

final Widget widgetTextAceptPrivacy = RichText(
  text: TextSpan(children: [
    TextSpan(text: 'Marca '),
    TextSpan(text: 'esta '),
    TextSpan(text: 'casilla '),
    TextSpan(text: 'si '),
    TextSpan(text: 'estás '),
    TextSpan(text: 'de '),
    TextSpan(text: 'acuerdo '),
    TextSpan(text: 'con '),
    TextSpan(text: 'nuestras '),
    TextSpan(text: 'condiciones de uso'),
    TextSpan(text: ' y '),
    TextSpan(text: 'política de privacidad'),
    TextSpan(text: '.'),
  ]),
);

const bool sandboxMode = true;

class Constants {
  static final String CANCEL_IMAGE = "assets/icons/cancel.png";

  static final String urlBase = sandboxMode
      ? "http://192.99.167.185:5000"
      : "https://prodapi.dev-kronoss.com";
  //static final String urlBase = "https://prodapi.dev-kronoss.com";

  static final String url_login = "$urlBase/autenticate";
  static final String url_login_google = "$urlBase/autenticate/google";
  static final String url_changeDevice = "$urlBase/changedevice";
  static final String url_regirer_google = "$urlBase/register/google";
  static final String url_regirer = "$urlBase/register";
  static final String url_forgot = "$urlBase/confirmRecuperate";
  static final String url_forgot_send_code = "$urlBase/recuperate";
  static final String url_categories = "$urlBase/categories";
  static final String url_categoriesGeneral = "$urlBase/categoriesGeneral";
  static final String url_publications = "$urlBase/publications";
  static final String url_publicationsForCategories =
      "$urlBase/publicationsForCategories";
  static final String url_publication_resource = "$urlBase/resource";

  static final String url_publicationsUser = "$urlBase/publicationsUser";
  static final String url_profilePublications = "$urlBase/profilePublications";
  static final String url_publicationsUserCategories =
      "$urlBase/publicationsUserCategories";
  static final String url_authNick = "$urlBase/shareNickname";
  static final String url_publicationsSearch = "$urlBase/publicationsShared";
  static final String url_up = "$urlBase/lupa";
  static final String url_info = "$urlBase/info";
  static final String url_infoFilter = "$urlBase/infoFilter";
  static final String url_user_profile_edits = "$urlBase/profile";
  static final String url_user_profile_info = "$urlBase/infoUser";
  static final String url_user_profile_sharedUser = "$urlBase/sharedUser";
  static final String url_comment = '$urlBase/opinion';
  static final String url_commentForPublication =
      '$urlBase/opinionPublications';
  static final String url_operations = '$urlBase/operations';
  static final String url_accounts = '$urlBase/accounts';
  static final String url_paypalpays = '$urlBase/Paypalpays';
  static final String url_stripepays = '$urlBase/stripepays';
  static final String url_stripeIntent = '$urlBase/intent';
  static final String url_removeCoins = '$urlBase/retiros';

  static final String url_users = "$urlBase/users";
  static final String url_mylikes = "$urlBase/mylikes";
  static final String url_myDonate = "$urlBase/profileDonate";
  static final String url_myProduct = "$urlBase/profileProduct";
  static final String ur_save_publications = '$urlBase/savePublications';

  static final String url_html = "$urlBase/autenticate";
  static final String url_token_verification = "$urlBase/tokenVerification";
  static final String url_close_sesion = "$urlBase/closesesion";

  static final String url_chat = "$urlBase/chats";
  static final String url_messages = "$urlBase/messages";
  static final String url_exponsor = "$urlBase/exponsor";
  static final String url_user_notifications = "$urlBase/notifications";

  static final String url_follow = "$urlBase/follow";
  static final String url_followers = "$urlBase/followers";
}

enum ActionEditResources { none, deleted, replace, add }

class MemoryPosition {
  StreamController _controller = StreamController<int>.broadcast();

  Stream get getController => _controller.stream;
  void addPosition(int position) => _controller.add(position);
}

class Colorskronoss {
  static TextStyle styleMention = TextStyle(
      color: Colors.orange, backgroundColor: Colors.orange.withOpacity(0.1));
  static TextStyle styleHashtag = TextStyle(
      color: Colorskronoss.primary_color_frooget, fontWeight: Weight.bold);
  static TextStyle styleUrl =
      TextStyle(color: Colors.blue, decoration: TextDecoration.underline);

  static Gradient gradient_semi = LinearGradient(
    colors: [
      Colors.black26,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black26,
    ],
    stops: [0.0, 0.25, 0.30, 0.375, 0.5, 0.75, 0.8, 0.875, 1.0],
    begin: FractionalOffset.bottomCenter,
    end: FractionalOffset.topCenter,
  );

  static Color primary = Color(0xFF6FD373);
  static Color primary2 = Color(0xFFFD9F4E);
  static Color secundary1 = Color(0xFFC7C7C7);
  static Color secundary2 = Color(0xFFFF5353);
  static Color secundary3 = Color(0xFF69AAF5);

  static Color primary_dark = Color(0xFF181819);
  static Color white_blur = Color(0x66FFFFFF);
  static Color black_blur = Color(0x88000000);

  static Color primary_color_frooget = Color(0xFF66D159);

  static Color colorGrayDark = Color(0xFF696969);
  static Color background_topics = Color(0xFF383838);

  static Color gray_bottom_sheet_line_separator = Color(0xFF707070);
  static Color red_snackbar_error = Color(0xFFC00000);

  //static Color background_application_dark = Color(0xFF181819);
  static Color background_dialog_sheet = Color(0xFF0A0A0A);
  static Color background_application_dark = Colors.black; //Color(0xFF0C0C0C);
  static Color background_application_medium = Color(0xFF292A2C);
}

InputDecoration get getDeco => InputDecoration(
      counter: SizedBox.shrink(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(900),
        borderSide: const BorderSide(color: Colors.white),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(900),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(900),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(900),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.all(3),
      hintStyle: style.copyWith(color: Colors.white70),
    );

InputDecoration get getNoDeco => InputDecoration(
      counter: SizedBox.shrink(),
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: const EdgeInsets.all(3),
      hintStyle: style.copyWith(color: Colors.white70),
    );

InputDecoration get getSearchDeco => InputDecoration(
      contentPadding: EdgeInsets.only(bottom: 10),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
        child: Image.asset('assets/icons/ic_menu_2.png'),
      ),
    );

InputDecoration getSearchDecoCustom([EdgeInsets? padding]) => InputDecoration(
      contentPadding: EdgeInsets.only(bottom: 10),
      prefixIcon: Padding(
        padding: padding ?? EdgeInsets.only(top: 5, right: 5, bottom: 5),
        child: Image.asset('assets/icons/ic_menu_2.png'),
      ),
    );

InputDecoration getDeco2(
        {double radius = 900, hint = '', TextStyle? hintStyle}) =>
    InputDecoration(
      counter: SizedBox.shrink(),
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.white),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.all(3),
      hintStyle: hintStyle?.copyWith(color: Colors.white70) ??
          style.copyWith(color: Colors.white70),
    );

mixin Weight {
  static var bold;
}

const String loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vel velit mollis, sagittis odio nec, suscipit massa. Aenean nec euismod lectus, varius dapibus quam. Donec tortor enim, dictum eget sodales non, commodo et ipsum. Nullam vel felis erat. Nullam sodales lectus a lorem luctus, in dictum sapien ornare. Praesent euismod finibus lacus, eu vehicula nisi mollis quis. Ut quis felis vitae erat vestibulum tincidunt a quis ligula. Integer condimentum, ipsum vitae maximus euismod, orci nunc tincidunt dui, sed dignissim orci elit non arcu. Vivamus a vehicula dolor. Phasellus congue in ante id convallis. Nulla arcu est, condimentum sit amet luctus vitae, feugiat in velit. Nullam nec ante maximus, malesuada eros eu, gravida mi. Nunc sodales scelerisque augue, a ultrices ipsum eleifend ac. Mauris ac bibendum quam, a ultricies sem. Duis sodales congue lorem at efficitur. Nam sed maximus neque, nec convallis sem.
Proin quis augue id mauris pretium pellentesque. Nulla faucibus posuere turpis pulvinar imperdiet. Aliquam quam velit, laoreet quis congue vitae, molestie ac ligula. Suspendisse tempor metus eget risus molestie vulputate. Vivamus eu porttitor est. Duis id sapien volutpat, interdum ante sed, cursus mauris. Aenean tristique tincidunt blandit. Curabitur nec augue gravida, congue nisl ullamcorper, volutpat erat. Aliquam facilisis tincidunt semper. Pellentesque nisl metus, aliquet vitae sem et, hendrerit porta sapien. Sed hendrerit diam nec dui iaculis malesuada.
In hac habitasse platea dictumst. Proin justo neque, gravida vitae eros id, suscipit tincidunt purus. Aenean lorem arcu, aliquam id porttitor vel, malesuada quis dui. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam euismod, eros a hendrerit congue, metus justo ornare purus, facilisis eleifend nisl sem vel orci. Cras rutrum lectus et neque tempor, eu tincidunt est pretium. Vivamus posuere sapien quis diam iaculis egestas. Cras nec velit et tortor venenatis suscipit. Integer et ex odio. Sed in risus at ligula luctus tincidunt. Cras sit amet scelerisque est. Suspendisse efficitur sodales diam, vel porttitor sem laoreet vitae. Vivamus sit amet risus ultricies nunc suscipit pellentesque et et elit.
Donec aliquet elit et turpis vulputate lacinia. Phasellus nibh elit, auctor sit amet urna sed, ullamcorper consectetur elit. Phasellus vitae ante ultrices, cursus mauris et, suscipit diam. Morbi et arcu purus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent elementum neque non est suscipit iaculis. Cras efficitur rutrum facilisis. Maecenas vel tellus quis tortor suscipit pretium nec vitae metus. Duis semper ante sit amet ornare rhoncus. Nullam varius tortor et enim viverra ornare.
Praesent facilisis efficitur nibh, sed feugiat metus molestie in. Nunc in leo a elit consequat volutpat. Nunc in nibh a turpis gravida sagittis eget eget sem. Cras pulvinar erat id ultricies finibus. Vivamus commodo quam at lectus ultrices, in placerat nunc placerat. Ut accumsan ante ut libero semper, ac suscipit lectus volutpat. Maecenas consectetur rutrum magna non dignissim. Suspendisse eu lacus scelerisque, sagittis lorem in, pulvinar nulla. Vivamus consequat porta aliquet. 
''';
