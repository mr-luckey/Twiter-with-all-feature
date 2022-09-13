import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class PushNotificationsServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<RemoteMessage> _messageStream =
      new StreamController.broadcast();
  static Stream<RemoteMessage> get messageStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // debugPrint('onBackground Handler: ${message.messageId}');
    debugPrint('${message.data}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // debugPrint('onMessage Handler: ${message.messageId}');
    debugPrint('${message.data}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // debugPrint('onMessageOpenApp Handler: ${message.messageId}');
    debugPrint('${message.data}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message);
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    debugPrint('Token: $token');
    await SharedPrefs.setString(shared_myDevice, token);

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
