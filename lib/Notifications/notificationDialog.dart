import 'package:audioplayers/audio_cache.dart';
import 'package:driver_app/AllScreens/newRideScreen.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/rideDetails.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDialog extends StatelessWidget {

  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {



    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 2.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("assets/images/taxi.png", width: 120.0,),
            SizedBox(height: 18.0),
            Text("New Ride Request", style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18.0),),
            SizedBox(height: 18.0),
           Padding(padding: EdgeInsets.all(18.0),
             child: Column(
               children: [
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Image.asset("assets/images/pickicon.png",height: 16.0, width: 16.0,),
                     SizedBox(width: 20.0),
                     Expanded(child: Container(child: Text(rideDetails.pickup_address, style: TextStyle(fontSize: 18.0),))),
                   ],
                 ),
                 SizedBox(height: 15.0),

                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Image.asset("assets/images/desticon.png",height: 16.0, width: 16.0,),
                     SizedBox(width: 20.0),
                     Expanded(child: Container(child: Text(rideDetails.drofoff_address, style: TextStyle(fontSize: 18.0),))),
                   ],
                 ),
                 SizedBox(height: 15.0),
               ],
             ),
           ),
            SizedBox(height: 20.0),
            Divider(height: 2.0, color: Colors.black,thickness: 2.0,),
            SizedBox(height: 8.0),

            Padding(padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: (){
                      player2.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                ),

                SizedBox(width: 20.0),

                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    player2.stop();
                    checkAvailabilityOfRide(context);
                  },
                  child: Text(
                    "Accept".toUpperCase(),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
            ),

            SizedBox(height: 10.0),


          ],
        ),
      ),
    );
  }


  void checkAvailabilityOfRide(context){

  rideRequestRef.once().then((DataSnapshot dataSnapshot){
    AssistantMethods.disableHomeTabLiveLocationUpdates();
    Navigator.pop(context);

    String theRideId = "";

    if(dataSnapshot != null){
      theRideId = dataSnapshot.value.toString();
    }else{
      Fluttertoast.showToast(msg: "Ride Not Exists");
    }


    if(theRideId == rideDetails.ride_request_id){
      rideRequestRef.set("accepted");
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewRideScreen(rideDetails: rideDetails)));
    }
    else if(theRideId == "cancelled"){
      Fluttertoast.showToast(msg: "Ride has been cancelled");
    }
    else if(theRideId == "timeout"){
      Fluttertoast.showToast(msg: "Ride has time out");
    }
    else{
      Fluttertoast.showToast(msg: "Ride Not Exists");
    }
  });
  }

}
