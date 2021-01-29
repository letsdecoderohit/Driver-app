import 'dart:io' show Platform;

import 'package:driver_app/Models/rideDetails.dart';
import 'package:driver_app/Notifications/notificationDialog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PushNotificationService{

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async{
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);

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

  String getRideRequestId(Map<String, dynamic> message){

    String rideRequestID ="";
    if(Platform.isAndroid){
      rideRequestID = message['data']['ride_request_id'];
    }
    else{
      rideRequestID = message['ride_request_id'];
    }
    return rideRequestID;
  }


  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapShot)  {
      if(dataSnapShot.value != null){


        player2.setAsset('assets/sounds/alert.mp3');
        player2.play();


        double pickUpLocationLat = double.parse(dataSnapShot.value['pickup']['latitude'].toString());
        double pickUpLocationLng = double.parse(dataSnapShot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapShot.value['pickup_address'].toString();

        double dropOffLocationLat = double.parse(dataSnapShot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng = double.parse(dataSnapShot.value['dropoff']['longitude'].toString());
        String dropOffAddress = dataSnapShot.value['drofoff_address'].toString();


        String paymentMethod = dataSnapShot.value['payment_method'].toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.drofoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method= paymentMethod;

        print("Information");
        print(rideDetails.pickup_address);
        print(rideDetails.drofoff_address);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)  => NotificationDialog(rideDetails: rideDetails,),
        );

      }
    });
  }

}