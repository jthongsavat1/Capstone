import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //create a instance
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize notifications
  Future<void> initNotifications() async {
    //request permission from user (will prompt them)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    //print the token
    print ('Token: $fCMToken');
  }

  //function to handle messages

  //function to initalize foreground and background settings
}