import 'dart:async';
import 'package:driver_app/Models/drivers.dart';
import 'package:driver_app/Notifications/pushNotificationService.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPAge extends StatefulWidget
{

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPAgeState createState() => _HomeTabPAgeState();
}

class _HomeTabPAgeState extends State<HomeTabPAge> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;



  var geoLocator = Geolocator();

  String  driverStatusText = "Offline Now - Go Online";

  Color  driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentDriverInfo();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position,context);
    // print("This is your Address" + address);

  }

  void getCurrentDriverInfo() async{
    currentfirebaseUser =  await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    driverRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapShot) {
      if(dataSnapShot.value != null){
        driversInformation = Drivers.fromSnapshot(dataSnapShot);
      }
    });

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPAge._kGooglePlex,
          myLocationEnabled: true,

          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },

        ),

        //online offline driver Container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: (){


                      if(isDriverAvailable != true){
                        makeDriverOnlineNow();
                        getLocationLiveUpdates();

                        setState(() {
                          driverStatusColor = Colors.green;
                          driverStatusText = "Online Now";
                          isDriverAvailable = true;
                        });

                        Fluttertoast.showToast(msg: "You are Online now");

                      }else{

                        setState(() {
                          driverStatusColor = Colors.black;
                          driverStatusText = "Offline Now - Go Online";
                          isDriverAvailable = false;
                        });

                        makeDriverOffline();
                        Fluttertoast.showToast(msg: "You are Offline now");
                      }
                    },
                    color: driverStatusColor,
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(driverStatusText, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                          Icon(Icons.phone_android, color: Colors.white, size: 26.0,),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),


      ],
    );
  }

  void makeDriverOnlineNow() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);


    rideRequestRef.set("searching");

    rideRequestRef.onValue.listen((event) {

    });
  }

  void getLocationLiveUpdates(){


    homeTabPAgeStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if(isDriverAvailable == true)
      Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);

      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOffline(){
    Geofire.removeLocation(currentfirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;


  }
}
