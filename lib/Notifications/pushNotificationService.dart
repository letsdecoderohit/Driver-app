import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService{

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize() async{
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

      },
    );

  }

  Future<String> getToken() async{
    String token = await firebaseMessaging.getToken();
    print("This is Token ::::::::::::::::::");
    print(token);
    driverRef.child(currentfirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

}